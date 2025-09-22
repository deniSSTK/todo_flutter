import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Task {
  String id;
  String text;
  bool isDone;
  DateTime createdAt;

  Task({
    required this.text,
    this.isDone = false,
    String? id,
    DateTime? createdAt,
  }) : id = id ?? uuid.v4(), createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'id': id,
    'text': text,
    'isDone': isDone,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'],
    text: map['text'],
    isDone: map['isDone'],
    createdAt: DateTime.parse(map['createdAt']),
  );
  @override
  String toString() {
    return 'Task{id: $id, text: $text, isDone: $isDone, createdAt: $createdAt}';
  }
}
