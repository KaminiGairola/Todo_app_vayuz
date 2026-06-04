import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {

  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  bool isCompleted;


  TaskModel({
    required this.title,
    required this.description,
    required this.date,
    this.isCompleted = false,
  });
}