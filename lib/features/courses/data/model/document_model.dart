class DocumentModel {
  final String id;
  final String title;
  final String url;
  final DateTime createdAt;

  DocumentModel({
    required this.id,
    required this.title,
    required this.url,
    required this.createdAt,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}