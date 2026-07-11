import '../../domain/entities/vacuna.dart';

class VacunaDto {
  final int id;
  final int mascota;
  final String mascotaNombre;
  final String nombreVacuna;
  final String fechaAplicacion;
  final String? fechaProximaDosis;
  final String? lote;
  final String? dosis;
  final String? observaciones;
  final bool isActive;

  const VacunaDto({
    required this.id,
    required this.mascota,
    required this.mascotaNombre,
    required this.nombreVacuna,
    required this.fechaAplicacion,
    this.fechaProximaDosis,
    this.lote,
    this.dosis,
    this.observaciones,
    required this.isActive,
  });

  factory VacunaDto.fromJson(Map<String, dynamic> json) {
    return VacunaDto(
      id: json['id'] as int,
      mascota: json['mascota'] as int,
      mascotaNombre: json['mascota_nombre'] as String? ?? '',
      nombreVacuna: json['nombre_vacuna'] as String,
      fechaAplicacion: json['fecha_aplicacion'] as String,
      fechaProximaDosis: json['fecha_proxima_dosis'] as String?,
      lote: json['lote'] as String?,
      dosis: json['dosis'] as String?,
      observaciones: json['observaciones'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Vacuna toDomain() {
    return Vacuna(
      id: id,
      mascota: mascota,
      mascotaNombre: mascotaNombre,
      nombreVacuna: nombreVacuna,
      fechaAplicacion: fechaAplicacion,
      fechaProximaDosis: fechaProximaDosis,
      lote: lote,
      dosis: dosis,
      observaciones: observaciones,
      isActive: isActive,
    );
  }
}
