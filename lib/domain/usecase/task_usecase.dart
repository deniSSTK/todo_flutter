import 'package:todo_flutter/domain/repository/task_repository.dart';

import '../entities/task.dart';

class TaskUseCase {
  final TaskRepository taskRepository;

  TaskUseCase(this.taskRepository);

  Future<void> saveTask(Task task) async {
    if (task.text.trim().isEmpty) return;
    await taskRepository.saveTask(task);
  }

  Future<List<Task>> getAll() async {
    return await taskRepository.getTasks();
  }

  Future<void> updateTask(Task task) async {
    await taskRepository.updateTask(task);
  }

  Future<void> remove(String id) async {
    await taskRepository.deleteTask(id);
  }
}