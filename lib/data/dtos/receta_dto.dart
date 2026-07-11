import '../../domain/entities/receta.dart';
import 'detalle_receta_dto.dart';

class RecetaDto {
  final int id;
  final int mascota;
  final String mascotaNombre;
  final int veterinario;
  final String veterinarioNombre;
  final String fecha;
  final String? observaciones;
  final bool isActive;
  final List<DetalleRecetaDto> detalles;

  const RecetaDto({
    required this.id,
    required this.mascota,
    required this.mascotaNombre,
    required this.veterinario,
    required this.veterinarioNombre,
    required this.fecha,
    this.observaciones,
    required this.isActive,
    this.detalles = const [],
  });

  factory RecetaDto.fromJson(Map<String, dynamic> json) {
    final detallesRaw = json['detalle_receta_set'] as List? ?? [];
    return RecetaDto(
      id: json['id'] as int,
      mascota: json['mascota'] as int,
      mascotaNombre: json['mascota_nombre'] as String? ?? '',
      veterinario: json['veterinario'] as int,
      veterinarioNombre: json['veterinario_nombre'] as String? ?? '',
      fecha: json['fecha'] as String,
      observaciones: json['observaciones'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      detalles: detallesRaw
          .map((d) => DetalleRecetaDto.fromJson(d as Map<String, dynamic>))
          .toList(),
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
      isActive: isActive,
      detalles: detalles.map((d) => d.toDomain()).toList(),
    );
  }
}
