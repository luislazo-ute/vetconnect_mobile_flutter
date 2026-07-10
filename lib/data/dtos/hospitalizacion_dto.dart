import '../../domain/entities/hospitalizacion.dart';

class HospitalizacionDto {
  final int id;
  final int mascota;
  final String mascotaNombre;
  final int habitacion;
  final String habitacionNombre;
  final String fechaIngreso;
  final String? fechaAlta;
  final String motivo;
  final String? diagnostico;
  final String estado;
  final String estadoDisplay;
  final String? observaciones;
  final bool isActive;

  const HospitalizacionDto({
    required this.id,
    required this.mascota,
    required this.mascotaNombre,
    required this.habitacion,
    required this.habitacionNombre,
    required this.fechaIngreso,
    this.fechaAlta,
    required this.motivo,
    this.diagnostico,
    required this.estado,
    required this.estadoDisplay,
    this.observaciones,
    required this.isActive,
  });

  factory HospitalizacionDto.fromJson(Map<String, dynamic> json) {
    return HospitalizacionDto(
      id: json['id'] as int,
      mascota: json['mascota'] as int,
      mascotaNombre: json['mascota_nombre'] as String? ?? '',
      habitacion: json['habitacion'] as int,
      habitacionNombre: json['habitacion_nombre'] as String? ?? '',
      fechaIngreso: json['fecha_ingreso'] as String,
      fechaAlta: json['fecha_alta'] as String?,
      motivo: json['motivo'] as String,
      diagnostico: json['diagnostico'] as String?,
      estado: json['estado'] as String,
      estadoDisplay: json['estado_display'] as String? ?? '',
      observaciones: json['observaciones'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Hospitalizacion toDomain() {
    return Hospitalizacion(
      id: id,
      mascota: mascota,
      mascotaNombre: mascotaNombre,
      habitacion: habitacion,
      habitacionNombre: habitacionNombre,
      fechaIngreso: fechaIngreso,
      fechaAlta: fechaAlta,
      motivo: motivo,
      diagnostico: diagnostico,
      estado: estado,
      estadoDisplay: estadoDisplay,
      observaciones: observaciones,
      isActive: isActive,
    );
  }
}
