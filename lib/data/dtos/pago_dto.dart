import '../../domain/entities/pago.dart';

class PagoDto {
  final int id;
  final String monto;
  final String fechaPago;
  final String metodoPago;
  final String referencia;

  const PagoDto({
    required this.id,
    required this.monto,
    required this.fechaPago,
    required this.metodoPago,
    required this.referencia,
  });

  factory PagoDto.fromJson(Map<String, dynamic> json) {
    return PagoDto(
      id: json['id'] as int,
      monto: json['monto'].toString(),
      fechaPago: json['fecha_pago'] as String? ?? '',
      metodoPago: json['metodo_pago'] as String? ?? 'efectivo',
      referencia: json['referencia'] as String? ?? '',
    );
  }

  Pago toDomain() {
    return Pago(
      id: id,
      monto: double.tryParse(monto) ?? 0,
      fechaPago: fechaPago,
      metodoPago: metodoPago,
      referencia: referencia,
    );
  }
}
