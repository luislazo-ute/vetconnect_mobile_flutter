class Cita {
  final int id;
  final int mascota;
  final String mascotaNombre;
  final int? veterinario;
  final String veterinarioNombre;
  final String fecha;
  final String hora;
  final String motivo;
  final String estado;
  final String estadoDisplay;

  const Cita({
    required this.id,
    required this.mascota,
    required this.mascotaNombre,
    required this.veterinario,
    required this.veterinarioNombre,
    required this.fecha,
    required this.hora,
    required this.motivo,
    required this.estado,
    required this.estadoDisplay,
  });

  String get fechaCorta => fecha.length >= 10 ? fecha.substring(0, 10) : fecha;

  String get horaCorta => hora.length >= 5 ? hora.substring(0, 5) : hora;
}
