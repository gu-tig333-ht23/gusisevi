import 'dart:convert';
import 'package:http/http.dart' as http;
import 'task_item.dart';

class TodoApi {
  final String url = "https://todoapp-api.apps.k8s.gu.se";
  final String apiKey;

  TodoApi({required this.apiKey});

  Future<List<Todo>> getTodos() async {
    final response = await http.get(Uri.parse("$url/todos?key=$apiKey"));
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      //print("Received data: ${response.body}");
      return List<Todo>.from(l.map((model) => Todo.fromJson(model)));
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<List<Todo>> addTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse("$url/todos?key=$apiKey"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(todo.toJson()),
    );
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      return List<Todo>.from(l.map((model) => Todo.fromJson(model)));
    } else {
      throw Exception('Failed to add todo');
    }
  }

  Future<void> updateTodo(Todo todo) async {
    final response = await http.put(
      Uri.parse("$url/todos/${todo.id}?key=$apiKey"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(todo.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update todo');
    }
  }

  Future<void> deleteTodo(Todo todo) async {
    final response =
        await http.delete(Uri.parse("$url/todos/${todo.id}?key=$apiKey"));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete todo');
    }
  }
}
