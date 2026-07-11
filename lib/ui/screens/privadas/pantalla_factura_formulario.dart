import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/cliente.dart';
import '../../../domain/entities/servicio.dart';
import '../../notifiers/facturas_notifier.dart';
import '../../notifiers/servicios_notifier.dart';
import '../../providers/cliente_providers.dart';
import '../../providers/factura_providers.dart';

class _LineaFactura {
  int? servicioId;
  String cantidad = '1';
  String precio = '';

  double get subtotal {
    final c = int.tryParse(cantidad) ?? 0;
    final p = double.tryParse(precio) ?? 0;
    return c * p;
  }
}

class PantallaFacturaFormulario extends ConsumerStatefulWidget {
  const PantallaFacturaFormulario({super.key});

  @override
  ConsumerState<PantallaFacturaFormulario> createState() => _FormState();
}

class _FormState extends ConsumerState<PantallaFacturaFormulario> {
  final _formKey = GlobalKey<FormState>();
  int? _clienteId;
  bool _pagada = false;
  bool _guardando = false;
  final List<_LineaFactura> _lineas = [];

  double get _total => _lineas.fold(0, (suma, l) => suma + l.subtotal);

  void _agregarLinea() => setState(() => _lineas.add(_LineaFactura()));
  void _removerLinea(int i) => setState(() => _lineas.removeAt(i));

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_lineas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agrega al menos un servicio'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _guardando = true);

    final datos = <String, dynamic>{
      'cliente': _clienteId,
      'total': _total.toStringAsFixed(2),
      'pagada': _pagada,
    };
    final detalles = _lineas
        .map((l) => <String, dynamic>{
              'servicio': l.servicioId,
              'cantidad': int.tryParse(l.cantidad) ?? 1,
              'precio_unitario': (double.tryParse(l.precio) ?? 0).toStringAsFixed(2),
              'subtotal': l.subtotal.toStringAsFixed(2),
            })
        .toList();

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(crearFacturaUcProvider)(datos: datos, detalles: detalles);
      ref.read(facturasNotifierProvider.notifier).cargar();
      if (mounted) {
        Navigator.of(context).pop();
        messenger.showSnackBar(const SnackBar(content: Text('Factura creada')));
      }
    } on ExcepcionApi catch (e) {
      if (mounted) setState(() => _guardando = false);
      messenger.showSnackBar(
        SnackBar(content: Text(e.mensaje), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientes = ref.watch(clientesProvider).maybeWhen(
          data: (d) => d,
          orElse: () => const <Cliente>[],
        );
    final servicios = ref
        .watch(serviciosNotifierProvider)
        .servicios
        .where((s) => s.isActive)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva factura')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            DropdownButtonFormField<int>(
              initialValue: _clienteId,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Cliente',
                border: OutlineInputBorder(),
              ),
              items: clientes
                  .map((Cliente c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.username, overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _clienteId = v),
              validator: (v) => v == null ? 'Selecciona un cliente' : null,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Servicios',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _agregarLinea,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar'),
                ),
              ],
            ),
            ..._lineas.asMap().entries.map(
                  (e) => _cardLinea(e.key, e.value, servicios),
                ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Marcar como pagada'),
              value: _pagada,
              onChanged: (v) => setState(() => _pagada = v),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total: \$${_total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _guardando ? null : _guardar,
              child: _guardando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Crear factura'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _cardLinea(int index, _LineaFactura linea, List<Servicio> servicios) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: linea.servicioId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Servicio',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: servicios
                        .map((Servicio s) => DropdownMenuItem(
                              value: s.id,
                              child: Text(s.nombre, overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        linea.servicioId = v;
                        final serv = servicios.where((s) => s.id == v);
                        if (serv.isNotEmpty && linea.precio.isEmpty) {
                          linea.precio = serv.first.precio.toStringAsFixed(2);
                        }
                      });
                    },
                    validator: (v) => v == null ? 'Selecciona' : null,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _removerLinea(index),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: linea.cantidad,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (v) => setState(() => linea.cantidad = v),
                    validator: (v) {
                      final n = int.tryParse(v?.trim() ?? '');
                      if (n == null || n <= 0) return 'Inválido';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    key: ValueKey('precio_${index}_${linea.precio}'),
                    initialValue: linea.precio,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Precio unit.',
                      prefixText: '\$',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (v) => setState(() => linea.precio = v),
                    validator: (v) {
                      final n = double.tryParse(v?.trim() ?? '');
                      if (n == null || n < 0) return 'Inválido';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Text('Subtotal: \$${linea.subtotal.toStringAsFixed(2)}'),
            ),
          ],
        ),
      ),
    );
  }
}
