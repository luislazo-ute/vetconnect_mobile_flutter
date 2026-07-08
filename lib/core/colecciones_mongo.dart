import 'package:flutter/material.dart';

/// Un campo editable de una colección Mongo (para el formulario de crear).
class CampoMongo {
  final String clave; // nombre real del campo en Mongo (ej. 'mascota_id')
  final String etiqueta; // texto para el usuario
  final bool numero; // si es numérico (se envía como número)

  const CampoMongo(this.clave, this.etiqueta, {this.numero = false});
}

/// Configuración de una colección Mongo: título, endpoint, ícono y campos.
class ColeccionMongo {
  final String titulo;
  final String coleccion; // segmento del endpoint: /api/mongo/<coleccion>/
  final IconData icono;
  final List<CampoMongo> campos;

  const ColeccionMongo({
    required this.titulo,
    required this.coleccion,
    required this.icono,
    required this.campos,
  });
}

/// Las 4 colecciones Mongo (además de la galería, que tiene su propia pantalla).
const List<ColeccionMongo> coleccionesMongo = [
  ColeccionMongo(
    titulo: 'Monitoreo de signos',
    coleccion: 'monitoreo',
    icono: Icons.monitor_heart_outlined,
    campos: [
      CampoMongo('mascota_id', 'ID de mascota', numero: true),
      CampoMongo('temperatura', 'Temperatura (°C)', numero: true),
      CampoMongo('ritmo_cardiaco', 'Ritmo cardíaco', numero: true),
    ],
  ),
  ColeccionMongo(
    titulo: 'Consultas remotas',
    coleccion: 'consultas',
    icono: Icons.video_call_outlined,
    campos: [
      CampoMongo('mascota_id', 'ID de mascota', numero: true),
      CampoMongo('sintoma', 'Síntoma'),
      CampoMongo('estado', 'Estado'),
    ],
  ),
  ColeccionMongo(
    titulo: 'Notas de voz',
    coleccion: 'notas-voz',
    icono: Icons.mic_none_outlined,
    campos: [
      CampoMongo('cita_id', 'ID de cita', numero: true),
      CampoMongo('transcripcion', 'Transcripción'),
    ],
  ),
  ColeccionMongo(
    titulo: 'Tracking de visitas',
    coleccion: 'tracking',
    icono: Icons.location_on_outlined,
    campos: [
      CampoMongo('cita_id', 'ID de cita', numero: true),
      CampoMongo('veterinario_id', 'ID de veterinario', numero: true),
      CampoMongo('estado', 'Estado'),
    ],
  ),
];
