import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:sample_todo_app/model/member_model.dart';
import 'package:sample_todo_app/model/todo.dart';
import 'package:sample_todo_app/model/member.dart';


class AddTodoViewState {
  AddTodoViewState({
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

  AddTodoViewState copyWith({
    String? title,
    double? estimatedHours,
    DateTime? deadline,
    Member? assignee,
    List<Member>? availableMembers,
    String? errorMessage,
  }) {
    return AddTodoViewState(
      title: title ?? this.title,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      deadline: deadline ?? this.deadline,
      assignee: assignee ?? this.assignee,
      availableMembers: availableMembers ?? this.availableMembers,
      errorMessage: errorMessage,
    );
  }

  String get formattedDeadline => DateFormat('yyyy/MM/dd HH:mm').format(deadline);
}

class AddTodoViewModel extends ValueNotifier<AddTodoViewState> {
  AddTodoViewModel(this._todoModel, this._memberModel)
    : super(AddTodoViewState(
      title: '',
      estimatedHours: 1.0,
      deadline: DateTime.now().add(Duration(days: 1)),
      assignee: _memberModel.members.first,
      availableMembers: _memberModel.members,
    ));

  final TodoModel _todoModel;
  final MemberModel _memberModel;

  void updateTitle(String title) {
    value = value.copyWith(title: title);
  }

  void updateAssignee(Member member) {
    value = value.copyWith(assignee: member);
  }

  void updateEstimatedHours(double hours) {
    value = value.copyWith(estimatedHours: hours);
  }

  void updateDeadline(DateTime deadline) {
    value = value.copyWith(deadline: deadline);
  }

  bool save() {
    if (!isValid) return false;

    try {
      _todoModel.addTodo(
        title: value.title,
        assignee: value.assignee, 
        estimatedHours: value.estimatedHours,
        deadline: value.deadline,
      );
      return true;
    } on DeadlineRestrictionException catch (e) {
      value = value.copyWith(errorMessage: e.message);
      return false;
    }
  }

  bool get isValid => value.title.trim().isNotEmpty;
}