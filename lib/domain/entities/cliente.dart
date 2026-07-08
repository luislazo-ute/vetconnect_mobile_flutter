/// Entidad de dominio: un cliente (dueño de mascotas).
class Cliente {
  final int id;
  final String username;
  final String telefono;
  final String direccion;

  const Cliente({
    required this.id,
    required this.username,
    required this.telefono,
    required this.direccion,
  });
}
