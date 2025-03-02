import 'package:flutter/material.dart';

import 'package:sample_todo_app/model_provider.dart';
import 'package:sample_todo_app/view_model/member_list_view_model.dart';
import 'package:sample_todo_app/model/member.dart';

class MemberListScreen extends StatefulWidget {
  const MemberListScreen({super.key});

  @override
  State<MemberListScreen> createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  late final MemberListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MemberListViewModel(
      ModelProvider.memberModelOf(context),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  IconData _getIconData(IconType iconType) {
    switch (iconType) {
      case IconType.person:
        return Icons.person;
      case IconType.work:
        return Icons.work;
      case IconType.school:
        return Icons.school;
      case IconType.home:
        return Icons.home;
      case IconType.favorite:
        return Icons.favorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Team Members',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          ValueListenableBuilder<MemberListViewState>(
            valueListenable: _viewModel,
            builder: (context, state, _) {
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final member = state.members[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(
                            _getIconData(member.icon),
                            color: Colors.tealAccent[400],
                          ),
                          title: Text(
                            member.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),                    
                      );
                    },
                    childCount: state.members.length,
                  ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}