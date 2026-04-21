class PaginatedResponseModel<T> {
  final int count;
  final String? next;
  final String? previous;
  final List<T> results;

  const PaginatedResponseModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponseModel<T>(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
