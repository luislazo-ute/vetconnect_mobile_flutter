abstract interface class IUsuarioAdminRepository {
  /// Crea una cuenta de usuario (solo admin) y devuelve su id.
  Future<int> crearUsuario(Map<String, dynamic> datos);
}
