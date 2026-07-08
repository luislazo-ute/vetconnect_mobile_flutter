import '../entities/documento_mongo.dart';

/// Contrato genérico para cualquier colección MongoDB (lista plana).
abstract interface class IMongoRepository {
  /// Trae los documentos de la colección indicada (ej. 'monitoreo').
  Future<List<DocumentoMongo>> obtener(String coleccion);

  /// Crea un documento en la colección (solo ADMIN).
  Future<void> crear(String coleccion, Map<String, dynamic> datos);
}
