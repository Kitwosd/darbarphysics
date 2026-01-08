// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoHiveModelAdapter extends TypeAdapter<VideoHiveModel> {
  @override
  final typeId = 1;

  @override
  VideoHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoHiveModel();
  }

  @override
  void write(BinaryWriter writer, VideoHiveModel obj) {
    writer.writeByte(0);
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
