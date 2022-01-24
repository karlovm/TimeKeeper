import 'package:hive/hive.dart';
part 'taskData.g.dart';

@HiveType(typeId: 1)
class TaskData extends HiveObject
{
  @HiveField(0)
  String taskName;

  @HiveField(1)
  int hours;

  TaskData(this.taskName, this.hours);
}