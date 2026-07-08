import '../../domain/entities/documento_mongo.dart';

class DocumentoMongoDto {
  static DocumentoMongo fromJson(Map<String, dynamic> json) {
    final id = json['_id']?.toString() ?? '';
    final datos = Map<String, dynamic>.from(json)..remove('_id');
    return DocumentoMongo(id: id, datos: datos);
  }
}
