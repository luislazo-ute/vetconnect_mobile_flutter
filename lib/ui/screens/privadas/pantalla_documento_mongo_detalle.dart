import 'package:flutter/material.dart';

import '../../../domain/entities/documento_mongo.dart';

/// Detalle genérico de un documento Mongo: muestra todos sus campos.
class PantallaDocumentoMongoDetalle extends StatelessWidget {
  final String titulo;
  final DocumentoMongo doc;

  const PantallaDocumentoMongoDetalle({
    super.key,
    required this.titulo,
    required this.doc,
  });

  @override
  Widget build(BuildContext context) {
    final entradas = doc.datos.entries.toList();
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.tag),
            title: const Text('_id'),
            subtitle: Text(doc.id),
          ),
          const Divider(),
          ...entradas.map((e) => ListTile(
                title: Text(e.key),
                subtitle: Text('${e.value}'),
              )),
        ],
      ),
    );
  }
}
