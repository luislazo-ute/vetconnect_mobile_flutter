import '../../domain/entities/habitacion.dart';

class HabitacionDto {
  final int id;
  final String nombre;
  final int numero;
  final String tipo;
  final String tipoDisplay;
  final int capacidad;
  final String precioDia;
  final bool disponible;
  final bool isActive;

  const HabitacionDto({
    required this.id,
    required this.nombre,
    required this.numero,
    required this.tipo,
    required this.tipoDisplay,
    required this.capacidad,
    required this.precioDia,
    required this.disponible,
    required this.isActive,
  });

  factory HabitacionDto.fromJson(Map<String, dynamic> json) {
    return HabitacionDto(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      numero: json['numero'] as int,
      tipo: json['tipo'] as String,
      tipoDisplay: json['tipo_display'] as String? ?? '',
      capacidad: json['capacidad'] as int,
      precioDia: json['precio_dia'] as String,
      disponible: json['disponible'] as bool? ?? true,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Habitacion toDomain() {
    return Habitacion(
      id: id,
      nombre: nombre,
      numero: numero,
      tipo: tipo,
      tipoDisplay: tipoDisplay,
      capacidad: capacidad,
      precioDia: precioDia,
      disponible: disponible,
      isActive: isActive,
    );
  }
}
