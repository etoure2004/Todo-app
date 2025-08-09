import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> tasks = [];
  static const _storageKey = 'tasks_v2'; // v2 because we now include description

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final List decoded = jsonDecode(raw) as List;
      final loaded = decoded
          .map((e) => Task.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
      setState(() {
        tasks
          ..clear()
          ..addAll(loaded);
      });
    } catch (_) {
      
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = tasks.map((t) => t.toMap()).toList();
    await prefs.setString(_storageKey, jsonEncode(data));
  }

  void addTask(String taskName, String description) {
    setState(() {
      tasks.add(Task(name: taskName, description: description));
    });
    _saveTasks();
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].toggleDone();
    });
    _saveTasks();
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My To-Do List'),
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                "No tasks yet. Tap + to add one.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key('${tasks[index].name}-$index'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => deleteTask(index),
                  child: TaskTile(
                    taskName: tasks[index].name,
                    taskDescription: tasks[index].description,
                    isDone: tasks[index].isDone,
                    checkboxCallback: (_) => toggleTask(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add');
          if (result != null && result is Map<String, String>) {
            final title = result['title']!;
            final description = result['description'] ?? '';
            addTask(title, description);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
