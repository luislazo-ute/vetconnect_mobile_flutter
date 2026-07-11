// Imágenes empaquetadas en assets (sin enlaces web en tiempo de ejecución).
import 'dart:convert';

import 'package:flutter/widgets.dart';

// Resuelve una referencia de imagen a su proveedor:
//  - 'assets/...'        → imagen empaquetada
//  - 'data:image;base64' → foto subida por el usuario (guardada en base64)
//  - resto               → red (compatibilidad hacia atrás)
ImageProvider proveedorImagen(String ref) {
  if (ref.startsWith('assets/')) return AssetImage(ref);
  if (ref.startsWith('data:image')) {
    final base64Str = ref.substring(ref.indexOf(',') + 1);
    return MemoryImage(base64Decode(base64Str));
  }
  return NetworkImage(ref);
}

// Fotos de muestra empaquetadas, para la galería (sin URLs web).
const List<({String etiqueta, String ruta})> fotosDisponibles = [
  (etiqueta: 'Perro 1', ruta: 'assets/images/mascotas/perro1.jpg'),
  (etiqueta: 'Perro 2', ruta: 'assets/images/mascotas/perro2.jpg'),
  (etiqueta: 'Perro 3', ruta: 'assets/images/mascotas/perro3.jpg'),
  (etiqueta: 'Perro 4', ruta: 'assets/images/mascotas/perro4.jpg'),
  (etiqueta: 'Gato 1', ruta: 'assets/images/mascotas/gato1.jpg'),
  (etiqueta: 'Gato 2', ruta: 'assets/images/mascotas/gato2.jpg'),
  (etiqueta: 'Gato 3', ruta: 'assets/images/mascotas/gato3.jpg'),
  (etiqueta: 'Ave', ruta: 'assets/images/mascotas/ave1.jpg'),
  (etiqueta: 'Conejo', ruta: 'assets/images/mascotas/conejo1.jpg'),
  (etiqueta: 'Otro', ruta: 'assets/images/mascotas/otro1.jpg'),
];

String imagenPorEspecie(String especie, [int id = 0]) {
  final n = id.abs();
  switch (especie) {
    case 'perro':
      return 'assets/images/mascotas/perro${(n % 4) + 1}.jpg';
    case 'gato':
      return 'assets/images/mascotas/gato${(n % 3) + 1}.jpg';
    case 'ave':
      return 'assets/images/mascotas/ave1.jpg';
    case 'conejo':
      return 'assets/images/mascotas/conejo1.jpg';
    default:
      return 'assets/images/mascotas/otro1.jpg';
  }
}

// Avatar local por rol del usuario.
String avatarPorRol(String rol) {
  switch (rol.toLowerCase()) {
    case 'admin':
      return 'assets/images/avatares/admin.jpg';
    case 'doctor':
      return 'assets/images/avatares/doctor.jpg';
    default:
      return 'assets/images/avatares/cliente.jpg';
  }
}

// Avatar local para un veterinario según su nombre.
String avatarVeterinario(String nombre) {
  final n = nombre.toLowerCase();
  if (n.contains('sofía') || n.contains('sofia')) {
    return 'assets/images/avatares/vet_sofia.jpg';
  }
  if (n.contains('luis') || n.contains('cabrera')) {
    return 'assets/images/avatares/vet_luis.jpg';
  }
  return 'assets/images/avatares/doctor.jpg';
}
