part of 'video_hive_model.dart';

class VideoHiveModelAdapter extends TypeAdapter<VideoHiveModel> {
  @override
  final int typeId = 1;

  @override
  VideoHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    int? course;
    String videoUrl = "";

    // ✅ HANDLE OLD + NEW DATA
    if (fields.containsKey(3)) {
      if (fields[3] is int) {
        // NEW STRUCTURE
        course = fields[3] as int?;
        videoUrl = fields[4] as String;
      } else if (fields[3] is String) {
        // OLD STRUCTURE
        course = null;
        videoUrl = fields[3] as String;
      }
    }

    return VideoHiveModel(
      id: fields[0] as int,
      title: fields[1] as String,
      isLocked: fields[2] as bool,
      course: course,
      videoUrl: videoUrl,
      thumbnail: fields[5] as String?,
      duration: fields[6] as String,
      isUserLocked: fields[7] as bool,
      levelName:
          fields.containsKey(8) ? fields[8] as String? : null,
      subjectName:
          fields.containsKey(9) ? fields[9] as String? : null,
    );
  }

  @override
  void write(BinaryWriter writer, VideoHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.isLocked)
      ..writeByte(3)
      ..write(obj.course)
      ..writeByte(4)
      ..write(obj.videoUrl)
      ..writeByte(5)
      ..write(obj.thumbnail)
      ..writeByte(6)
      ..write(obj.duration)
      ..writeByte(7)
      ..write(obj.isUserLocked)
      ..writeByte(8)
      ..write(obj.levelName)
      ..writeByte(9)
      ..write(obj.subjectName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}