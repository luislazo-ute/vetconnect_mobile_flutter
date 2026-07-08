enum Rol {
  admin,
  doctor,
  usuario;

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
