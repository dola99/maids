class GenericResponse<T> {
  final T data;

  GenericResponse({
    required this.data,
  });

  factory GenericResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return GenericResponse<T>(
      data: fromJsonT(json),
    );
  }
}

class ListResponse<T> extends GenericResponse<List<T>> {
  ListResponse({
    required List<T> data,
  }) : super(
          data: data,
        );

  factory ListResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ListResponse<T>(
      data: (json as List)
          .map((i) => fromJsonT(i as Map<String, dynamic>))
          .toList(),
    );
  }
}
