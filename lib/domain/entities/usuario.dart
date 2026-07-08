import 'rol.dart';

class Usuario {
  final int id;
  final String username;
  final String email;
  final bool isStaff;
  final Rol rol;

  const Usuario({
    required this.id,
    required this.username,
    required this.email,
    required this.isStaff,
    required this.rol,
  });

  bool get esAdmin => rol == Rol.admin;
  bool get esDoctor => rol == Rol.doctor;
  bool get esUsuario => rol == Rol.usuario;
}
