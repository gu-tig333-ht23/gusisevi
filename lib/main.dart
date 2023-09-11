import 'package:flutter/cupertino.dart';
import 'task_page.dart';

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
      home: TaskPage(),
    );
  }
}
