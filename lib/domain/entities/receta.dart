import 'detalle_receta.dart';

class Receta {
  final int id;
  final int mascota;
  final String mascotaNombre;
  final int veterinario;
  final String veterinarioNombre;
  final String fecha;
  final String? observaciones;
  final bool isActive;
  final List<DetalleReceta> detalles;

  const Receta({
    required this.id,
    required this.mascota,
    required this.mascotaNombre,
    required this.veterinario,
    required this.veterinarioNombre,
    required this.fecha,
    this.observaciones,
    this.isActive = true,
    this.detalles = const [],
  });
}
