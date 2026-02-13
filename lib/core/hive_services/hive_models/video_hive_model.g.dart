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

    // Manually construct using your required constructor
    return VideoHiveModel(
      id: fields[0] as int,
      title: fields[1] as String,
      isLocked: fields[2] as bool,
      videoUrl: fields[3] as String,
      thumbnail: fields[4] as String?,
      duration: fields[5] as String,
      isUserLocked: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, VideoHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.isLocked)
      ..writeByte(3)
      ..write(obj.videoUrl)
      ..writeByte(4)
      ..write(obj.thumbnail)
      ..writeByte(5)
      ..write(obj.duration)
      ..writeByte(6)
      ..write(obj.isUserLocked);
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
