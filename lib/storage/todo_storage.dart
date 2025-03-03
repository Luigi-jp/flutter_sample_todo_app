import 'package:sample_todo_app/model/member.dart';
import 'package:sample_todo_app/model/todo.dart';


class TodoStorage {
  final List<Todo> _todos = [
    Todo(
      id: '1',
      title: 'Buy groceries',
      assignee: Member(
        id: '1',
        name: 'John Doe',
        icon: IconType.person,
      ),
      isCompleted: false,
      estimatedHours: 1.0,
      deadline: DateTime.now(),
    ),
    Todo(
      id: '2',
      title: 'Buy groceries',
      assignee: Member(
        id: '2',
        name: 'Jane Doe',
        icon: IconType.person,
      ),
      isCompleted: false,
      estimatedHours: 1.0,
      deadline: DateTime.now(),
    ),
    Todo(
      id: '3',
      title: 'Buy groceries',
      assignee: Member(
        id: '3',
        name: 'John Doe',
        icon: IconType.person,
      ),
      isCompleted: false,
      estimatedHours: 1.0,
      deadline: DateTime.now(),
    ),
  ];

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