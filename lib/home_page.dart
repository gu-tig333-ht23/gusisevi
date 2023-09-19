// Till min kodgranskare:
// Jag använder en fruktansvärd datalagring för tillfället.
// Den erästts med API nästa vecka

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'task_item.dart';
import 'add_task_page.dart';

enum TaskFilter { all, completed, notCompleted }

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  TaskFilter currentFilter = TaskFilter.all;
  List<Task> _getFilteredTasks() {
    switch (currentFilter) {
      case TaskFilter.all:
        return tasks;
      case TaskFilter.completed:
        return tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.notCompleted:
        return tasks.where((task) => !task.isCompleted).toList();
      default:
        return tasks;
    }
  }

  List<Task> tasks = [
    Task(name: 'Write a book'),
    Task(name: 'Do homework'),
    Task(name: 'Tidy room'),
    Task(name: 'Watch TV'),
    Task(name: 'Nap'),
    Task(name: 'Shop groceries'),
    Task(name: 'Have fun'),
    Task(name: 'Meditate'),
    // TO DO: Will be replaced with API. This is temporary solution.
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
                    _showMenu();
                  },
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final taskItem = _getFilteredTasks()[index];
                    return Dismissible(
                      key: ValueKey(taskItem.name),
                      background: Container(
                        color: CupertinoColors.destructiveRed,
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
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
                                style: TextStyle(color: CupertinoColors.white)),
                            SizedBox(width: 10),
                            Icon(CupertinoIcons.delete,
                                color: CupertinoColors.white),
                          ],
                        ),
                      ),
                      onDismissed: (direction) {
                        final deletedTask =
                            taskItem; // TO DO: Repalce with API.

                        setState(() {
                          HapticFeedback.selectionClick();
                          tasks.remove(deletedTask); // TO DO: Replace with API.
                        });
                      },
                      child: TaskItem(
                        task: taskItem,
                        onDelete: () {
                          setState(() {
                            tasks.remove(taskItem); // TO DO: Repalce with API.
                          });
                        },
                        onToggleComplete: () {
                          setState(() {
                            tasks[index].isCompleted =
                                !tasks[index].isCompleted;
                          });
                        },
                      ),
                    );
                  },
                  childCount: _getFilteredTasks().length,
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

                String? newTask = await Navigator.of(context).push<String>(
                  CupertinoPageRoute(
                    builder: (context) => AddTaskPage(),
                  ),
                );

                print("Returned task: $newTask");
                if (newTask != null && newTask.isNotEmpty) {
                  setState(() {
                    tasks.add(Task(name: newTask));
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showMenu() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text('Filter tasks'),
        actions: [
          CupertinoActionSheetAction(
            child: Text('All'),
            onPressed: () {
              setState(() {
                currentFilter = TaskFilter.all;
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Completed'),
            onPressed: () {
              setState(() {
                currentFilter = TaskFilter.completed;
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Not completed'),
            onPressed: () {
              setState(() {
                currentFilter = TaskFilter.notCompleted;
              });
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
}
