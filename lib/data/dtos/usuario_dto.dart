import '../../domain/entities/rol.dart';
import '../../domain/entities/usuario.dart';

/// DTO del objeto "user" que devuelve el login (y el perfil).
class UsuarioDto {
  final int id;
  final String username;
  final String email;
  final bool isStaff;
  final String rol; // llega como String: "ADMIN"/"DOCTOR"/"USUARIO"

  const UsuarioDto({
    required this.id,
    required this.username,
    required this.email,
    required this.isStaff,
    required this.rol,
  });

  factory UsuarioDto.fromJson(Map<String, dynamic> json) {
    return UsuarioDto(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String? ?? '',
      isStaff: json['is_staff'] as bool? ?? false,
      rol: json['rol'] as String,
    );
  }

  Usuario toDomain() {
    return Usuario(
      id: id,
      username: username,
      email: email,
      isStaff: isStaff,
      // COMPLETAR: convierte el string rol al enum con tu helper.
      // Pista: Rol.desdeApi(rol)
      rol: Rol.desdeApi(rol),
    );
  }
}
