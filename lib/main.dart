import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:vincent_to_do/utils/todo_provider.dart';
import 'utils/todo_api.dart';
import 'ui/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          TodoProvider(TodoApi(apiKey: '2a0dc0d2-9f0b-4ac8-9eae-54b9720a9afc')),
      child: CupertinoApp(
        title: 'Vincent Todo',
        theme: CupertinoThemeData(
          primaryColor: CupertinoColors.systemRed,
        ),
        home: HomePage(),
      ),
    );
  }
}
