import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

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

class EditTodoViewModel extends ValueNotifier<EditTodoViewState> {
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
    value = value.copyWith(title: title);
  }

  void updateAssignee(Member assignee) {
    value = value.copyWith(assignee: assignee);
  }

  void updateEstimatedHours(double estimatedHours) {
    value = value.copyWith(estimatedHours: estimatedHours);
  }

  void updateDeadline(DateTime deadline) {
    value = value.copyWith(deadline: deadline);
  }

  bool save() {
    if (!isValid) return false;

    try {
      _todoModel.updateTodo(
        id: _id,
        title: value.title,
        estimatedHours: value.estimatedHours,
        deadline: value.deadline,
        assignee: value.assignee,
      );
      return true;
    } on DeadlineRestrictionException catch (e) {
      value = value.copyWith(errorMessage: e.message);
      return false;
    }
  }

  bool get isValid => value.title.trim().isNotEmpty;
}