import 'dart:convert';

import 'package:contador/models/to_do.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToDoRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Todo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String todoList = sharedPreferences.getString('todoList') ?? '[]';
    final List jsonDecoded = json.decode(todoList) as List;
    return jsonDecoded.map((e) => Todo.fromJson(e)).toList();
  }

  void saveTodoList(List<Todo> todos) {
    final jsonString = json.encode(todos);
    print(jsonString);
    sharedPreferences.setString('todoList', jsonString);
  }
}
