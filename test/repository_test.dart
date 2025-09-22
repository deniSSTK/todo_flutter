import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_flutter/domain/entities/task.dart';
import 'package:todo_flutter/domain/usecase/task_usecase.dart';
import 'package:todo_flutter/domain/repository/task_repository.dart';

import 'repository_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late MockTaskRepository mockRepo;
  late TaskUseCase useCase;

  setUp(() {
    mockRepo = MockTaskRepository();
    useCase = TaskUseCase(mockRepo);
  });

  test('saveTask calls repository', () async {
    final task = Task(text: 'Test');
    when(mockRepo.saveTask(any)).thenAnswer((_) async => Future.value());

    await useCase.saveTask(task);

    verify(mockRepo.saveTask(task)).called(1);
  });

  test('updateTask calls repository', () async {
    final task = Task(text: 'Update');
    when(mockRepo.updateTask(any)).thenAnswer((_) async => Future.value());

    await useCase.updateTask(task);

    verify(mockRepo.updateTask(task)).called(1);
  });

  test('remove calls repository', () async {
    const id = '123';
    when(mockRepo.deleteTask(any)).thenAnswer((_) async => Future.value());

    await useCase.remove(id);

    verify(mockRepo.deleteTask(id)).called(1);
  });

  test('getAll returns tasks', () async {
    final tasks = [Task(text: 'A'), Task(text: 'B')];
    when(mockRepo.getTasks()).thenAnswer((_) async => tasks);

    final result = await useCase.getAll();

    expect(result, tasks);
  });
}
