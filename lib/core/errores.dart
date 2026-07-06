/// Excepción de dominio para errores de la API, con un mensaje amigable
/// listo para mostrar al usuario. La lanzaremos desde los repositorios.
class ExcepcionApi implements Exception {
  final String mensaje;

  const ExcepcionApi(this.mensaje);

  @override
  String toString() => mensaje;
}
