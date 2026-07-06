/// Representa una página de resultados paginados de DRF.
/// Es genérico: `PaginaDto<Servicio>`, `PaginaDto<Veterinario>`, etc.
class PaginaDto<T> {
  final int count;
  final String? next;      // URL de la página siguiente (null si es la última)
  final String? previous;  // URL de la página anterior
  final List<T> results;

  const PaginaDto({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  /// hayMas es true si existe página siguiente.
  bool get hayMas => next != null;

  /// Construye desde el JSON. Recibe una función `fromJsonItem` que sabe
  /// convertir el Map de UN item al tipo T.
  factory PaginaDto.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonItem,
  ) {
    final lista = (json['results'] as List)
        .map((item) => fromJsonItem(item as Map<String, dynamic>))
        .toList();

    return PaginaDto(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: lista,
    );
  }
}
