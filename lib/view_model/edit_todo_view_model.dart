import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sample_todo_app/model/member.dart';
import 'package:sample_todo_app/model/member_model.dart';
import 'package:sample_todo_app/model/todo.dart';

class EditTodoViewState {
  EditTodoViewState({
    required this.title,
    required this.estimatedHours,
    required this.deadline,
    required this.assignee,
    required this.availableMembers,
    this.errorMessage,
  });

  final String title;
  final double estimatedHours;
  final DateTime deadline;
  final Member assignee;
  final List<Member> availableMembers;
  String? errorMessage;

  EditTodoViewState copyWith({
    String? title,
    double? estimatedHours,
    DateTime? deadline,
    Member? assignee,
    List<Member>? availableMembers,
    String? errorMessage,
  }) {
    return EditTodoViewState(
      title: title ?? this.title,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      deadline: deadline ?? this.deadline,
      assignee: assignee ?? this.assignee,
      availableMembers: availableMembers ?? this.availableMembers,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  String get formattedDeadline => DateFormat('yyyy/MM/dd HH:mm').format(deadline);
}

class EditTodoViewModel extends StateNotifier<EditTodoViewState> {
  EditTodoViewModel(this._todoModel, this._memberModel, Todo todo)
    : _id = todo.id,
      super(EditTodoViewState(
        title: todo.title,
        estimatedHours: todo.estimatedHours,
        deadline: todo.deadline,
        assignee: todo.assignee,
        availableMembers: _memberModel.members,
      ));

  final TodoModel _todoModel;
  final MemberModel _memberModel;
  final String _id;

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateAssignee(Member assignee) {
    state = state.copyWith(assignee: assignee);
  }

  void updateEstimatedHours(double estimatedHours) {
    state = state.copyWith(estimatedHours: estimatedHours);
  }

  void updateDeadline(DateTime deadline) {
    state = state.copyWith(deadline: deadline);
  }

  bool save() {
    if (!isValid) return false;

    try {
      _todoModel.updateTodo(
        id: _id,
        title: state.title,
        estimatedHours: state.estimatedHours,
        deadline: state.deadline,
        assignee: state.assignee,
      );
      return true;
    } on DeadlineRestrictionException catch (e) {
      state = state.copyWith(errorMessage: e.message);
      return false;
    }
  }

  bool get isValid => state.title.trim().isNotEmpty;
}