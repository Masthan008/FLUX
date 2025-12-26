import 'package:hive/hive.dart';

part 'class_session.g.dart';

@HiveType(typeId: 0)
class ClassSession extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String subjectName;

  @HiveField(2)
  int dayOfWeek; // 1=Monday, 2=Tuesday, ..., 6=Saturday

  @HiveField(3)
  DateTime startTime;

  @HiveField(4)
  DateTime endTime;

  ClassSession({
    required this.id,
    required this.subjectName,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });
}
