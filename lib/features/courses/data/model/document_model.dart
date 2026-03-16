class DocumentModel {
  final int id;
  final int course;
  final String title;
  final String url;
  final DateTime createdAt;
  final bool isUserLocked;

  DocumentModel({
    required this.id,
    required this.course,
    required this.title,
    required this.url,
    required this.createdAt,
    required this.isUserLocked,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] ?? 0,
      course: json['course'] ?? 0,
      title: json['title'] ?? '',
      url: json['file'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      isUserLocked: json['is_user_locked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course': course,
      'title': title,
      'file': url,
      'created_at': createdAt.toIso8601String(),
      'is_user_locked': isUserLocked,
    };
  }
}
