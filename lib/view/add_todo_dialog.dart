import 'package:flutter/material.dart';

import 'package:sample_todo_app/model_provider.dart';
import 'package:sample_todo_app/view/member_select_filed.dart';
import 'package:sample_todo_app/view_model/add_todo_view_model.dart';

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key});

  static Future<void> show(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => const AddTodoDialog(),
    );
  }

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  late final AddTodoViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AddTodoViewModel(
      ModelProvider.todoModelOf(context),
      ModelProvider.memberModelOf(context),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _viewModel.value.deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
    return Dialog(
      child: ValueListenableBuilder<AddTodoViewState>(
        valueListenable: _viewModel,
        builder: (context, state, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add New Todo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),              
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextField(              
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.task_alt),
                    hintText: 'Enter new todo',
                  ),
                  onChanged: _viewModel.updateTitle,
                ),
                SizedBox(height: 16),
                MemberSelectField(
                  label: 'Assignee',
                  members: state.availableMembers,
                  selectedMember: state.assignee,
                  onChanged: _viewModel.updateAssignee,
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estimated Hours: ${state.estimatedHours}',
                      style: TextStyle(color: Colors.white),
                    ),
                    Slider(
                      value: state.estimatedHours,
                      min: 0.5,
                      max: 8.0,
                      divisions: 15,
                      label: '${state.estimatedHours}',
                      onChanged: _viewModel.updateEstimatedHours,
                    ),
                    OutlinedButton.icon(
                      icon: Icon(Icons.calendar_today),
                      label: Text('Deadline: ${state.formattedDeadline}'),
                      onPressed: () => _showDatePicker(context),
                    ),
                    if (state.errorMessage != null) ... [
                      const SizedBox(height: 8),
                      Text(
                        state.errorMessage!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ],              
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _viewModel.isValid 
                      ? () {
                        if (_viewModel.save()) {
                          Navigator.of(context).pop();
                        }
                      }
                      : null,
                    child: Text('Add Todo'),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}