/// Entidad de dominio: una cita veterinaria. Dart puro.
class Cita {
  final int id;
  final int mascota;
  final String mascotaNombre;
  final int? veterinario;
  final String veterinarioNombre;
  final String fecha; // datetime ISO ('2026-07-09T23:14:52Z')
  final String hora; // 'HH:MM:SS'
  final String motivo;
  final String estado; // pendiente/confirmada/completada/cancelada
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

  /// Fecha corta 'YYYY-MM-DD' para mostrar.
  String get fechaCorta => fecha.length >= 10 ? fecha.substring(0, 10) : fecha;

  /// Hora corta 'HH:MM' para mostrar.
  String get horaCorta => hora.length >= 5 ? hora.substring(0, 5) : hora;
}
