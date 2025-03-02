import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sample_todo_app/model/todo.dart';

class TodoViewState {
  TodoViewState({
    required this.todos,
    required this.showCompleted,
  });

  final List<Todo> todos;
  final bool showCompleted;

  List<Todo> get filteredTodos => showCompleted ? todos : todos.where((todo) => !todo.isCompleted).toList();

  TodoViewState copyWith({
    List<Todo>? todos,
    bool? showCompleted,
  }) {
    return TodoViewState(
      todos: todos ?? this.todos,
      showCompleted: showCompleted ?? this.showCompleted,
    );
  }
}

class TodoViewModel extends StateNotifier<TodoViewState> {
  TodoViewModel(this._model)
    : super(TodoViewState(todos: [], showCompleted: true)) {
      _model.todoStream.listen((todos) {
        state = state.copyWith(todos: todos);
      });

      _model.refreshTodos();
    }

  final TodoModel _model;

  void toggleTodoCompletion(String id) {
    _model.toggleTodoCompletion(id);
  }

  void deleteTodo(String id) {
    _model.deleteTodo(id);
  }

  void toggleShowCompleted() {
    state = state.copyWith(showCompleted: !state.showCompleted);
  }
}