import '../../domain/entities/proveedor.dart';

class ProveedorDto {
  final int id;
  final String nombre;
  final String contacto;
  final String telefono;
  final String email;
  final String direccion;
  final bool isActive;

  const ProveedorDto({
    required this.id,
    required this.nombre,
    required this.contacto,
    required this.telefono,
    required this.email,
    required this.direccion,
    required this.isActive,
  });

  factory ProveedorDto.fromJson(Map<String, dynamic> json) {
    return ProveedorDto(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      contacto: json['contacto'] as String? ?? '',
      telefono: json['telefono'] as String? ?? '',
      email: json['email'] as String? ?? '',
      direccion: json['direccion'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Proveedor toDomain() {
    return Proveedor(
      id: id,
      nombre: nombre,
      contacto: contacto,
      telefono: telefono,
      email: email,
      direccion: direccion,
      isActive: isActive,
    );
  }
}
