class AcademicModel {
  final int id;
  final String name;

  AcademicModel({required this.id, required this.name});
  factory AcademicModel.fromJson(Map<String, dynamic> json) {
    return AcademicModel(id: json['id'], name: json['name']);
  }
}
