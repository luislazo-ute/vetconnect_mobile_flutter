/// Entidad de dominio: una mascota. Dart puro.
class Mascota {
  final int id;
  final String nombre;
  final String especie; // 'perro','gato','ave','conejo','otro'
  final String especieDisplay; // 'Perro', etc.
  final String raza;
  final String? fechaNacimiento; // 'YYYY-MM-DD' o null
  final double? peso; // en kg, o null
  final int cliente; // id del cliente dueño
  final String clienteNombre;
  final bool isActive;

  const Mascota({
    required this.id,
    required this.nombre,
    required this.especie,
    required this.especieDisplay,
    required this.raza,
    required this.fechaNacimiento,
    required this.peso,
    required this.cliente,
    required this.clienteNombre,
    required this.isActive,
  });

  /// Peso listo para mostrar, ej. "18.50 kg" o "N/D".
  String get pesoTexto => peso != null ? '${peso!.toStringAsFixed(2)} kg' : 'N/D';
}
