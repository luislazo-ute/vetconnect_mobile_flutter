/// Entidad de dominio: un historial médico. Dart puro.
class Historial {
  final int id;
  final int mascota;
  final String mascotaNombre;
  final int? veterinario;
  final String veterinarioNombre;
  final String fecha;
  final String diagnostico;
  final String tratamiento;
  final String observaciones;

  const Historial({
    required this.id,
    required this.mascota,
    required this.mascotaNombre,
    required this.veterinario,
    required this.veterinarioNombre,
    required this.fecha,
    required this.diagnostico,
    required this.tratamiento,
    required this.observaciones,
  });

  String get fechaCorta => fecha.length >= 10 ? fecha.substring(0, 10) : fecha;
}
