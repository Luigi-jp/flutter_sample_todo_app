import 'dart:async';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import 'package:sample_todo_app/model/member.dart';
import 'package:sample_todo_app/storage/todo_storage.dart';

class DeadlineRestrictionException implements Exception {
  DeadlineRestrictionException(this.message);

  final String message;
}

class Todo {
  Todo({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.estimatedHours,
    required this.deadline,
    required this.assignee,
    this.isPublic = false,
  });
  
  final String id;
  final String title;
  bool isCompleted;
  final double estimatedHours;
  final DateTime deadline;
  final Member assignee;
  bool isPublic;

  String get formattedDeadline => DateFormat('yyyy/MM/dd HH:mm').format(deadline);

  Todo copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    double? estimatedHours,
    DateTime? deadline,
    Member? assignee,
    bool? isPublic,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      deadline: deadline ?? this.deadline,
      assignee: assignee ?? this.assignee,
      isPublic: isPublic ?? this.isPublic,
    );
  }
}

class TodoModel {
  TodoModel(this._storage);

  final TodoStorage _storage;
  final _todoController = StreamController<List<Todo>>.broadcast();
  final List<Todo> _todos = [];

  Stream<List<Todo>> get todoStream => _todoController.stream;

  void refreshTodos() {
    _todos.clear();
    _todos.addAll(_storage.fetchAll());
    _todoController.add(_todos);
  }

  void addTodo({
    required String title,
    required Member assignee,
    required double estimatedHours,
    required DateTime deadline,
  }) {
    try {
      _validateDeadlineRestriction(estimatedHours, deadline);
    } on DeadlineRestrictionException {
      rethrow;
    }

    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      isCompleted: false,
      estimatedHours: estimatedHours,
      deadline: deadline,
      assignee: assignee,
      isPublic: false,
    );

    _storage.save(todo);
    refreshTodos();
  }

  void _validateDeadlineRestriction(double estimatedHours, DateTime deadline) {
    final hoursUntilDeadline = deadline.difference(DateTime.now()).inHours;

    if (hoursUntilDeadline < estimatedHours) {
      throw DeadlineRestrictionException(
        'Not enough time to complete this task. Task needs $estimatedHours hours but only $hoursUntilDeadline hours available until deadline.'
      );
    }

    final todosBeforeDeadline = _todos
      .where((todo) => !todo.isCompleted)
      .where((todo) => 
        todo.deadline.isBefore(deadline) ||
        todo.deadline.isAtSameMomentAs(deadline)
      )
      .toList();

    final totalExistingHours = todosBeforeDeadline.fold<double>(
      0,
      (sum, todo) => sum + todo.estimatedHours,
    );

    final totalRequiredHours = totalExistingHours + estimatedHours;
    if (totalRequiredHours > hoursUntilDeadline) {
      throw DeadlineRestrictionException(
        'Not enough time to complete this task. You already have $totalExistingHours hours of tasks before this deadline.'
      );
    }
  }

  void toggleTodoCompletion(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) return;

    final todo = _todos[index];
    final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);

    _storage.update(updatedTodo);
    refreshTodos();
  }

  void deleteTodo(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) return;

    _storage.delete(id);
    refreshTodos();
  }

  void updateTodo({
    required String id,
    required String title,
    required double estimatedHours,
    required DateTime deadline,
    required Member assignee,
  }) {
    final originalTodo = _storage.fetchAll().firstWhereOrNull((todo) => todo.id == id);
    if (originalTodo == null) return;

    try {
      _validateDeadlineRestriction(estimatedHours, deadline);
    } on DeadlineRestrictionException {
      rethrow;
    }
    final updateTodo = Todo(
      id: id,
      title: title,
      isCompleted: originalTodo.isCompleted,
      estimatedHours: estimatedHours,
      deadline: deadline,
      assignee: assignee,
      isPublic: originalTodo.isPublic,
    );

    _storage.update(updateTodo);
    refreshTodos();
  }
}