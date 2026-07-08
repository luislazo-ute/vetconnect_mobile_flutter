/// Documento genérico de MongoDB: un _id (String) + campos flexibles.
/// Sirve para monitoreo, consultas, notas de voz y tracking.
class DocumentoMongo {
  final String id;
  final Map<String, dynamic> datos; // todos los campos menos _id

  const DocumentoMongo({required this.id, required this.datos});
}
