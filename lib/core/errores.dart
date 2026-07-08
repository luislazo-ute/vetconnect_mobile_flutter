class ExcepcionApi implements Exception {
  final String mensaje;

  const ExcepcionApi(this.mensaje);

  @override
  String toString() => mensaje;
}
