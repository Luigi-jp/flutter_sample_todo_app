import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class AddTodoViewModel extends StateNotifier<AddTodoViewState> {
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
    state = state.copyWith(title: title);
  }

  void updateAssignee(Member member) {
    state = state.copyWith(assignee: member);
  }

  void updateEstimatedHours(double hours) {
    state = state.copyWith(estimatedHours: hours);
  }

  void updateDeadline(DateTime deadline) {
    state = state.copyWith(deadline: deadline);
  }

  bool save() {
    if (!isValid) return false;

    try {
      _todoModel.addTodo(
        title: state.title,
        assignee: state.assignee, 
        estimatedHours: state.estimatedHours,
        deadline: state.deadline,
      );
      return true;
    } on DeadlineRestrictionException catch (e) {
      state = state.copyWith(errorMessage: e.message);
      return false;
    }
  }

  bool get isValid => state.title.trim().isNotEmpty;
}