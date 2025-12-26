// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassSessionAdapter extends TypeAdapter<ClassSession> {
  @override
  final int typeId = 0;

  @override
  ClassSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassSession(
      id: fields[0] as String,
      subjectName: fields[1] as String,
      dayOfWeek: fields[2] as int,
      startTime: fields[3] as DateTime,
      endTime: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ClassSession obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.subjectName)
      ..writeByte(2)
      ..write(obj.dayOfWeek)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
