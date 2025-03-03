import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sample_todo_app/providers/app_providers.dart';
import 'package:sample_todo_app/view/member_select_filed.dart';

class AddTodoDialog extends ConsumerWidget {
  const AddTodoDialog({super.key});

  static Future<void> show(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => const AddTodoDialog(),
    );
  }

  Future<void> _showDatePicker(BuildContext context, WidgetRef ref) async {
    final viewState = ref.watch(addTodoViewModelProvider);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: viewState.deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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

          ref.read(addTodoViewModelProvider.notifier).updateDeadline(pickedDateTime);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _viewState = ref.watch(addTodoViewModelProvider);

    return Dialog(
      child: Padding(
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
              onChanged: ref.read(addTodoViewModelProvider.notifier).updateTitle,
            ),
            SizedBox(height: 16),
            MemberSelectField(
              label: 'Assignee',
              members: _viewState.availableMembers,
              selectedMember: _viewState.assignee,
              onChanged: ref.read(addTodoViewModelProvider.notifier).updateAssignee,
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimated Hours: ${_viewState.estimatedHours}',
                  style: TextStyle(color: Colors.white),
                ),
                Slider(
                  value: _viewState.estimatedHours,
                  min: 0.5,
                  max: 8.0,
                  divisions: 15,
                  label: '${_viewState.estimatedHours}',
                  onChanged: ref.read(addTodoViewModelProvider.notifier).updateEstimatedHours,
                ),
                OutlinedButton.icon(
                  icon: Icon(Icons.calendar_today),
                  label: Text('Deadline: ${_viewState.formattedDeadline}'),
                  onPressed: () => _showDatePicker(context, ref),
                ),
                if (_viewState.errorMessage != null) ... [
                  const SizedBox(height: 8),
                  Text(
                    _viewState.errorMessage!,
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
                onPressed: ref.read(addTodoViewModelProvider.notifier).isValid 
                  ? () {
                    if (ref.read(addTodoViewModelProvider.notifier).save()) {
                      Navigator.of(context).pop();
                    }
                  }
                  : null,
                child: Text('Add Todo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}