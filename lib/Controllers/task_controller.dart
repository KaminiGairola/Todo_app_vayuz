import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';

import '../Models/task_model.dart';

class TaskController extends GetxController {

  var tasks = <TaskModel>[].obs;

  final box = Hive.box<TaskModel>('tasks');

  @override
  void onInit() {
    loadTasks();
    super.onInit();
  }

  void loadTasks() {
    tasks.value = box.values.toList();
  }

  void addTask(TaskModel task) {
    box.add(task);
    loadTasks();
  }

  void deleteTask(int index) {
    box.deleteAt(index);
    loadTasks();
  }

  void updateTask(
      TaskModel task,
      String title,
      String description,
      DateTime date,
      ) {

    task.title = title;
    task.description = description;
    task.date = date;

    task.save();

    loadTasks();
  }

  void toggleStatus(TaskModel task) {
    task.isCompleted = !task.isCompleted;
    task.save();
    loadTasks();
  }

  String getCategory(DateTime taskDate) {
    DateTime now = DateTime.now();

    DateTime today =
    DateTime(now.year, now.month, now.day);

    DateTime task =
    DateTime(
      taskDate.year,
      taskDate.month,
      taskDate.day,
    );

    if (task.isBefore(today)) {
      return "Yesterday";
    }

    if (task.isAtSameMomentAs(today)) {
      return "Today";
    }

    return "Future";
  }

  List<TaskModel> getFilteredTasks(TaskFilter filter) {

    switch (filter) {

      case TaskFilter.yesterday:
        return tasks.where(
                (e) => getCategory(e.date) == "Yesterday")
            .toList();

      case TaskFilter.today:
        return tasks.where(
                (e) => getCategory(e.date) == "Today")
            .toList();

      case TaskFilter.future:
        return tasks.where(
                (e) => getCategory(e.date) == "Future")
            .toList();



      case TaskFilter.completed:
        return tasks.where(
                (e) => e.isCompleted)
            .toList();

      case TaskFilter.pending:
        return tasks.where(
                (e) => !e.isCompleted)
            .toList();

      case TaskFilter.all:
      default:
        return tasks;
    }
  }

}enum TaskFilter {
  all,
  yesterday,
  today,
  future,
  completed,
  pending,
}
