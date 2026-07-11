import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/producto.dart';
import '../../../domain/entities/proveedor.dart';
import '../../notifiers/compras_notifier.dart';
import '../../notifiers/productos_notifier.dart';
import '../../notifiers/proveedores_notifier.dart';
import '../../providers/compra_providers.dart';

class _LineaCompra {
  int? productoId;
  String cantidad = '1';
  String precio = '';

  double get subtotal {
    final c = int.tryParse(cantidad) ?? 0;
    final p = double.tryParse(precio) ?? 0;
    return c * p;
  }
}

class PantallaCompraFormulario extends ConsumerStatefulWidget {
  const PantallaCompraFormulario({super.key});

  @override
  ConsumerState<PantallaCompraFormulario> createState() => _FormState();
}

class _FormState extends ConsumerState<PantallaCompraFormulario> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _numeroCtrl;
  int? _proveedorId;
  String _estado = 'pendiente';
  bool _guardando = false;
  final List<_LineaCompra> _lineas = [];

  @override
  void initState() {
    super.initState();
    _numeroCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _numeroCtrl.dispose();
    super.dispose();
  }

  double get _total => _lineas.fold(0, (suma, l) => suma + l.subtotal);

  void _agregarLinea() => setState(() => _lineas.add(_LineaCompra()));
  void _removerLinea(int i) => setState(() => _lineas.removeAt(i));

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_lineas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agrega al menos un producto'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _guardando = true);

    final datos = <String, dynamic>{
      'proveedor': _proveedorId,
      'numero_factura': _numeroCtrl.text.trim(),
      'total': _total.toStringAsFixed(2),
      'estado': _estado,
    };
    final detalles = _lineas
        .map((l) => <String, dynamic>{
              'producto': l.productoId,
              'cantidad': int.tryParse(l.cantidad) ?? 1,
              'precio_unitario': (double.tryParse(l.precio) ?? 0).toStringAsFixed(2),
              'subtotal': l.subtotal.toStringAsFixed(2),
            })
        .toList();

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(crearCompraUcProvider)(datos: datos, detalles: detalles);
      ref.read(comprasNotifierProvider.notifier).cargar();
      if (mounted) {
        Navigator.of(context).pop();
        messenger.showSnackBar(const SnackBar(content: Text('Compra registrada')));
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
    final proveedores = ref
        .watch(proveedoresNotifierProvider)
        .proveedores
        .where((p) => p.isActive)
        .toList();
    final productos = ref
        .watch(productosNotifierProvider)
        .productos
        .where((p) => p.isActive)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva compra')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            DropdownButtonFormField<int>(
              initialValue: _proveedorId,
              decoration: const InputDecoration(
                labelText: 'Proveedor',
                border: OutlineInputBorder(),
              ),
              items: proveedores
                  .map((Proveedor p) => DropdownMenuItem(
                        value: p.id,
                        child: Text(p.nombre),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _proveedorId = v),
              validator: (v) => v == null ? 'Selecciona un proveedor' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _numeroCtrl,
              decoration: const InputDecoration(
                labelText: 'N° de factura (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _estado,
              decoration: const InputDecoration(
                labelText: 'Estado',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'pendiente', child: Text('Pendiente')),
                DropdownMenuItem(value: 'completada', child: Text('Completada')),
                DropdownMenuItem(value: 'cancelada', child: Text('Cancelada')),
              ],
              onChanged: (v) => setState(() => _estado = v ?? 'pendiente'),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Productos',
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
                  (e) => _cardLinea(e.key, e.value, productos),
                ),
            const SizedBox(height: 16),
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
                  : const Text('Registrar compra'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _cardLinea(int index, _LineaCompra linea, List<Producto> productos) {
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
                    initialValue: linea.productoId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Producto',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: productos
                        .map((Producto p) => DropdownMenuItem(
                              value: p.id,
                              child: Text(p.nombre, overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => linea.productoId = v),
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
