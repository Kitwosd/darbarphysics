// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class LiveClassModel extends Equatable {
  final int id;
  final String title;
  final String thumbnail;
  final String teacherName;
  final DateTime startTime;
  final bool isLive; // 'live', 'upcoming', 'ended'
  final String meetingUrl;
  final String? password;
  final String status;
  final bool isUserLocked;
  final int course;

  const LiveClassModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.teacherName,
    required this.startTime,
    required this.isLive,
    required this.meetingUrl,
    required this.status,
    this.password,
    required this.isUserLocked,
    required this.course,
  });

  factory LiveClassModel.fromJson(Map<String, dynamic> json) => LiveClassModel(
    id: json["id"] ?? 0,
    title: json["title"] ?? '',
    thumbnail:
        json["thumbnail"] ??
        'https://img.freepik.com/free-vector/online-tutorials-concept_52683-37480.jpg',
    teacherName: json["teacherName"] ?? 'Unknown Teacher',
    startTime: json["startTime"] != null
        ? DateTime.parse(json["startTime"])
        : DateTime.now(),
    isLive: json["is_live"],
    meetingUrl: json["meetingUrl"] ?? '',
    password: json["password"],
    isUserLocked: json["is_user_locked"] ?? false,
    status: json["status"],
    course: json["course"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "thumbnail": thumbnail,
    "teacherName": teacherName,
    "startTime": startTime.toIso8601String(),
    "is_live": isLive,
    "meetingUrl": meetingUrl,
    "password": password,
    "status": status,
    "is_user_locked": isUserLocked,
    "course": course,
  };

  @override
  List<Object?> get props => [
    id,
    title,
    thumbnail,
    teacherName,
    startTime,
    isLive,
    meetingUrl,
    password,
    status,
    isUserLocked,
    course,
  ];
}
