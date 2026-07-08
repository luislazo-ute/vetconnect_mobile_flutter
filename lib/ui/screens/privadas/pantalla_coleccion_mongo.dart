import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/colecciones_mongo.dart';
import '../../../domain/entities/documento_mongo.dart';
import '../../../domain/entities/rol.dart';
import '../../providers/mongo_providers.dart';
import '../../providers/rol_provider.dart';
import 'pantalla_documento_mongo_detalle.dart';
import 'pantalla_documento_mongo_formulario.dart';

class PantallaColeccionMongo extends ConsumerWidget {
  final ColeccionMongo config;
  const PantallaColeccionMongo({super.key, required this.config});

  String _titulo(DocumentoMongo d) {
    if (config.campos.isEmpty) return d.id;
    final c = config.campos.first;
    return '${c.etiqueta}: ${d.datos[c.clave] ?? '—'}';
  }

  String _subtitulo(DocumentoMongo d) => config.campos
      .skip(1)
      .map((c) => '${c.etiqueta}: ${d.datos[c.clave] ?? '—'}')
      .join(' · ');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(documentosMongoProvider(config.coleccion));
    final esAdmin = ref.watch(rolActualProvider) == Rol.admin;

    return Scaffold(
      appBar: AppBar(
        title: Text(config.titulo),
        actions: [
          if (esAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) =>
                              PantallaDocumentoMongoFormulario(config: config),
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
                    onPressed:
                        () => ref.invalidate(
                          documentosMongoProvider(config.coleccion),
                        ),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
        data: (docs) {
          if (docs.isEmpty) {
            return const Center(child: Text('No hay registros.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Icon(config.icono)),
                  title: Text(_titulo(d)),
                  subtitle: Text(_subtitulo(d)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => PantallaDocumentoMongoDetalle(
                                titulo: config.titulo,
                                doc: d,
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
