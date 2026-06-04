import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/task_controller.dart';
import '../Models/task_model.dart';

class AddTaskScreen extends StatefulWidget {

  final TaskModel? task;

  const AddTaskScreen({
    super.key,
    this.task,
  });

  @override
  State<AddTaskScreen> createState() =>
      _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {

  // Widget colorCircle(Color color) {
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         selectedColor = color;
  //       });
  //     },
  //     child: CircleAvatar(
  //       radius: 18,
  //       backgroundColor: color,
  //       child: selectedColor == color
  //           ? const Icon(Icons.check)
  //           : null,
  //     ),
  //   );
  //= }

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Color selectedColor = Colors.blue.shade100;

  final TaskController taskController =
  Get.find<TaskController>();

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {

      titleController.text =
          widget.task!.title;

      descriptionController.text =
          widget.task!.description;

      selectedDate =
          widget.task!.date;
      }
  }
  Future<void> pickDate() async {

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void saveTask() {

    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedDate == null) {

      Get.snackbar(
        "Error",
        "Please fill all fields",
      );

      return;
    }

    if (widget.task == null) {

      taskController.addTask(
        TaskModel(
          title: titleController.text,
          description: descriptionController.text,
          date: selectedDate!,
        ),
      );
    } else {

      taskController.updateTask(
        widget.task!,
        titleController.text,
        descriptionController.text,
        selectedDate!,
      );
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        elevation: 0,

        centerTitle: true,
        title:

        Text(
          widget.task == null
              ? "Create Task ✨"
              : "Update Task ✨",
        ),
      ),

      body:

      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade100,
              Colors.blue.shade100,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: SingleChildScrollView(
            child: Column(
              children: [

                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Task Title",
                    prefixIcon: const Icon(Icons.task_alt),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Task Description",
                    prefixIcon: const Icon(Icons.description),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // const Text(
                //   "Choose Color",
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 16,
                //   ),
                // ),
                //
                // const SizedBox(height: 10),
                //
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //
                //     colorCircle(Colors.blue.shade100),
                //     colorCircle(Colors.purple.shade100),
                //     colorCircle(Colors.green.shade100),
                //     colorCircle(Colors.orange.shade100),
                //     colorCircle(Colors.pink.shade100),
                //
                //   ],
                // ),


                const SizedBox(height: 15),

                ElevatedButton.icon(
                  onPressed: pickDate,
                  icon: const Icon(Icons.calendar_month),
                  label: Text(
                    selectedDate == null
                        ? "Select Date"
                        : selectedDate.toString().split(' ')[0],
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(
                      double.infinity,
                      55,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: saveTask,
                  icon: Icon(
                    widget.task == null
                        ? Icons.add_task
                        : Icons.update,
                  ),
                  label: Text(
                    widget.task == null
                        ? "Save Task"
                        : "Update Task",
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(
                      double.infinity,
                      55,
                    ),
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}