class Notificacion {
  final int id;
  final String titulo;
  final String mensaje;
  final bool leida;
  final String fechaCreacion;

  const Notificacion({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.leida,
    required this.fechaCreacion,
  });
}
