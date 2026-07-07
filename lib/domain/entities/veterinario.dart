/// Entidad de dominio: un veterinario. Dart puro, sin Flutter ni JSON.
class Veterinario {
  final int id;
  final String nombre;
  final String especialidad;
  final String telefono;          // ya como número (el DTO lo convierte)
  final String email;    // camelCase, limpio
  final String horarioAtencion;    // camelCase, limpio

  const Veterinario({
    required this.id,
    required this.nombre,
    required this.especialidad,
    required this.telefono,
    required this.email,
    required this.horarioAtencion,
  });

}
