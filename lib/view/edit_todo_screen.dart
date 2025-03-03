import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sample_todo_app/providers/app_providers.dart';
import 'package:sample_todo_app/model_provider.dart';
import 'package:sample_todo_app/providers/app_providers.dart';
import 'package:sample_todo_app/view/member_select_filed.dart';
import 'package:sample_todo_app/view_model/edit_todo_view_model.dart';
import 'package:sample_todo_app/model/todo.dart';

class EditTodoScreen extends ConsumerStatefulWidget {
  const EditTodoScreen({super.key, required this.todo});

  final Todo todo;

  static Route<void> route(Todo todo) {
    return MaterialPageRoute(
      builder: (context) => EditTodoScreen(todo: todo),
    );
  }

  @override
  EditTodoScreenState createState() => EditTodoScreenState();
}

class EditTodoScreenState extends ConsumerState<EditTodoScreen> {
  late final TextEditingController _titleController;
  late Todo _todo;

  @override
  void initState() {
    super.initState();
    _todo = widget.todo;
    final viewState = ref.watch(editTodoViewModelProvider(_todo));
    final viewModel = ref.read(editTodoViewModelProvider(_todo).notifier);
    _titleController = TextEditingController(text: viewState.title);
    _titleController.addListener(() {
      viewModel.updateTitle(_titleController.text);
    });
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final viewState = ref.watch(editTodoViewModelProvider(_todo));
    final viewModel = ref.read(editTodoViewModelProvider(_todo).notifier);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: viewState.deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != null) {
      if (context.mounted) {
        final pickedTime = await showTimePicker(
          context: context, 
          initialTime: TimeOfDay.fromDateTime(viewState.deadline),
        );

        if (pickedTime != null) {
          final pickedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          viewModel.updateDeadline(pickedDateTime);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewState = ref.watch(editTodoViewModelProvider(_todo));
    final viewModel = ref.read(editTodoViewModelProvider(_todo).notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Todo',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: viewModel.isValid 
              ? () {
                if (viewModel.save()) {
                  Navigator.of(context).pop();
                }
              }
              : null,
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _titleController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Title',
              labelStyle: TextStyle(color: Colors.grey[400]),
              hintStyle: TextStyle(color: Colors.grey[400]),
            ),
          ),
          SizedBox(height: 16),
          MemberSelectField(
            label: 'Assignee',
            members: viewState.availableMembers, 
            selectedMember: viewState.assignee, 
            onChanged: viewModel.updateAssignee
          ),
          SizedBox(height: 24),
          Text(
            'Estimated Hours: ${viewState.estimatedHours}',
            style: TextStyle(color: Colors.grey[400]),
          ),
          Slider(
            value: viewState.estimatedHours,
            min: 0.5,
            max: 8,
            divisions: 15,
            label: viewState.estimatedHours.toString(),
            onChanged: viewModel.updateEstimatedHours,
          ),
          SizedBox(height: 24),
          OutlinedButton.icon(
            icon: Icon(Icons.calendar_today),
            label: Text('Deadline: ${viewState.formattedDeadline}'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => _showDatePicker(context),
          ),
          if (viewState.errorMessage != null) ... [
            const SizedBox(height: 8),
            Text(
              viewState.errorMessage!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
