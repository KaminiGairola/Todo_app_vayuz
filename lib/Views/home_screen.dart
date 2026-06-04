import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/task_controller.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final TaskController controller = Get.put(TaskController());

  TaskFilter selectedFilter = TaskFilter.all;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Tasks",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Stay organized ✨",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),


       floatingActionButton: FloatingActionButton.extended(
         onPressed: () {
           Get.to(() => const AddTaskScreen());
         },
         icon: const Icon(Icons.add),
         label: const Text("Add Task"),
       ),
    //FloatingActionButton(
      //   onPressed: () {
      //     Get.to(() => const AddTaskScreen());
      //   },
      //   child: const Icon(Icons.add),
      // ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
          [
            Colors.deepPurple.shade100,
            Colors.blue.shade100,
          ],)
        ),
        child: Column(
          children: [
            Obx(() {

              int total = controller.tasks.length;

              int completed = controller.tasks
                  .where((e) => e.isCompleted)
                  .length;

              int pending = total - completed;

              return Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: Column(
                  children: [

                    const Row(
                      children: [
                        Icon(Icons.waving_hand),
                        SizedBox(width: 8),
                        Text(
                          "Hello 👋",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: [

                        Column(
                          children: [
                            Text("$total"),
                            const Text("Total"),
                          ],
                        ),

                        Column(
                          children: [
                            Text("$completed"),
                            const Text("Done"),
                          ],
                        ),

                        Column(
                          children: [
                            Text("$pending"),
                            const Text("Pending"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.all(10),
              child:
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButton<TaskFilter>(
                  underline: const SizedBox(),
                  isExpanded: true,
                  value: selectedFilter,
                items: TaskFilter.values.map((filter) {
                  return DropdownMenuItem(
                    value: filter,
                    child: Text(filter.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFilter = value!;
                  });
                },
              ),
            ),
            ),


            Expanded(
              child: Obx(() {

                final tasks =
                controller.getFilteredTasks(selectedFilter);

                if (tasks.isEmpty) {
                  return const Center(
                    child: Text("No Tasks Found"),
                  );
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {

                    final task = tasks[index];

                    return Container(
                        margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                    ),
                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                    BoxShadow(
                    blurRadius: 8,
                    color: Colors.black12,
                    ),
                    ],
                    ),
                      child: ListTile(

                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (_) {
                            controller.toggleStatus(task);
                          },
                        ),

                        title: Text(
                          task.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            Text(task.description),

                            const SizedBox(height: 5),

                            Chip(
                              label: Text(
                                controller.getCategory(task.date),
                              ),
                            ),
                          ],
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Get.to(
                                      () => AddTaskScreen(
                                    task: task,
                                  ),
                                );
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                controller.deleteTask(index);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}