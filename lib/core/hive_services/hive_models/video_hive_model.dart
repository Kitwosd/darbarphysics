import 'package:hive/hive.dart';

part 'video_hive_model.g.dart';

@HiveType(typeId: 1)
class VideoHiveModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final bool isLocked;

  @HiveField(3)
  final int? course;

  @HiveField(4)
  final String videoUrl;

  @HiveField(5)
  final String? thumbnail;

  @HiveField(6)
  final String duration;

  @HiveField(7)
  final bool isUserLocked;

  // ✅ NEW FIELDS (SAFE)
  @HiveField(8)
  final String? levelName;

  @HiveField(9)
  final String? subjectName;

  VideoHiveModel({
    required this.id,
    required this.title,
    required this.isLocked,
    required this.videoUrl,
    this.thumbnail,
    required this.duration,
    required this.isUserLocked,
    this.course,
    this.levelName,
    this.subjectName,
  });

  VideoHiveModel copyWith({
    int? id,
    String? title,
    bool? isLocked,
    String? videoUrl,
    String? thumbnail,
    String? duration,
    bool? isUserLocked,
    int? course,
    String? levelName,
    String? subjectName,
  }) {
    return VideoHiveModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isLocked: isLocked ?? this.isLocked,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnail: thumbnail ?? this.thumbnail,
      duration: duration ?? this.duration,
      isUserLocked: isUserLocked ?? this.isUserLocked,
      course: course ?? this.course,
      levelName: levelName ?? this.levelName,
      subjectName: subjectName ?? this.subjectName,
    );
  }
}

////So just paste this code in the video_hive_model.g.dart cause dart build runner is not registering the required fields and not generating what we want
// // GENERATED CODE - DO NOT MODIFY BY HAND





// part of 'video_hive_model.dart';

// class VideoHiveModelAdapter extends TypeAdapter<VideoHiveModel> {
//   @override
//   final int typeId = 1;

//   @override
//   VideoHiveModel read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };

//     int? course;
//     String videoUrl = "";

//     // ✅ HANDLE OLD + NEW DATA
//     if (fields.containsKey(3)) {
//       if (fields[3] is int) {
//         // NEW STRUCTURE
//         course = fields[3] as int?;
//         videoUrl = fields[4] as String;
//       } else if (fields[3] is String) {
//         // OLD STRUCTURE
//         course = null;
//         videoUrl = fields[3] as String;
//       }
//     }

//     return VideoHiveModel(
//       id: fields[0] as int,
//       title: fields[1] as String,
//       isLocked: fields[2] as bool,
//       course: course,
//       videoUrl: videoUrl,
//       thumbnail: fields[5] as String?,
//       duration: fields[6] as String,
//       isUserLocked: fields[7] as bool,
//       levelName:
//           fields.containsKey(8) ? fields[8] as String? : null,
//       subjectName:
//           fields.containsKey(9) ? fields[9] as String? : null,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, VideoHiveModel obj) {
//     writer
//       ..writeByte(10)
//       ..writeByte(0)
//       ..write(obj.id)
//       ..writeByte(1)
//       ..write(obj.title)
//       ..writeByte(2)
//       ..write(obj.isLocked)
//       ..writeByte(3)
//       ..write(obj.course)
//       ..writeByte(4)
//       ..write(obj.videoUrl)
//       ..writeByte(5)
//       ..write(obj.thumbnail)
//       ..writeByte(6)
//       ..write(obj.duration)
//       ..writeByte(7)
//       ..write(obj.isUserLocked)
//       ..writeByte(8)
//       ..write(obj.levelName)
//       ..writeByte(9)
//       ..write(obj.subjectName);
//   }

//   @override
//   int get hashCode => typeId.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is VideoHiveModelAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }