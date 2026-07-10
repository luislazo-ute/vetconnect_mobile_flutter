import '../../domain/entities/detalle_receta.dart';

class DetalleRecetaDto {
  final int id;
  final int receta;
  final String medicamento;
  final String dosis;
  final String frecuencia;
  final String? duracion;
  final String? observaciones;

  const DetalleRecetaDto({
    required this.id,
    required this.receta,
    required this.medicamento,
    required this.dosis,
    required this.frecuencia,
    this.duracion,
    this.observaciones,
  });

  factory DetalleRecetaDto.fromJson(Map<String, dynamic> json) {
    return DetalleRecetaDto(
      id: json['id'] as int,
      receta: json['receta'] as int,
      medicamento: json['medicamento'] as String,
      dosis: json['dosis'] as String,
      frecuencia: json['frecuencia'] as String,
      duracion: json['duracion'] as String?,
      observaciones: json['observaciones'] as String?,
    );
  }

  DetalleReceta toDomain() {
    return DetalleReceta(
      id: id,
      receta: receta,
      medicamento: medicamento,
      dosis: dosis,
      frecuencia: frecuencia,
      duracion: duracion,
      observaciones: observaciones,
    );
  }
}
