import 'rol.dart';

/// Entidad del usuario autenticado. Dart puro.
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

  // Getters de conveniencia para la UI (mostrar/ocultar acciones por rol).
  bool get esAdmin => rol == Rol.admin;
  bool get esDoctor => rol == Rol.doctor;
  bool get esUsuario => rol == Rol.usuario;
}
