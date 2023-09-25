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
    BuildContext context,
    String currentTitle,
  ) async {
    return await showCupertinoDialog<String>(
      context: context,
      builder: (context) => _EditTaskDialog(currentTitle: currentTitle),
    );
  }
}

class _EditTaskDialog extends StatefulWidget {
  final String currentTitle;

  _EditTaskDialog({required this.currentTitle});

  @override
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<_EditTaskDialog> {
  late TextEditingController _controller;
  bool _isSaveEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentTitle);
    _controller.addListener(() {
      setState(() {
        _isSaveEnabled = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('Edit Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
            child: CupertinoTextField(
              controller: _controller,
              style: TextStyle(fontSize: 16),
              autofocus: true,
              minLines: 1,
              maxLines: 5,
              clearButtonMode: OverlayVisibilityMode.editing,
              textAlignVertical: TextAlignVertical.top,
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              textInputAction: TextInputAction.done,
              onSubmitted: (text) {
                if (_isSaveEnabled) {
                  Navigator.of(context).pop(_controller.text.trim());
                }
              },
            ),
          ),
          if (!_isSaveEnabled)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Task title cannot be empty.',
                style: TextStyle(
                  color: CupertinoColors.systemRed,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        CupertinoDialogAction(
          onPressed: _isSaveEnabled
              ? () {
                  Navigator.of(context).pop(_controller.text.trim());
                }
              : null,
          child: Text(
            'Save',
            style: TextStyle(
              color: _isSaveEnabled ? null : CupertinoColors.systemGrey,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
