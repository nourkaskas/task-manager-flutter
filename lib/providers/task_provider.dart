import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TaskProvider with ChangeNotifier {
  List<Map<String, dynamic>> _tasks = [];
  String _token = '';
  http.Client _client = http.Client();

  List<Map<String, dynamic>> get tasks => _tasks;

  void setClient(http.Client client) {
    _client = client;
  }

  void setTasksForTest(List<Map<String, dynamic>> tasks) {
    _tasks = tasks;
    notifyListeners();
  }

  void setToken(String token) {
    _token = token;
    notifyListeners();
    _loadTasksFromLocal();
  }

  Future<void> _saveTasksToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('tasks', json.encode(_tasks));
  }

  Future<void> _loadTasksFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('tasks')) {
      _tasks = List<Map<String, dynamic>>.from(
        json.decode(prefs.getString('tasks')!) as List,
      );
      notifyListeners();
    }
  }

  Future<void> fetchTasks(int page) async {
    final response = await _client.get(Uri.parse('https://dummyjson.com/todos?limit=10&skip=${(page - 1) * 10}'));
    if (response.statusCode == 200) {
      List<dynamic> tasksData = json.decode(response.body)['todos'];
      _tasks = tasksData.map((task) => {
        'id': task['id'],
        'title': task['todo'],
        'completed': task['completed'],
        'userId': task['userId']
      }).toList();

      await _saveTasksToLocal();
      notifyListeners();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> addTask(String title, int userId) async {
    final response = await _client.post(
      Uri.parse('https://dummyjson.com/todos/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode({
        'todo': title,
        'completed': false,
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> newTask = json.decode(response.body);
      _tasks.add({
        'id': newTask['id'],
        'title': newTask['todo'],
        'completed': newTask['completed'],
        'userId': newTask['userId']
      });

      await _saveTasksToLocal();
      notifyListeners();
    } else {
      throw Exception('Failed to add task: ${response.body}');
    }
  }

  Future<void> updateTask(int id, String newTitle) async {
    final response = await _client.put(
      Uri.parse('https://dummyjson.com/todos/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode({
        'todo': newTitle,
        'completed': false,
      }),
    );

    if (response.statusCode == 200) {
      final index = _tasks.indexWhere((task) => task['id'] == id);
      if (index != -1) {
        _tasks[index]['title'] = newTitle;
        await _saveTasksToLocal();
        notifyListeners();
      }
    } else {
      throw Exception('Failed to update task: ${response.body}');
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await _client.delete(
      Uri.parse('https://dummyjson.com/todos/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      _tasks.removeWhere((task) => task['id'] == id);
      await _saveTasksToLocal();
      notifyListeners();
    } else {
      throw Exception('Failed to delete task');
    }
  }
}
