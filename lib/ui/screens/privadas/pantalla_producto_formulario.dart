import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/categoria_producto.dart';
import '../../../domain/entities/producto.dart';
import '../../notifiers/categorias_notifier.dart';
import '../../notifiers/productos_notifier.dart';
import '../../providers/producto_providers.dart';

class PantallaProductoFormulario extends ConsumerStatefulWidget {
  final Producto? producto;
  const PantallaProductoFormulario({super.key, this.producto});

  @override
  ConsumerState<PantallaProductoFormulario> createState() => _FormState();
}

class _FormState extends ConsumerState<PantallaProductoFormulario> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _descripcionCtrl;
  late final TextEditingController _precioCtrl;
  late final TextEditingController _stockCtrl;
  int? _categoriaId;
  bool _isActive = true;
  bool _guardando = false;

  bool get _esEdicion => widget.producto != null;

  @override
  void initState() {
    super.initState();
    final p = widget.producto;
    _nombreCtrl = TextEditingController(text: p?.nombre ?? '');
    _descripcionCtrl = TextEditingController(text: p?.descripcion ?? '');
    _precioCtrl = TextEditingController(
        text: p != null ? p.precio.toStringAsFixed(2) : '');
    _stockCtrl = TextEditingController(text: p?.stock.toString() ?? '');
    _categoriaId = p?.categoria;
    _isActive = p?.isActive ?? true;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descripcionCtrl.dispose();
    _precioCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    final datos = <String, dynamic>{
      'nombre': _nombreCtrl.text.trim(),
      'descripcion': _descripcionCtrl.text.trim(),
      'precio_venta': _precioCtrl.text.trim(),
      'stock_actual': int.parse(_stockCtrl.text.trim()),
      'categoria': _categoriaId,
      'is_active': _isActive,
    };

    final messenger = ScaffoldMessenger.of(context);
    try {
      if (_esEdicion) {
        await ref.read(actualizarProductoUcProvider)(widget.producto!.id, datos);
      } else {
        await ref.read(crearProductoUcProvider)(datos);
      }
      ref.read(productosNotifierProvider.notifier).cargar();
      if (mounted) {
        Navigator.of(context).pop();
        messenger.showSnackBar(
          SnackBar(
            content: Text(_esEdicion ? 'Producto actualizado' : 'Producto creado'),
          ),
        );
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
    final categoriasState = ref.watch(categoriasNotifierProvider);
    final categorias = categoriasState.categorias
        .where((c) => c.isActive)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar producto' : 'Nuevo producto'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'El nombre es obligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descripcionCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _precioCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Precio',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'El precio es obligatorio';
                if (double.tryParse(v.trim()) == null) return 'Precio inválido';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _stockCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Stock',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'El stock es obligatorio';
                if (int.tryParse(v.trim()) == null) return 'Stock inválido';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: _categoriaId,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
              ),
              items: categorias
                  .map((CategoriaProducto c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.nombre),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _categoriaId = v),
              validator: (v) => v == null ? 'Selecciona una categoría' : null,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Activo'),
              value: _isActive,
              onChanged: (v) => setState(() => _isActive = v),
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
                  : Text(_esEdicion ? 'Guardar cambios' : 'Crear producto'),
            ),
          ],
        ),
      ),
    );
  }
}
