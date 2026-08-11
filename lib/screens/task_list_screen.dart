import 'package:flutter/material.dart';
import 'package:flutter_task_manager/db/database_helper.dart';
import 'package:flutter_task_manager/models/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  //Tasks list from database
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  //Load saved tasks
  Future<void> _loadTasks() async {
    final data = await DatabaseHelper.instance.getAllTasks();
    setState(() {
      tasks = data;
    });
  }

  //Add new task controller
  final TextEditingController _titleController = TextEditingController();

  //Add new task action
  void _addTask() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final newTask = Task(title: title);
    await DatabaseHelper.instance.insertTask(newTask);

    _titleController.clear();
    _loadTasks();
  }

  //Toggle task action
  void _toggleDone(int index) async {
    final task = tasks[index];
    task.isDone = !task.isDone;
    await DatabaseHelper.instance.updateTask(task);
    _loadTasks();
  }

  //Delete task action
  void _deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    _loadTasks();
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
                //Add new task controller builder
                Expanded(
                  child: TextField(
                    controller: _titleController,
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

          //Tasks list builder
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Dismissible(
                  key: Key(task.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) => _deleteTask(task.id!),
                  child: ListTile(
                    title: Text(task.title),
                    trailing: Icon(
                      task.isDone ? Icons.check_circle : Icons.circle_outlined,
                    ),
                    onTap: () => _toggleDone(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
