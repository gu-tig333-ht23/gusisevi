import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'task_item.dart';
import 'add_task_page.dart';

class TaskPage extends StatelessWidget {
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
