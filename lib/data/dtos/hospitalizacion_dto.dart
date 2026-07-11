import '../../domain/entities/hospitalizacion.dart';

class HospitalizacionDto {
  final int id;
  final int mascota;
  final String mascotaNombre;
  final int habitacion;
  final String habitacionCodigo;
  final String veterinarioNombre;
  final String fechaIngreso;
  final String? fechaAlta;
  final String motivo;
  final String? diagnostico;
  final String? tratamiento;
  final bool isActive;

  const HospitalizacionDto({
    required this.id,
    required this.mascota,
    required this.mascotaNombre,
    required this.habitacion,
    required this.habitacionCodigo,
    required this.veterinarioNombre,
    required this.fechaIngreso,
    this.fechaAlta,
    required this.motivo,
    this.diagnostico,
    this.tratamiento,
    required this.isActive,
  });

  factory HospitalizacionDto.fromJson(Map<String, dynamic> json) {
    return HospitalizacionDto(
      id: json['id'] as int,
      mascota: json['mascota'] as int,
      mascotaNombre: json['mascota_nombre'] as String? ?? '',
      habitacion: json['habitacion'] as int,
      habitacionCodigo: json['habitacion_codigo'] as String? ?? '',
      veterinarioNombre: json['veterinario_nombre'] as String? ?? '',
      fechaIngreso: json['fecha_ingreso'] as String? ?? '',
      fechaAlta: json['fecha_alta'] as String?,
      motivo: json['motivo'] as String? ?? '',
      diagnostico: json['diagnostico'] as String?,
      tratamiento: json['tratamiento'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Hospitalizacion toDomain() {
    return Hospitalizacion(
      id: id,
      mascota: mascota,
      mascotaNombre: mascotaNombre,
      habitacion: habitacion,
      habitacionCodigo: habitacionCodigo,
      veterinarioNombre: veterinarioNombre,
      fechaIngreso: fechaIngreso,
      fechaAlta: fechaAlta,
      motivo: motivo,
      diagnostico: diagnostico,
      tratamiento: tratamiento,
      isActive: isActive,
    );
  }
}
