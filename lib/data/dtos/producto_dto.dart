import '../../domain/entities/producto.dart';

class ProductoDto {
  final int id;
  final String nombre;
  final String descripcion;
  final String precio;
  final int stock;
  final int categoria;
  final String categoriaNombre;
  final bool isActive;

  const ProductoDto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.categoria,
    required this.categoriaNombre,
    required this.isActive,
  });

  factory ProductoDto.fromJson(Map<String, dynamic> json) {
    return ProductoDto(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String? ?? '',
      precio: json['precio_venta'] as String,
      stock: json['stock_actual'] as int,
      categoria: json['categoria'] as int,
      categoriaNombre: json['categoria_nombre'] as String? ?? '',
      isActive: json['is_active'] as bool,
    );
  }

  Producto toDomain() {
    return Producto(
      id: id,
      nombre: nombre,
      descripcion: descripcion,
      precio: double.parse(precio),
      stock: stock,
      categoria: categoria,
      categoriaNombre: categoriaNombre,
      isActive: isActive,
    );
  }
}
