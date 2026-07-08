import '../entities/documento_mongo.dart';

abstract interface class IMongoRepository {
  Future<List<DocumentoMongo>> obtener(String coleccion);

  Future<void> crear(String coleccion, Map<String, dynamic> datos);
}
