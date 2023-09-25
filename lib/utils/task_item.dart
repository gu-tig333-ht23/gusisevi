//Each task is a task_item with Todo.

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Todo {
  final String id;
  final String title;
  bool done;

  Todo({required this.id, required this.title, this.done = false});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      done: json['done'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'done': done,
      };
}

class TaskItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete;
  final void Function(Todo) onUpdate;

  TaskItem({
    Key? key,
    required this.todo,
    required this.onDelete,
    required this.onToggleComplete,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String? updatedTitle = await showEditTaskDialog(context, todo.title);
        if (updatedTitle != null && updatedTitle.isNotEmpty) {
          Todo updatedTodo = Todo(
            id: todo.id,
            title: updatedTitle,
            done: todo.done,
          );
          onUpdate(updatedTodo);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        child: Row(
          children: [
            _buildTaskText(),
            _buildToggleCompleteButton(context),
            SizedBox(width: 10),
            _buildDeleteButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskText() {
    return Expanded(
      child: Text(
        todo.title,
        style: TextStyle(
          fontSize: 15,
          decoration: todo.done ? TextDecoration.lineThrough : null,
          color: todo.done ? CupertinoColors.systemGrey : null,
        ),
      ),
    );
  }

  Widget _buildToggleCompleteButton(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        HapticFeedback.selectionClick();
        onToggleComplete();
      },
      child: Icon(
        todo.done
            ? CupertinoIcons.checkmark_circle_fill
            : CupertinoIcons.circle,
        color: todo.done
            ? CupertinoTheme.of(context).primaryColor
            : CupertinoColors.systemGrey,
        size: 30.0,
      ),
    );
  }

  Widget _buildDeleteButton() {
    return CupertinoButton(
      onPressed: () {
        HapticFeedback.selectionClick();
        onDelete();
      },
      child: Icon(CupertinoIcons.delete, color: CupertinoColors.destructiveRed),
    );
  }

  Future<String?> showEditTaskDialog(
      BuildContext context, String currentTitle) async {
    TextEditingController controller =
        TextEditingController(text: currentTitle);
    return await showCupertinoDialog<String>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Edit Task'),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0),
            child: CupertinoTextField(
              controller: controller,
              clearButtonMode: OverlayVisibilityMode.editing,
              placeholder: 'Enter task title',
              maxLines: 2,
              textAlignVertical: TextAlignVertical.top,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
            ),
          ],
        );
      },
    );
  }
}
