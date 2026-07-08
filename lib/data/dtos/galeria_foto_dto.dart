import '../../domain/entities/galeria_foto.dart';

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
    String url = json['url'] as String? ?? '';
    if (url.isEmpty &&
        json['fotos'] is List &&
        (json['fotos'] as List).isNotEmpty) {
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

  GaleriaFoto toDomain() => GaleriaFoto(
    id: id,
    mascotaId: mascotaId,
    url: url,
    descripcion: descripcion,
  );
}
