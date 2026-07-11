import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/producto.dart';
import '../../../domain/entities/rol.dart';
import '../../providers/rol_provider.dart';
import 'pantalla_producto_formulario.dart';

class PantallaProductoDetalle extends ConsumerWidget {
  final Producto producto;
  const PantallaProductoDetalle({super.key, required this.producto});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final esAdmin = ref.watch(rolActualProvider) == Rol.admin;
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del producto'),
        actions: [
          if (esAdmin)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => PantallaProductoFormulario(producto: producto),
                  ),
                );
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(producto.nombre, style: textos.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _Campo('Descripción', producto.descripcion.isEmpty ? 'Sin descripción' : producto.descripcion),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _Campo('Precio', producto.precioFormateado)),
              const SizedBox(width: 16),
              Expanded(child: _Campo('Stock', '${producto.stock}')),
            ],
          ),
          const SizedBox(height: 16),
          _Campo('Categoría', producto.categoriaNombre),
          const SizedBox(height: 16),
          Row(
            children: [
              _IndicadorEstado(activo: producto.isActive),
              const SizedBox(width: 12),
              Text(producto.isActive ? 'Activo' : 'Inactivo',
                  style: TextStyle(
                    color: producto.isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ],
      ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta,
            style: TextStyle(
              fontSize: 12,
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            )),
        const SizedBox(height: 4),
        Text(valor, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}

class _IndicadorEstado extends StatelessWidget {
  final bool activo;
  const _IndicadorEstado({required this.activo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: activo ? Colors.green : Colors.red,
      ),
    );
  }
}
