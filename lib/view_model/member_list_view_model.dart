import 'package:flutter/foundation.dart';

import 'package:sample_todo_app/model/member.dart';
import 'package:sample_todo_app/model/member_model.dart';
class MemberListViewState {
  MemberListViewState({
    required this.members,
  });

  final List<Member> members;
}

class MemberListViewModel extends ValueNotifier<MemberListViewState> {
  MemberListViewModel(this._model)
    : super(MemberListViewState(members: [])) {
      _model.memberStream.listen((members) {
        value = MemberListViewState(members: members);
      });

      _model.getAllMembers();
    }

  final MemberModel _model;
}