import 'package:flutter/material.dart';
import 'package:flutter_task_manager/models/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> tasks = [
    Task(title: 'Finish Flutter setup'),
    Task(title: 'Build task list screen'),
    Task(title: 'Add SQLite database', isDone: true),
  ];

  final TextEditingController _titleControler = TextEditingController();

  void _addTask() {
    final title = _titleControler.text.trim();
    if (title.isEmpty) return;

    setState(() {
      tasks.add(Task(title: title));
    });

    _titleControler.clear();
  }

  void _toggleDone(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleControler,
                    decoration: const InputDecoration(
                      hintText: 'New task title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  trailing: Icon(
                    task.isDone ? Icons.check_circle : Icons.circle_outlined,
                  ),
                  onTap: () => _toggleDone(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
