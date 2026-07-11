import '../../domain/entities/detalle_receta.dart';
import '../../domain/entities/receta.dart';

class RecetaDto {
  final int id;
  final int mascota;
  final String mascotaNombre;
  final int veterinario;
  final String veterinarioNombre;
  final String fecha;
  final String? observaciones;
  final List<DetalleReceta> detalles;

  const RecetaDto({
    required this.id,
    required this.mascota,
    required this.mascotaNombre,
    required this.veterinario,
    required this.veterinarioNombre,
    required this.fecha,
    this.observaciones,
    this.detalles = const [],
  });

  factory RecetaDto.fromJson(Map<String, dynamic> json) {
    return RecetaDto(
      id: json['id'] as int,
      mascota: json['mascota'] as int,
      mascotaNombre: json['mascota_nombre'] as String? ?? '',
      veterinario: json['veterinario'] as int? ?? 0,
      veterinarioNombre: json['veterinario_nombre'] as String? ?? 'Sin asignar',
      fecha: (json['fecha_emision'] as String? ?? '').split('T').first,
      observaciones: json['instrucciones'] as String?,
    );
  }

  Receta toDomain() {
    return Receta(
      id: id,
      mascota: mascota,
      mascotaNombre: mascotaNombre,
      veterinario: veterinario,
      veterinarioNombre: veterinarioNombre,
      fecha: fecha,
      observaciones: observaciones,
      detalles: detalles,
    );
  }
}
