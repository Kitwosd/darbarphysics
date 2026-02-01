class LiveClassDetailModel {
  final int id;
  final String title;
  final int? course;
  final int level;
  final int subject;
  final DateTime startTime;
  final DateTime endTime;
  final String meetingUrl;
  final String description;
  final bool isRecorded;
  final dynamic recordingUrl;
  final DateTime createdAt;
  final bool isLive;
  final bool willStartSoon;
  final String thumbnail;
  final String teacher;
  final String status;
  final bool isUserLocked;

  LiveClassDetailModel({
    required this.id,
    required this.title,
    this.course,
    required this.level,
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.meetingUrl,
    required this.description,
    required this.isRecorded,
    required this.recordingUrl,
    required this.createdAt,
    required this.isLive,
    required this.willStartSoon,
    required this.thumbnail,
    required this.teacher,
    required this.status,
    required this.isUserLocked,
  });

  // Calculate duration
  String get duration {
    final diff = endTime.difference(startTime);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    if (hours > 0) {
      return "$hours hour${hours > 1 ? 's' : ''} ${minutes > 0 ? '$minutes min' : ''}";
    }
    return '$minutes minutes';
  }

  // // Get teacher name formatted
  // String get teacherName {
  //   return teacher.split('').map((char, index) {
  //     if (index == 0) return char.toUpperCase();
  //     return char;
  //   }).join();
  // }

  String get teacherName {
    if (teacher.isEmpty) return teacher;

    final chars = teacher.split('');
    chars[0] = chars[0].toUpperCase();
    return chars.join();
  }

  factory LiveClassDetailModel.fromJson(Map<String, dynamic> json) =>
      LiveClassDetailModel(
        id: json["id"],
        title: json["title"],
        course: json["course"],
        level: json["level"],
        subject: json["subject"],
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
        meetingUrl: json["meeting_url"],
        description: json["description"],
        isRecorded: json["is_recorded"],
        recordingUrl: json["recording_url"],
        createdAt: DateTime.parse(json["created_at"]),
        isLive: json["is_live"],
        willStartSoon: json["will_start_soon"],
        thumbnail: json["thumbnail"],
        teacher: json["teacher"],
        status: json["status"],
        isUserLocked: json["is_user_locked"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "course": course,
    "level": level,
    "subject": subject,
    "start_time": startTime.toIso8601String(),
    "end_time": endTime.toIso8601String(),
    "meeting_url": meetingUrl,
    "description": description,
    "is_recorded": isRecorded,
    "recording_url": recordingUrl,
    "created_at": createdAt.toIso8601String(),
    "is_live": isLive,
    "will_start_soon": willStartSoon,
    "thumbnail": thumbnail,
    "teacher": teacher,
    "status": status,
    "is_user_locked": isUserLocked,
  };
}
