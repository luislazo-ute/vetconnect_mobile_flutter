import '../../domain/entities/servicio.dart';

/// DTO: traduce el JSON crudo de la API a la entidad Servicio.
/// (Es el equivalente a un Serializer de DRF.)
class ServicioDto {
  final int id;
  final String nombre;
  final String descripcion;
  final String precio;           // OJO: llega como STRING desde DRF
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

  /// Construye el DTO desde el Map del JSON. Nota las claves snake_case.
  factory ServicioDto.fromJson(Map<String, dynamic> json) {
    return ServicioDto(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String? ?? '',
      precio: json['precio'] as String,
      duracionMinutos: json['duracion_minutos'] as int,   // ← snake_case del JSON
      isActive: json['is_active'] as bool,                // ← snake_case del JSON
    );
  }

  /// Convierte el DTO en la entidad limpia de dominio.
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
