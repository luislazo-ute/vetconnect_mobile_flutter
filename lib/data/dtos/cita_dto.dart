import '../../domain/entities/cita.dart';

class CitaDto {
  final int id;
  final int mascota;
  final String mascotaNombre;
  final int? veterinario;
  final String veterinarioNombre;
  final String fecha;
  final String hora;
  final String motivo;
  final String estado;
  final String estadoDisplay;

  const CitaDto({
    required this.id,
    required this.mascota,
    required this.mascotaNombre,
    required this.veterinario,
    required this.veterinarioNombre,
    required this.fecha,
    required this.hora,
    required this.motivo,
    required this.estado,
    required this.estadoDisplay,
  });

  factory CitaDto.fromJson(Map<String, dynamic> json) {
    return CitaDto(
      id: json['id'] as int,
      mascota: json['mascota'] as int,
      mascotaNombre: json['mascota_nombre'] as String? ?? '',
      veterinario: json['veterinario'] as int?,
      veterinarioNombre: json['veterinario_nombre'] as String? ?? '',
      fecha: json['fecha'] as String? ?? '',
      hora: json['hora'] as String? ?? '',
      motivo: json['motivo'] as String? ?? '',
      estado: json['estado'] as String? ?? 'pendiente',
      estadoDisplay: json['estado_display'] as String? ?? '',
    );
  }

  Cita toDomain() => Cita(
        id: id,
        mascota: mascota,
        mascotaNombre: mascotaNombre,
        veterinario: veterinario,
        veterinarioNombre: veterinarioNombre,
        fecha: fecha,
        hora: hora,
        motivo: motivo,
        estado: estado,
        estadoDisplay: estadoDisplay,
      );
}
