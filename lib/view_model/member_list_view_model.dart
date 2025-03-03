import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sample_todo_app/model/member.dart';
import 'package:sample_todo_app/model/member_model.dart';

class MemberListViewState {
  MemberListViewState({
    required this.members,
  });

  final List<Member> members;
}

class MemberListViewModel extends StateNotifier<MemberListViewState> {
  MemberListViewModel(this._model)
    : super(MemberListViewState(members: [])) {
      _model.memberStream.listen((members) {
        state = MemberListViewState(members: members);
      });

      _model.getAllMembers();
    }

  final MemberModel _model;
}