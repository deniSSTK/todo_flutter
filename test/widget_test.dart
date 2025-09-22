import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_flutter/features/presentation/pages/task_page.dart';
import 'package:todo_flutter/domain/usecase/task_usecase.dart';
import 'mocks.mocks.dart';

void main() {
  late MockTaskRepository mockRepo;
  late TaskUseCase taskUseCase;

  setUp(() {
    mockRepo = MockTaskRepository();
    taskUseCase = TaskUseCase(mockRepo);
  });

  testWidgets('adds a task', (WidgetTester tester) async {
    when(mockRepo.getTasks()).thenAnswer((_) async => []);
    when(mockRepo.saveTask(any)).thenAnswer((_) async => Future.value());

    await tester.pumpWidget(
      MaterialApp(
        home: TaskPage(taskUseCase: taskUseCase),
      ),
    );

    await tester.enterText(find.byType(TextField), 'New Task');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('New Task'), findsOneWidget);
  });
}
