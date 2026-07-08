class PaginaDto<T> {
  final int count;
  final String? next;
  final String? previous;
  final List<T> results;

  const PaginaDto({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  bool get hayMas => next != null;

  factory PaginaDto.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonItem,
  ) {
    final lista =
        (json['results'] as List)
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
