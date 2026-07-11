import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/imagenes.dart';
import '../../../domain/entities/rol.dart';
import '../../providers/galeria_providers.dart';
import '../../providers/rol_provider.dart';
import 'pantalla_galeria_detalle.dart';
import 'pantalla_galeria_formulario.dart';

class PantallaGaleria extends ConsumerWidget {
  const PantallaGaleria({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(galeriaProvider);
    final esAdmin = ref.watch(rolActualProvider) == Rol.admin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Galería'),
        actions: [
          if (esAdmin)
            IconButton(
              icon: const Icon(Icons.add_a_photo_outlined),
              onPressed:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PantallaGaleriaFormulario(),
                    ),
                  ),
            ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (e, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$e'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => ref.invalidate(galeriaProvider),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
        data: (fotos) {
          if (fotos.isEmpty) {
            return const Center(child: Text('No hay fotos aún.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: fotos.length,
            itemBuilder: (context, i) {
              final f = fotos[i];
              return GestureDetector(
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PantallaGaleriaDetalle(foto: f),
                      ),
                    ),
                child: Hero(
                  tag: 'foto-${f.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image(
                      image: proveedorImagen(f.url),
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stack) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.broken_image,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
