import 'package:flutter/material.dart';

import 'package:sample_todo_app/model_provider.dart';
import 'package:sample_todo_app/view/member_select_filed.dart';
import 'package:sample_todo_app/view_model/edit_todo_view_model.dart';
import 'package:sample_todo_app/model/todo.dart';

class EditTodoScreen extends StatefulWidget {
  const EditTodoScreen({super.key, required this.todo});

  final Todo todo;

  static Route<void> route(Todo todo) {
    return MaterialPageRoute(
      builder: (context) => EditTodoScreen(todo: todo),
    );
  }

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  late final EditTodoViewModel _viewModel;
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _viewModel = EditTodoViewModel(
      ModelProvider.todoModelOf(context),
      ModelProvider.memberModelOf(context),
      widget.todo,
    );
    _titleController = TextEditingController(text: _viewModel.value.title);
    _titleController.addListener(() {
      _viewModel.updateTitle(_titleController.text);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
    _titleController.dispose();
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _viewModel.value.deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != null) {
      if (context.mounted) {
        final pickedTime = await showTimePicker(
          context: context, 
          initialTime: TimeOfDay.fromDateTime(_viewModel.value.deadline),
        );

        if (pickedTime != null) {
          final pickedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          _viewModel.updateDeadline(pickedDateTime);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<EditTodoViewState>(
      valueListenable: _viewModel,
      builder: (context, state, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Edit Todo',
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: _viewModel.isValid 
                  ? () {
                    if (_viewModel.save()) {
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
                members: state.availableMembers, 
                selectedMember: state.assignee, 
                onChanged: _viewModel.updateAssignee
              ),
              SizedBox(height: 24),
              Text(
                'Estimated Hours: ${state.estimatedHours}',
                style: TextStyle(color: Colors.grey[400]),
              ),
              Slider(
                value: state.estimatedHours,
                min: 0.5,
                max: 8,
                divisions: 15,
                label: state.estimatedHours.toString(),
                onChanged: _viewModel.updateEstimatedHours,
              ),
              SizedBox(height: 24),
              OutlinedButton.icon(
                icon: Icon(Icons.calendar_today),
                label: Text('Deadline: ${state.formattedDeadline}'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _showDatePicker(context),
              ),
              if (state.errorMessage != null) ... [
                const SizedBox(height: 8),
                Text(
                  state.errorMessage!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
