import 'package:flutter/material.dart';

import '../../../core/imagenes.dart';
import '../../../domain/entities/galeria_foto.dart';

class PantallaGaleriaDetalle extends StatelessWidget {
  final GaleriaFoto foto;
  const PantallaGaleriaDetalle({super.key, required this.foto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foto')),
      body: ListView(
        children: [
          Hero(
            tag: 'foto-${foto.id}',
            child: Image(
              image: proveedorImagen(foto.url),
              width: double.infinity,
              height: 320,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stack) => Container(
                    height: 320,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.broken_image,
                      size: 64,
                      color: Colors.grey,
                    ),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              foto.descripcion.isEmpty ? 'Sin descripción' : foto.descripcion,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
