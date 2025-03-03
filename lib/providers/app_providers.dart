import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_todo_app/model/member_model.dart';

import 'package:sample_todo_app/model/todo.dart';
import 'package:sample_todo_app/storage/member_storage.dart';
import 'package:sample_todo_app/storage/todo_storage.dart';
import 'package:sample_todo_app/view_model/add_todo_view_model.dart';
import 'package:sample_todo_app/view_model/edit_todo_view_model.dart';
import 'package:sample_todo_app/view_model/member_list_view_model.dart';
import 'package:sample_todo_app/view_model/todo_view_model.dart';

final todoModelProvider = Provider<TodoModel>((ref) {
  final _storage = TodoStorage();
  return TodoModel(_storage);
});

final memberModelProvider = Provider<MemberModel>((ref) {
  final _storage = MemberStorage();
  return MemberModel(_storage);
});

final todoViewModelProvider = StateNotifierProvider<TodoViewModel, TodoViewState>((ref) {
  return TodoViewModel(ref.watch(todoModelProvider));
});

final addTodoViewModelProvider = StateNotifierProvider<AddTodoViewModel, AddTodoViewState>((ref) {
  return AddTodoViewModel(ref.watch(todoModelProvider), ref.watch(memberModelProvider));
});

final editTodoViewModelProvider = StateNotifierProvider.family<EditTodoViewModel, EditTodoViewState, Todo>((ref, todo) {
  return EditTodoViewModel(ref.watch(todoModelProvider), ref.watch(memberModelProvider), todo);
});

final memberListViewModelProvider = StateNotifierProvider<MemberListViewModel, MemberListViewState>((ref) {
  return MemberListViewModel(ref.watch(memberModelProvider));
});