import '../../domain/entities/mascota.dart';

class MascotaDto {
  final int id;
  final String nombre;
  final String especie;
  final String especieDisplay;
  final String raza;
  final String? fechaNacimiento;
  final String? peso;
  final int cliente;
  final String clienteNombre;
  final bool isActive;

  const MascotaDto({
    required this.id,
    required this.nombre,
    required this.especie,
    required this.especieDisplay,
    required this.raza,
    required this.fechaNacimiento,
    required this.peso,
    required this.cliente,
    required this.clienteNombre,
    required this.isActive,
  });

  factory MascotaDto.fromJson(Map<String, dynamic> json) {
    return MascotaDto(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      especie: json['especie'] as String,
      especieDisplay: json['especie_display'] as String? ?? '',
      raza: json['raza'] as String? ?? '',
      fechaNacimiento: json['fecha_nacimiento'] as String?,
      peso: json['peso'] as String?,
      cliente: json['cliente'] as int,
      clienteNombre: json['cliente_nombre'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Mascota toDomain() {
    return Mascota(
      id: id,
      nombre: nombre,
      especie: especie,
      especieDisplay: especieDisplay,
      raza: raza,
      fechaNacimiento: fechaNacimiento,
      peso: peso != null ? double.tryParse(peso!) : null,
      cliente: cliente,
      clienteNombre: clienteNombre,
      isActive: isActive,
    );
  }
}
