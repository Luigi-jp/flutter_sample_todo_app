import 'package:flutter/material.dart';

import 'package:sample_todo_app/model_provider.dart';
import 'package:sample_todo_app/view/add_todo_dialog.dart';
import 'package:sample_todo_app/view/edit_todo_screen.dart';
import 'package:sample_todo_app/view/member_list_screen.dart';
import 'package:sample_todo_app/view_model/todo_view_model.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late final TodoViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = TodoViewModel(
      ModelProvider.todoModelOf(context),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.people_outline,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MemberListScreen(),
                ),
              );
            },
            // マウスホバーしたりタップしたときに表示される情報（スマホだとロングタップで表示された）
            tooltip: 'Team Members',
          ),
          ValueListenableBuilder<TodoViewState>(
            valueListenable: _viewModel,
            builder: (context, state, _) {
              return IconButton(
                icon: Icon(
                  state.showCompleted ? Icons.check_circle : Icons.check_circle_outline,
                  color: Colors.tealAccent[400],
                ),
                onPressed: () {
                  _viewModel.toggleShowCompleted();
                },
                tooltip: state.showCompleted ? 'Hide completed tasks' : 'Show completed tasks',
              );
            },
          ),
        ],
      ),
      // UIKitでいうNavigationBarButtonItem
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async{
          await AddTodoDialog.show(context);
        },
      ),
      body: CustomScrollView(
        slivers: [
          ValueListenableBuilder<TodoViewState>(
            valueListenable: _viewModel,
            builder: (context, state, _) {
              final todos = state.filteredTodos;
              return todos.isEmpty 
                ? const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task,
                          size: 64,
                          color: Color(0xFF2D2D2D),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No todos yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final todo = todos[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Opacity(
                            opacity: todo.isCompleted ? 0.5 : 1.0,
                            child: ListTile(
                              leading: IconButton(
                                icon: Icon(
                                  todo.isCompleted ? Icons.check_circle :Icons.check_circle_outline,
                                  color: Colors.tealAccent[400],
                                ),
                                onPressed: () {
                                  _viewModel.toggleTodoCompletion(todo.id);
                                },
                              ),
                              title: Text(
                                todo.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Estimated: ${todo.estimatedHours}h',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  Text(
                                    'Due: ${todo.formattedDeadline}',
                                    style: TextStyle(
                                      color: todo.deadline.isBefore(DateTime.now()) ? Colors.redAccent[400] :Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.grey[400],                          
                                ),
                                onPressed: () {
                                  _viewModel.deleteTodo(todo.id);
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  EditTodoScreen.route(todo),
                                );
                              },
                            ),
                          ),
                        );
                      },
                      childCount: todos.length,
                    ),
                  ),
                );
            },
          ),
        ],
      ),
    );
  }
}