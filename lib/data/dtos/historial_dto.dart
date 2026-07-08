import '../../domain/entities/historial.dart';

class HistorialDto {
  final int id;
  final int mascota;
  final String mascotaNombre;
  final int? veterinario;
  final String veterinarioNombre;
  final String fecha;
  final String diagnostico;
  final String tratamiento;
  final String observaciones;

  const HistorialDto({
    required this.id,
    required this.mascota,
    required this.mascotaNombre,
    required this.veterinario,
    required this.veterinarioNombre,
    required this.fecha,
    required this.diagnostico,
    required this.tratamiento,
    required this.observaciones,
  });

  factory HistorialDto.fromJson(Map<String, dynamic> json) {
    return HistorialDto(
      id: json['id'] as int,
      mascota: json['mascota'] as int,
      mascotaNombre: json['mascota_nombre'] as String? ?? '',
      veterinario: json['veterinario'] as int?,
      veterinarioNombre: json['veterinario_nombre'] as String? ?? '',
      fecha: json['fecha'] as String? ?? '',
      diagnostico: json['diagnostico'] as String? ?? '',
      tratamiento: json['tratamiento'] as String? ?? '',
      observaciones: json['observaciones'] as String? ?? '',
    );
  }

  Historial toDomain() => Historial(
        id: id,
        mascota: mascota,
        mascotaNombre: mascotaNombre,
        veterinario: veterinario,
        veterinarioNombre: veterinarioNombre,
        fecha: fecha,
        diagnostico: diagnostico,
        tratamiento: tratamiento,
        observaciones: observaciones,
      );
}
