/// Los 3 roles del sistema (derivados en el backend).
enum Rol {
  admin,
  doctor,
  usuario;

  /// Convierte el string del backend a un Rol.
  /// ("ADMIN" → Rol.admin, "DOCTOR" → Rol.doctor, el resto → Rol.usuario)
  static Rol desdeApi(String valor) {
    switch (valor) {
      case 'ADMIN':
        return Rol.admin;
      case 'DOCTOR':
        return Rol.doctor;
      default:
        return Rol.usuario;
    }
  }
}
