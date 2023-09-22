// Bridges app and API.

import 'package:flutter/cupertino.dart';
import 'package:vincent_to_do/ui/home_page.dart';
import 'package:vincent_to_do/utils/task_item.dart';
import 'package:vincent_to_do/utils/todo_api.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> todos = [];
  final TodoApi api;

  TaskFilter _currentFilter = TaskFilter.all;

  TaskFilter get currentFilter => _currentFilter;

  setFilter(TaskFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  TodoProvider(this.api) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    todos = await api.getTodos();
    notifyListeners();
  }

  Future<void> addTodo(Todo todo) async {
    todos = await api.addTodo(todo);
    notifyListeners();
  }

  Future<void> updateTodo(Todo todo) async {
    await api.updateTodo(todo);
    notifyListeners();
  }

  Future<void> deleteTodo(Todo todo) async {
    await api.deleteTodo(todo);
    int index = todos.indexOf(todo);
    if (index != -1) todos.removeAt(index);
    notifyListeners();
  }

  void replaceTodo(Todo oldTodo, Todo newTodo) {
    int index = todos.indexOf(oldTodo);
    if (index != -1) {
      todos[index] = newTodo;
      notifyListeners();
      api.updateTodo(newTodo);
    }
  }
}
