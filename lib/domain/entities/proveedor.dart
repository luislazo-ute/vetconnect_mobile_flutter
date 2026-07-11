class Proveedor {
  final int id;
  final String nombre;
  final String contacto;
  final String telefono;
  final String email;
  final String direccion;
  final bool isActive;

  const Proveedor({
    required this.id,
    required this.nombre,
    required this.contacto,
    required this.telefono,
    required this.email,
    required this.direccion,
    required this.isActive,
  });
}
