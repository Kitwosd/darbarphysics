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
  @HiveField(3)
  final String videoUrl;
  @HiveField(4)
  final String? thumbnail;
  @HiveField(5)
  final String duration;
  @HiveField(6)
  final bool isUserLocked;

  VideoHiveModel({
    required this.id,
    required this.title,
    required this.isLocked,
    required this.videoUrl,
    this.thumbnail,
    required this.duration,
    required this.isUserLocked,
    this.course,
  });

  //Added copyWith for immutability
  VideoHiveModel copyWith({
    int? id,
    String? title,
    bool? isLocked,
    String? videoUrl,
    String? thumbnail,
    String? duration,
    bool? isUserLocked,
    int? course,
  }) {
    return VideoHiveModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isLocked: isLocked ?? this.isLocked,
      videoUrl: videoUrl ?? this.videoUrl,
      duration: duration ?? this.duration,
      isUserLocked: isUserLocked ?? this.isUserLocked,
      course: course ?? this.course,
    );
  }
}

////So just paste this code in the video_hive_model.g.dart cause dart build runner is not registering the required fields and not generating what we want

// video_hive_model.g.dart
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

//     // Manually construct using your required constructor
//     return VideoHiveModel(
//       id: fields[0] as int,
//       title: fields[1] as String,
//       isLocked: fields[2] as bool,
//       videoUrl: fields[3] as String,
//       thumbnail: fields[4] as String?,
//       duration: fields[5] as String,
//       isUserLocked: fields[6] as bool,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, VideoHiveModel obj) {
//     writer
//       ..writeByte(7)
//       ..writeByte(0)
//       ..write(obj.id)
//       ..writeByte(1)
//       ..write(obj.title)
//       ..writeByte(2)
//       ..write(obj.isLocked)
//       ..writeByte(3)
//       ..write(obj.videoUrl)
//       ..writeByte(4)
//       ..write(obj.thumbnail)
//       ..writeByte(5)
//       ..write(obj.duration)
//       ..writeByte(6)
//       ..write(obj.isUserLocked);
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
