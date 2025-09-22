import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_flutter/domain/repository/task_repository.dart';
import '../entities/task.dart';

class LocalTaskRepository implements TaskRepository {
  static const _tasksKey = 'tasks';

  @override
  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_tasksKey);
    if (data == null) return [];
    final List<dynamic> decoded = jsonDecode(data);
    return decoded.map((e) => Task.fromMap(e)).toList();
  }

  @override
  Future<void> saveTask(Task task) async {
    final tasks = await getTasks();
    tasks.insert(0, task);
    await _saveAll(tasks);
  }

  @override
  Future<void> updateTask(Task task) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await _saveAll(tasks);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.id == id);
    await _saveAll(tasks);
  }

  Future<void> _saveAll(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(tasks.map((e) => e.toMap()).toList());
    await prefs.setString(_tasksKey, encoded);
  }
}
