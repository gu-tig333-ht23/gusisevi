import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// TO DO: class Task will be replaced with API. This is a temporary solution.
class Task {
  final String name;
  bool isCompleted;

  Task({required this.name, this.isCompleted = false});
}

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete;

  TaskItem({
    Key? key,
    required this.task,
    required this.onDelete,
    required this.onToggleComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: Row(
        children: [
          _buildTaskText(),
          _buildToggleCompleteButton(context),
          SizedBox(width: 10),
          _buildDeleteButton(),
        ],
      ),
    );
  }

  Widget _buildTaskText() {
    return Expanded(
      child: Text(
        task.name,
        style: TextStyle(
          fontSize: 20,
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          color: task.isCompleted ? CupertinoColors.systemGrey : null,
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
        task.isCompleted
            ? CupertinoIcons.checkmark_circle_fill
            : CupertinoIcons.circle,
        color: task.isCompleted
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
}
