import '../../domain/entities/veterinario.dart';

/// DTO: traduce el JSON crudo de la API a la entidad Veterinario.
/// (Es el equivalente a un Serializer de DRF.)
class VeterinarioDto {
  final int id;
  final String nombre;
  final String especialidad;
  final String telefono;
  final String email;
  final String horarioAtencion;

  const VeterinarioDto({
    required this.id,
    required this.nombre,
    required this.especialidad,
    required this.telefono,
    required this.email,
    required this.horarioAtencion,
  });

  /// Construye el DTO desde el Map del JSON. Nota las claves snake_case.
  factory VeterinarioDto.fromJson(Map<String, dynamic> json) {
    return VeterinarioDto(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      especialidad: json['especialidad'] as String,
      telefono: json['telefono'] as String,
      email: json['email'] as String,
      horarioAtencion: json['horario_atencion'] as String? ?? '',
    );
  }

  /// Convierte el DTO en la entidad limpia de dominio.
  Veterinario toDomain() {
    return Veterinario(
      id: id,
      nombre: nombre,
      especialidad: especialidad,
      telefono: telefono,
      email: email,
      horarioAtencion: horarioAtencion,
    );
  }
}


