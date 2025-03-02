import 'package:sample_todo_app/model/todo.dart';

class TodoStorage {
  final List<Todo> _todos = [];

  List<Todo> fetchAll() {
    return [..._todos];
  }

  void save(Todo todo) {
    _todos.add(todo);
  }

  void update(Todo todo) {
    _todos[_todos.indexWhere((t) => t.id == todo.id)] = todo;
  }

  void delete(String id) {
    _todos.removeWhere((todo) => todo.id == id);
  }
}