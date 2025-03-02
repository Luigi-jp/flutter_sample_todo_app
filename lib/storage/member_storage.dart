import 'package:sample_todo_app/model/member.dart';

class MemberStorage {

  final List<Member> _members = [
    Member(
      id: '1',
      name: 'John Doe',
      icon: IconType.person,
    ),
    Member(
      id: '2',
      name: 'Jane Smith',
      icon: IconType.work,
    ),
    Member(
      id: '3',
      name: 'Alice Johnson',
      icon: IconType.school,
    ),
  ];

  List<Member> fetchAll() => _members;
}