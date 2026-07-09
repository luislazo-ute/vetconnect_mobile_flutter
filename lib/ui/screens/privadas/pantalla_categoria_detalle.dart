import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/categoria_producto.dart';
import '../../../domain/entities/rol.dart';
import '../../providers/rol_provider.dart';
import 'pantalla_categoria_formulario.dart';

class PantallaCategoriaDetalle extends ConsumerWidget {
  final CategoriaProducto categoria;
  const PantallaCategoriaDetalle({super.key, required this.categoria});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final esAdmin = ref.watch(rolActualProvider) == Rol.admin;
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de categoría'),
        actions: [
          if (esAdmin)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => PantallaCategoriaFormulario(categoria: categoria),
                  ),
                );
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(categoria.nombre, style: textos.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _Campo('Descripción', categoria.descripcion.isEmpty ? 'Sin descripción' : categoria.descripcion),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: categoria.isActive ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Text(categoria.isActive ? 'Activa' : 'Inactiva',
                  style: TextStyle(
                    color: categoria.isActive ? Colors.green : Colors.red,
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
