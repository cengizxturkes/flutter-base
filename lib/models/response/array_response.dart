import 'package:json_annotation/json_annotation.dart';

class ArrayResponse<T> {
  final int page;
  final int totalPages;
  final int totalResults;
  final List<T> results;

  ArrayResponse({
    this.page = 1,
    this.totalPages = 0,
    this.totalResults = 0,
    this.results = const [],
  });

  factory ArrayResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ArrayResponse<T>(
      page: json['page'] ?? 1,
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
      results: (json['results'] as List?)
              ?.map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'page': page,
      'total_pages': totalPages,
      'total_results': totalResults,
      'results': results.map((item) => toJsonT(item)).toList(),
    };
  }
}
