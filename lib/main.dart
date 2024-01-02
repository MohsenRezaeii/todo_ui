import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class Task {
  final String id;
  final String title;
  final String description;
  final String creationDate;
  final String status;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.creationDate,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      creationDate: json['creationDate'],
      status: json['status'],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Todo App',
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late List<Task> tasks;

  @override
  void initState() {
    super.initState();
    tasks = [];
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final response = await http.get(Uri.parse('http://localhost:8080/tasks'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        tasks = data.map((task) => Task.fromJson(task)).toList();
      });
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
      ),
      body: tasks == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
            trailing: Text(task.status),
          );
        },
      ),
    );
  }
}