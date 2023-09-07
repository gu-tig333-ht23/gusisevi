import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Vincent To Do',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemRed,
      ),
      home: MyHomePage(),
    );
  }
}

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

class MyHomePage extends StatelessWidget {
  final List<String> tasks = [
    'Write a book',
    'Do homework',
    'Tidy room',
    'Watch TV',
    'Nap',
    'Shop groceries',
    'Have fun',
    'Meditate',
    // TO DO: Implement proper, flexible data structure for this
  ];

  @override
  Widget build(BuildContext context) {
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
                    print("Menu Button Pressed");
                    _showMenu(context);
                  },
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return TaskItem(
                      task: tasks[index],
                    );
                  },
                  childCount: tasks.length,
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
              onPressed: () {
                print("Add Task Button Pressed");
                HapticFeedback.selectionClick();
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => AddTaskPage(),
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _showMenu(BuildContext context) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: Text('Show'),
      actions: [
        CupertinoActionSheetAction(
          child: Text('All'),
          onPressed: () {
            // TO DO: Handle "All" action here
            Navigator.pop(context);
          },
        ),
        CupertinoActionSheetAction(
          child: Text('Done'),
          onPressed: () {
            // TO DO: Handle "Done" action here
            Navigator.pop(context);
          },
        ),
        CupertinoActionSheetAction(
          child: Text('Undone'),
          onPressed: () {
            // TO DO: Handle "Undone" action here
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
