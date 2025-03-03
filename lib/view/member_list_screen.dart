import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sample_todo_app/providers/app_providers.dart';
import 'package:sample_todo_app/model/member.dart';

class MemberListScreen extends ConsumerWidget {
  const MemberListScreen({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final viewState = ref.watch(memberListViewModelProvider);
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
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final member = viewState.members[index];
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
                childCount: viewState.members.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
