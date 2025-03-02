import 'package:flutter/material.dart';

import 'package:sample_todo_app/model/member.dart';

class MemberSelectField extends StatelessWidget {
  const MemberSelectField({
    super.key,
    required this.label,
    required this.members,
    required this.selectedMember,
    required this.onChanged,
  });

  final String label;
  final List<Member> members;
  final Member selectedMember;
  final ValueChanged<Member> onChanged; // Function(Member)のエイリアス

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
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      // Material 3のコンポーネントとしてDropDownMenuが提供されている。
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedMember.id,
          isDense: true,
          isExpanded: true,
          items: members.map((member) {
            return DropdownMenuItem(
              value: member.id,
              child: Row(
                children: [
                  Icon(
                    _getIconData(member.icon),
                    size: 20,
                    color: Colors.tealAccent[400],
                  ),
                  SizedBox(width: 8),
                  Text(
                    member.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          })
          .toList(),
          onChanged: (id) {
            if (id == null) return;
            final member = members.firstWhere((member) => member.id == id);
            onChanged(member);
          },
        ),
      ),
    );
  }
}