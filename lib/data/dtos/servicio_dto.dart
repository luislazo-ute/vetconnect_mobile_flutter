import '../../domain/entities/servicio.dart';

class ServicioDto {
  final int id;
  final String nombre;
  final String descripcion;
  final String precio;
  final int duracionMinutos;
  final bool isActive;

  const ServicioDto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.duracionMinutos,
    required this.isActive,
  });

  factory ServicioDto.fromJson(Map<String, dynamic> json) {
    return ServicioDto(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String? ?? '',
      precio: json['precio'] as String,
      duracionMinutos: json['duracion_minutos'] as int,
      isActive: json['is_active'] as bool,
    );
  }

  Servicio toDomain() {
    return Servicio(
      id: id,
      nombre: nombre,
      descripcion: descripcion,
      precio: double.parse(precio),
      duracionMinutos: duracionMinutos,
      isActive: isActive,
    );
  }
}
