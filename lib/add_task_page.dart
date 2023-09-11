import 'package:flutter/cupertino.dart';

class AddTaskPage extends StatelessWidget {
  final TextEditingController taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Add Task'),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoTextField(
              controller: taskController,
              placeholder: 'What are you going to do?',
            ),
            SizedBox(height: 20),
            CupertinoButton.filled(
              child: Text('Add'),
              onPressed: () {
                String taskName = taskController.text.trim();
                if (taskName.isNotEmpty) {
                  // TODO: Add task to tasks list
                  print('New Task: $taskName');
                } else {
                  // TODO: Handle empty task
                  print('Empty task');
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
