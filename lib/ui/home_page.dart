import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vincent_to_do/utils/todo_provider.dart';
import '../utils/task_item.dart';
import 'add_task_page.dart';

enum TaskFilter { all, completed, notCompleted }

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        List<Todo> filteredTodos = _getFilteredTodos(todoProvider);
        return CupertinoPageScaffold(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: <Widget>[
                  CupertinoSliverNavigationBar(
                    largeTitle: Text('Vincent To Do'),
                    trailing: CupertinoButton(
                      padding: EdgeInsets.zero,
                      color: CupertinoTheme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(25.0),
                      child: Icon(CupertinoIcons.ellipsis),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        _showMenu(context);
                      },
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: 120.0),
                    sliver: SliverList(
                      delegate: filteredTodos.isEmpty
                          ? SliverChildListDelegate(_buildEmptyState())
                          : SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final todo = filteredTodos[index];
                                return Dismissible(
                                  key: ValueKey(todo.title),
                                  background: Container(
                                    color: CupertinoColors.destructiveRed,
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Icon(CupertinoIcons.delete),
                                    ),
                                  ),
                                  secondaryBackground: Container(
                                    alignment: Alignment.centerRight,
                                    color: CupertinoColors.destructiveRed,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("Delete",
                                            style: TextStyle(
                                                color: CupertinoColors.white)),
                                        const SizedBox(width: 10),
                                        Icon(CupertinoIcons.delete,
                                            color: CupertinoColors.white),
                                      ],
                                    ),
                                  ),
                                  onDismissed: (direction) {
                                    HapticFeedback.selectionClick();
                                    todoProvider.deleteTodo(todo);
                                  },
                                  child: TaskItem(
                                    todo: todo,
                                    onDelete: () {
                                      todoProvider.deleteTodo(todo);
                                    },
                                    onToggleComplete: () {
                                      todo.done = !todo.done;
                                      todoProvider.updateTodo(todo);
                                    },
                                    onUpdate: (updatedTodo) {
                                      todoProvider.replaceTodo(
                                          todo, updatedTodo);
                                    },
                                  ),
                                );
                              },
                              childCount: filteredTodos.length,
                            ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 60,
                child: CupertinoButton.filled(
                  child: Text('Add Task'),
                  onPressed: () async {
                    HapticFeedback.selectionClick();
                    String? newTodoTitle =
                        await Navigator.of(context).push<String>(
                      CupertinoPageRoute(
                        builder: (context) => AddTaskPage(),
                      ),
                    );

                    if (newTodoTitle != null && newTodoTitle.isNotEmpty) {
                      Todo newTodo = Todo(
                        id: "", // Generated server side, leave empty
                        title: newTodoTitle,
                        done: false,
                      );
                      todoProvider.addTodo(newTodo);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildEmptyState() {
    return [
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Column(
            children: [
              Icon(CupertinoIcons.exclamationmark_circle,
                  size: 60.0, color: CupertinoColors.systemGrey),
              SizedBox(height: 10.0),
              Text(
                'No tasks available.',
                style: TextStyle(
                  fontSize: 20,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  void _showMenu(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text('Filter tasks'),
        actions: [
          CupertinoActionSheetAction(
            child: Text('All'),
            onPressed: () {
              todoProvider.setFilter(TaskFilter.all);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Completed'),
            onPressed: () {
              todoProvider.setFilter(TaskFilter.completed);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Not completed'),
            onPressed: () {
              todoProvider.setFilter(TaskFilter.notCompleted);
              Navigator.pop(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  List<Todo> _getFilteredTodos(TodoProvider todoProvider) {
    return todoProvider.todos.where((todo) {
      switch (todoProvider.currentFilter) {
        case TaskFilter.completed:
          return todo.done;
        case TaskFilter.notCompleted:
          return !todo.done;
        case TaskFilter.all:
        default:
          return true;
      }
    }).toList();
  }
}
