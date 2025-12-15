// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class LiveClassModel extends Equatable {
  final int id;
  final String title;

  const LiveClassModel({required this.id, required this.title});

  factory LiveClassModel.fromJson(Map<String, dynamic> json) =>
      LiveClassModel(id: json["id"], title: json["title"]);

  Map<String, dynamic> toJson() => {"id": id, "title": title};

  @override
  List<Object> get props => [id, title];
}
