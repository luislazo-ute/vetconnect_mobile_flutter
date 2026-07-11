import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/rol.dart';
import '../../providers/factura_providers.dart';
import '../../providers/rol_provider.dart';

class PantallaFacturaDetalle extends ConsumerWidget {
  final int facturaId;
  const PantallaFacturaDetalle({super.key, required this.facturaId});

  Future<void> _registrarPago(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final datos = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => _DialogoPago(facturaId: facturaId),
    );
    if (datos == null) return;
    try {
      await ref.read(registrarPagoUcProvider)(datos);
      ref.invalidate(facturaDetalleProvider(facturaId));
      messenger.showSnackBar(const SnackBar(content: Text('Pago registrado')));
    } on ExcepcionApi catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.mensaje), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(facturaDetalleProvider(facturaId));
    final esAdmin = ref.watch(rolActualProvider) == Rol.admin;
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('Factura #$facturaId')),
      floatingActionButton: esAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _registrarPago(context, ref),
              icon: const Icon(Icons.payments_outlined),
              label: const Text('Registrar pago'),
            )
          : null,
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No se pudo cargar la factura.'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.invalidate(facturaDetalleProvider(facturaId)),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (factura) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
          children: [
            Text('Cliente: ${factura.clienteUsername}',
                style: textos.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _Campo('Fecha', factura.fecha.split('T').first),
            const SizedBox(height: 8),
            _Campo('Estado', factura.pagada ? 'Pagada' : 'Pendiente'),
            const SizedBox(height: 8),
            _Campo('Total', factura.totalFormateado),
            const SizedBox(height: 24),
            Text('Servicios',
                style: textos.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (factura.detalles.isEmpty)
              const Text('Sin líneas registradas.')
            else
              ...factura.detalles.map(
                (d) => Card(
                  child: ListTile(
                    title: Text(d.servicioNombre),
                    subtitle: Text(
                      '${d.cantidad} x \$${d.precioUnitario.toStringAsFixed(2)}',
                    ),
                    trailing: Text(
                      '\$${d.subtotal.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Text('Pagos',
                style: textos.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (factura.pagos.isEmpty)
              const Text('Sin pagos registrados.')
            else
              ...factura.pagos.map(
                (p) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.payments_outlined),
                    title: Text(p.montoFormateado),
                    subtitle: Text(
                      '${p.metodoDisplay}${p.referencia.isNotEmpty ? ' · ${p.referencia}' : ''}',
                    ),
                    trailing: Text(p.fechaPago.split('T').first),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DialogoPago extends StatefulWidget {
  final int facturaId;
  const _DialogoPago({required this.facturaId});

  @override
  State<_DialogoPago> createState() => _DialogoPagoState();
}

class _DialogoPagoState extends State<_DialogoPago> {
  final _formKey = GlobalKey<FormState>();
  final _montoCtrl = TextEditingController();
  final _referenciaCtrl = TextEditingController();
  String _metodo = 'efectivo';

  @override
  void dispose() {
    _montoCtrl.dispose();
    _referenciaCtrl.dispose();
    super.dispose();
  }

  void _confirmar() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, <String, dynamic>{
      'factura': widget.facturaId,
      'monto': _montoCtrl.text.trim(),
      'metodo_pago': _metodo,
      'referencia': _referenciaCtrl.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Registrar pago'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _montoCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monto',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final n = double.tryParse(v?.trim() ?? '');
                if (n == null || n <= 0) return 'Monto inválido';
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _metodo,
              decoration: const InputDecoration(
                labelText: 'Método',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'efectivo', child: Text('Efectivo')),
                DropdownMenuItem(value: 'tarjeta', child: Text('Tarjeta')),
                DropdownMenuItem(value: 'transferencia', child: Text('Transferencia')),
                DropdownMenuItem(value: 'otro', child: Text('Otro')),
              ],
              onChanged: (v) => setState(() => _metodo = v ?? 'efectivo'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _referenciaCtrl,
              decoration: const InputDecoration(
                labelText: 'Referencia (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _confirmar, child: const Text('Guardar')),
      ],
    );
  }
}

class _Campo extends StatelessWidget {
  final String etiqueta;
  final String valor;
  const _Campo(this.etiqueta, this.valor);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(etiqueta,
              style: TextStyle(
                fontSize: 13,
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              )),
        ),
        Expanded(child: Text(valor, style: const TextStyle(fontSize: 15))),
      ],
    );
  }
}
