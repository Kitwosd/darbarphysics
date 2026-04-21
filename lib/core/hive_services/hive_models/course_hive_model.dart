import 'package:hive/hive.dart';

part 'course_hive_model.g.dart';

@HiveType(typeId: 2)
class CourseHiveModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String cost;

  @HiveField(4)
  final String image;

  @HiveField(5)
  final double rating;

  @HiveField(6)
  final int studentCount;

  @HiveField(7)
  final int lessonCount;

  @HiveField(8)
  final int liveClassCount;

  @HiveField(9)
  final bool isUserLocked;

  // ✅ NEW FIELDS (nullable for safety)
  @HiveField(10)
  final String? levelName;

  @HiveField(11)
  final String? subjectName;

  CourseHiveModel({
    required this.id,
    required this.title,
    required this.description,
    required this.cost,
    required this.image,
    required this.rating,
    required this.studentCount,
    required this.lessonCount,
    required this.liveClassCount,
    required this.isUserLocked,
    this.levelName,
    this.subjectName,
  });

  CourseHiveModel copyWith({
    int? id,
    String? title,
    String? description,
    String? cost,
    String? image,
    double? rating,
    int? studentCount,
    int? lessonCount,
    int? liveClassCount,
    bool? isUserLocked,
    String? levelName,
    String? subjectName,
  }) {
    return CourseHiveModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      cost: cost ?? this.cost,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      studentCount: studentCount ?? this.studentCount,
      lessonCount: lessonCount ?? this.lessonCount,
      liveClassCount: liveClassCount ?? this.liveClassCount,
      isUserLocked: isUserLocked ?? this.isUserLocked,
      levelName: levelName ?? this.levelName,
      subjectName: subjectName ?? this.subjectName,
    );
  }
}

////So just paste this code in the video_hive_model.g.dart cause dart build runner is not registering the required fields and not generating what we want
///

// part of 'course_hive_model.dart';

// class CourseHiveModelAdapter extends TypeAdapter<CourseHiveModel> {
//   @override
//   final int typeId = 2;

//   @override
//   CourseHiveModel read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };

//     return CourseHiveModel(
//       id: fields[0] as int,
//       title: fields[1] as String,
//       description: fields[2] as String,
//       cost: fields[3] as String,
//       image: fields[4] as String,
//       rating: fields[5] as double,
//       studentCount: fields[6] as int,
//       lessonCount: fields[7] as int,
//       liveClassCount: fields[8] as int,
//       isUserLocked: fields[9] as bool,

//       // ✅ SAFE READ (no crash for old users)
//       levelName:
//           fields.containsKey(10) ? fields[10] as String? : null,
//       subjectName:
//           fields.containsKey(11) ? fields[11] as String? : null,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, CourseHiveModel obj) {
//     writer
//       ..writeByte(12) // ✅ updated count
//       ..writeByte(0)
//       ..write(obj.id)
//       ..writeByte(1)
//       ..write(obj.title)
//       ..writeByte(2)
//       ..write(obj.description)
//       ..writeByte(3)
//       ..write(obj.cost)
//       ..writeByte(4)
//       ..write(obj.image)
//       ..writeByte(5)
//       ..write(obj.rating)
//       ..writeByte(6)
//       ..write(obj.studentCount)
//       ..writeByte(7)
//       ..write(obj.lessonCount)
//       ..writeByte(8)
//       ..write(obj.liveClassCount)
//       ..writeByte(9)
//       ..write(obj.isUserLocked)

//       // ✅ NEW FIELDS
//       ..writeByte(10)
//       ..write(obj.levelName)
//       ..writeByte(11)
//       ..write(obj.subjectName);
//   }

//   @override
//   int get hashCode => typeId.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is CourseHiveModelAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }