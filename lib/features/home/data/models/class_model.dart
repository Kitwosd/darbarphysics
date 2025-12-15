// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ClassModel extends Equatable {
  final int id;
  final String name;
  final bool allowedStreams;
  final int capacity;

  const ClassModel({
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

  @override
  List<Object> get props => [id, name, allowedStreams, capacity];
}
