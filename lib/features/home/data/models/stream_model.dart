// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StreamModel extends Equatable {
  final int id;
  final String name;
  final int level;

  const StreamModel({required this.id, required this.name, required this.level});

  factory StreamModel.fromJson(Map<String, dynamic> json) =>
      StreamModel(id: json["id"], name: json["name"], level: json["level"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "level": level};

  @override
  List<Object> get props => [id, name, level];
}
