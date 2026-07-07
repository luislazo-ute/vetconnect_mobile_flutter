/// Entidad de dominio: una foto de la galería (MongoDB).
class GaleriaFoto {
  final String id; // _id de Mongo (String)
  final int mascotaId;
  final String url;
  final String descripcion;

  const GaleriaFoto({
    required this.id,
    required this.mascotaId,
    required this.url,
    required this.descripcion,
  });
}
