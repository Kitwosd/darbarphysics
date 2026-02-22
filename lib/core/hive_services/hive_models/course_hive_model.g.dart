
//  course_hive_model.g.dart
part of 'course_hive_model.dart';

class CourseHiveModelAdapter extends TypeAdapter<CourseHiveModel> {
  @override
  final int typeId = 2;

  @override
  CourseHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    
    // ✅ MANUALLY ADD THIS - the generator creates empty constructor
    return CourseHiveModel(
      id: fields[0] as int,
      title: fields[1] as String,
      description: fields[2] as String,
      cost: fields[3] as String,
      image: fields[4] as String,
      rating: fields[5] as double,
      studentCount: fields[6] as int,
      lessonCount: fields[7] as int,
      liveClassCount: fields[8] as int,
      isUserLocked: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CourseHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.cost)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.studentCount)
      ..writeByte(7)
      ..write(obj.lessonCount)
      ..writeByte(8)
      ..write(obj.liveClassCount)
      ..writeByte(9)
      ..write(obj.isUserLocked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}