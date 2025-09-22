import 'package:flutter/material.dart';
import 'package:todo_flutter/core/styles/styles.dart';
import 'package:todo_flutter/features/presentation/widgets/styled_text_filed.dart';

import '../../../domain/entities/task.dart';
import '../../../domain/repository/local_task_repository.dart';
import '../../../domain/usecase/task_usecase.dart';

class TaskPage extends StatefulWidget {
  final TaskUseCase? taskUseCase;

  const TaskPage({super.key, this.taskUseCase});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late final TaskUseCase _taskUseCase;
  List<Task> _tasks = [];

  bool _showDone = true;
  bool _sortByNewest = true;

  @override
  void initState() {
    super.initState();
    _taskUseCase = TaskUseCase(LocalTaskRepository());
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _taskUseCase.getAll();
    setState(() {
      _tasks = tasks;
    });

    for (int i = 0; i < _tasks.length; i++) {
      _listKey.currentState?.insertItem(i, duration: Duration.zero);
    }
  }

  Future<void> _addTask(String text) async {
    if (text.trim().isEmpty) return;

    final newTask = Task(text: text);
    await _taskUseCase.saveTask(newTask);

    final updatedTasks = await _taskUseCase.getAll();

    setState(() {
      _tasks = updatedTasks;
    });
    _listKey.currentState?.insertItem(0);
    _controller.clear();
  }

  Future<void> _toggleDone(Task task) async {
    task.isDone = !task.isDone;
    await _taskUseCase.updateTask(task);

    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      setState(() {
        _tasks[index] = task;
      });
    }
  }

  Future<void> _removeTask(int index) async {
    final removedTask = _tasks[index];

    _tasks.removeAt(index);
    await _taskUseCase.remove(removedTask.id);

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildTaskItem(removedTask, index, animation),
      duration: AppAnimation.duration,
    );
  }

  List<Task> get _filteredTasks {
    List<Task> list = List.from(_tasks);

    if (!_showDone) list = list.where((t) => !t.isDone).toList();

    list.sort((a, b) => _sortByNewest
        ? b.createdAt.compareTo(a.createdAt)
        : a.createdAt.compareTo(b.createdAt));

    return list;
  }

  Widget _buildTaskItem(Task task, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
            vertical: AppPadding.small, horizontal: AppPadding.medium),
        child: Card(
          color: task.isDone ? AppColors.doneTask : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: task.isDone,
                        onChanged: (_) => _toggleDone(task),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: AppColors.deleteIcon),
                      onPressed: () => _removeTask(index),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  task.text,
                  style:
                  AppTextStyle.mid,
                ),
                const SizedBox(height: 8),
                Text(
                  task.createdAt.toLocal().toString().substring(0, 16),
                  style: AppTextStyle.small.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _filters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: _showDone,
            onChanged: (val) {
              setState(() {
                _showDone = !_showDone;
              });
            },
          ),
          const Text('Show done'),

          const SizedBox(width: 20),

          IconButton(
            icon: Icon(_sortByNewest ? Icons.arrow_downward : Icons.arrow_upward),
            onPressed: () {
              setState(() {
                _sortByNewest = !_sortByNewest;
              });
            },
          ),
          const Text('Sort by date'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      child: StyledTextField(
                          controller: _controller,
                          hintText: 'Input task',
                          onSubmitted: _addTask)),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _addTask(_controller.text),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
          _filters(),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTasks.length,
              itemBuilder: (context, index) {
                final task = _filteredTasks[index];
                return _buildTaskItem(task, index, kAlwaysCompleteAnimation);
              },
            ),
          ),
        ],
      ),
    );
  }
}