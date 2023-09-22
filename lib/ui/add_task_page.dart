import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  AddTaskPageState createState() => AddTaskPageState();
}

class AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController taskController = TextEditingController();
  bool canAdd = false;

  @override
  void initState() {
    super.initState();
    taskController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      canAdd = taskController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    void submitTask() {
      if (canAdd) {
        HapticFeedback.selectionClick();
        String taskName = taskController.text.trim();
        Navigator.of(context).pop(taskName);
      }
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Add Task'),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CupertinoTextField(
              controller: taskController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              placeholder: 'What are you going to do?',
              onSubmitted: (text) => submitTask(),
            ),
            SizedBox(height: 20),
            CupertinoButton.filled(
              onPressed: canAdd ? submitTask : null,
              child: Text('Add'),
            ),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    taskController.removeListener(_onTextChanged);
    taskController.dispose();
    super.dispose();
  }
}
