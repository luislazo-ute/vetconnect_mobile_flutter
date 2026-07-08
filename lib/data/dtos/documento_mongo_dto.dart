import '../../domain/entities/documento_mongo.dart';

/// Convierte un documento Mongo crudo (Map con _id) a la entidad genérica.
class DocumentoMongoDto {
  static DocumentoMongo fromJson(Map<String, dynamic> json) {
    final id = json['_id']?.toString() ?? '';
    // Copiamos el mapa y quitamos _id: el resto son los campos flexibles.
    final datos = Map<String, dynamic>.from(json)..remove('_id');
    return DocumentoMongo(id: id, datos: datos);
  }
}
