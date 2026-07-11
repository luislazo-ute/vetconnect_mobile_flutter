import '../../domain/entities/habitacion.dart';

class HabitacionDto {
  final int id;
  final String codigo;
  final String tipo;
  final String precioDia;
  final String estado;
  final int capacidad;
  final String observaciones;
  final bool isActive;

  const HabitacionDto({
    required this.id,
    required this.codigo,
    required this.tipo,
    required this.precioDia,
    required this.estado,
    required this.capacidad,
    required this.observaciones,
    required this.isActive,
  });

  factory HabitacionDto.fromJson(Map<String, dynamic> json) {
    return HabitacionDto(
      id: json['id'] as int,
      codigo: json['codigo'] as String? ?? '',
      tipo: json['tipo'] as String? ?? '',
      precioDia: json['precio_dia'].toString(),
      estado: json['estado'] as String? ?? 'disponible',
      capacidad: json['capacidad'] as int? ?? 1,
      observaciones: json['observaciones'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Habitacion toDomain() {
    return Habitacion(
      id: id,
      codigo: codigo,
      tipo: tipo,
      precioDia: precioDia,
      estado: estado,
      capacidad: capacidad,
      observaciones: observaciones,
      isActive: isActive,
    );
  }
}
