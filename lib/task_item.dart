import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class TaskItem extends StatelessWidget {
  final String task;

  TaskItem({
    super.key,
    required this.task,
    // TO DO: isCompleted state
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Row(
        children: [
          Expanded(
            child: Text(task, style: TextStyle(fontSize: 20)),
          ),
          CupertinoButton(
            onPressed: () {
              print("Completed button pressed");
              // TO DO: Implement completed state
              HapticFeedback.selectionClick();
            },
            child:
                Icon(CupertinoIcons.circle, color: CupertinoColors.systemGrey),
          ),
          SizedBox(width: 10),
          CupertinoButton(
            onPressed: () {
              print("Delete button pressed");
              // TO DO: Implement delete
            },
            child: Icon(CupertinoIcons.delete,
                color: CupertinoColors.destructiveRed),
          ),
        ],
      ),
    );
  }
}
