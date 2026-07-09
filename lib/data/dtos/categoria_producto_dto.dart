import '../../domain/entities/categoria_producto.dart';

class CategoriaProductoDto {
  final int id;
  final String nombre;
  final String descripcion;
  final bool isActive;

  const CategoriaProductoDto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.isActive,
  });

  factory CategoriaProductoDto.fromJson(Map<String, dynamic> json) {
    return CategoriaProductoDto(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String? ?? '',
      isActive: json['is_active'] as bool,
    );
  }

  CategoriaProducto toDomain() {
    return CategoriaProducto(
      id: id,
      nombre: nombre,
      descripcion: descripcion,
      isActive: isActive,
    );
  }
}
