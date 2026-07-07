import '../../domain/entities/galeria_foto.dart';

/// DTO de una foto de galería. Mongo es flexible: la URL puede venir en el
/// campo `url` (arriba) o dentro de un array `fotos`. Lo manejamos defensivo.
class GaleriaFotoDto {
  final String id;
  final int mascotaId;
  final String url;
  final String descripcion;

  const GaleriaFotoDto({
    required this.id,
    required this.mascotaId,
    required this.url,
    required this.descripcion,
  });

  factory GaleriaFotoDto.fromJson(Map<String, dynamic> json) {
    // 1) Intenta la url de nivel superior.
    String url = json['url'] as String? ?? '';
    // 2) Si no hay, busca en el array `fotos`.
    if (url.isEmpty && json['fotos'] is List && (json['fotos'] as List).isNotEmpty) {
      final primera = (json['fotos'] as List).first;
      if (primera is Map) url = primera['url'] as String? ?? '';
    }
    return GaleriaFotoDto(
      id: json['_id'] as String? ?? '',
      mascotaId: (json['mascota_id'] as num?)?.toInt() ?? 0,
      url: url,
      descripcion: json['descripcion'] as String? ?? '',
    );
  }

  GaleriaFoto toDomain() =>
      GaleriaFoto(id: id, mascotaId: mascotaId, url: url, descripcion: descripcion);
}
