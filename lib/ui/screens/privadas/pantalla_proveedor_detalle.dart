import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/proveedor.dart';
import '../../../domain/entities/rol.dart';
import '../../providers/rol_provider.dart';
import 'pantalla_proveedor_formulario.dart';

class PantallaProveedorDetalle extends ConsumerWidget {
  final Proveedor proveedor;
  const PantallaProveedorDetalle({super.key, required this.proveedor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final esAdmin = ref.watch(rolActualProvider) == Rol.admin;
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del proveedor'),
        actions: [
          if (esAdmin)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => PantallaProveedorFormulario(proveedor: proveedor),
                  ),
                );
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(proveedor.nombre,
              style: textos.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _Campo('Contacto', proveedor.contacto.isEmpty ? 'Sin contacto' : proveedor.contacto),
          const SizedBox(height: 16),
          _Campo('Teléfono', proveedor.telefono.isEmpty ? 'Sin teléfono' : proveedor.telefono),
          const SizedBox(height: 16),
          _Campo('Email', proveedor.email.isEmpty ? 'Sin email' : proveedor.email),
          const SizedBox(height: 16),
          _Campo('Dirección', proveedor.direccion.isEmpty ? 'Sin dirección' : proveedor.direccion),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: proveedor.isActive ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Text(proveedor.isActive ? 'Activo' : 'Inactivo',
                  style: TextStyle(
                    color: proveedor.isActive ? Colors.green : Colors.red,
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
