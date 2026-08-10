import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Task> tasks = [
      Task(title: 'Finish Flutter setup'),
      Task(title: 'Build task list screen'),
      Task(title: 'Add SQLite database', isDone: true),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.title),
            trailing: Icon(
              task.isDone ? Icons.check_circle : Icons.circle_outlined,
            ),
          );
        },
      ),
    );
  }
}
