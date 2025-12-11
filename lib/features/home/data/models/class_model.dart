class ClassModel {
  final int id;
  final String name;
  final bool allowedStreams;
  final int capacity;

  ClassModel({
    required this.id,
    required this.name,
    required this.allowedStreams,
    required this.capacity,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) => ClassModel(
    id: json["id"],
    name: json["name"],
    allowedStreams: json["allowed_streams"],
    capacity: json["capacity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "allowed_streams": allowedStreams,
    "capacity": capacity,
  };
}
