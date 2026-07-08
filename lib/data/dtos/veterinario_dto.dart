import '../../domain/entities/veterinario.dart';

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
