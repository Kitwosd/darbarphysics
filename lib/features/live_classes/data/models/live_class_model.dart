// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class LiveClassModel extends Equatable {
  final int id;
  final String title;
  final String thumbnailUrl;
  final String teacherName;
  final DateTime startTime;
  final String status; // 'live', 'upcoming', 'ended'
  final String meetingUrl;
  final String? password;

  const LiveClassModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.teacherName,
    required this.startTime,
    required this.status,
    required this.meetingUrl,
    this.password,
  });

  factory LiveClassModel.fromJson(Map<String, dynamic> json) => LiveClassModel(
    id: json["id"] ?? 0,
    title: json["title"] ?? '',
    thumbnailUrl:
        json["thumbnailUrl"] ??
        'https://img.freepik.com/free-vector/online-tutorials-concept_52683-37480.jpg',
    teacherName: json["teacherName"] ?? 'Unknown Teacher',
    startTime: json["startTime"] != null
        ? DateTime.parse(json["startTime"])
        : DateTime.now(),
    status: json["status"] ?? 'upcoming',
    meetingUrl: json["meetingUrl"] ?? '',
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "thumbnailUrl": thumbnailUrl,
    "teacherName": teacherName,
    "startTime": startTime.toIso8601String(),
    "status": status,
    "meetingUrl": meetingUrl,
    "password": password,
  };

  @override
  List<Object?> get props => [
    id,
    title,
    thumbnailUrl,
    teacherName,
    startTime,
    status,
    meetingUrl,
    password,
  ];
}
