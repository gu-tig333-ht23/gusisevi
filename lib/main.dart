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
          TodoProvider(TodoApi(apiKey: '9644c867-8ec1-4d5c-a4ea-2307e3943365')),
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
