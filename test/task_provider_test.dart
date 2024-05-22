import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:http/http.dart' as http;


@GenerateMocks([http.Client])
import 'task_provider_test.mocks.dart';

void main() {
  late TaskProvider taskProvider;
  late MockClient mockClient;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockClient = MockClient();
    taskProvider = TaskProvider();
    taskProvider.setClient(mockClient);
  });

  group('TaskProvider CRUD operations', () {
    test('Fetch tasks successfully', () async {
      when(mockClient.get(Uri.parse('https://dummyjson.com/todos?limit=10&skip=0')))
          .thenAnswer((_) async => http.Response(
          json.encode({
            'todos': [
              {'id': 1, 'todo': 'Test task', 'completed': false, 'userId': 1}
            ]
          }), 200));

      await taskProvider.fetchTasks(1);

      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks[0]['title'], 'Test task');
    });

    test('Add task successfully', () async {
      when(mockClient.post(
        Uri.parse('https://dummyjson.com/todos/add'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
          json.encode({
            'id': 2,
            'todo': 'New task',
            'completed': false,
            'userId': 1
          }), 200));

      await taskProvider.addTask('New task', 1);

      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks[0]['title'], 'New task');
    });

    test('Update task successfully', () async {
      taskProvider.setTasksForTest([
        {'id': 1, 'title': 'Old task', 'completed': false, 'userId': 1}
      ]);
      when(mockClient.put(
        Uri.parse('https://dummyjson.com/todos/1'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
          json.encode({
            'id': 1,
            'todo': 'Updated task',
            'completed': false
          }), 200));

      await taskProvider.updateTask(1, 'Updated task');

      expect(taskProvider.tasks[0]['title'], 'Updated task');
    });

    test('Delete task successfully', () async {
      taskProvider.setTasksForTest([
        {'id': 1, 'title': 'Test task', 'completed': false, 'userId': 1}
      ]);
      when(mockClient.delete(
        Uri.parse('https://dummyjson.com/todos/1'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('', 200));

      await taskProvider.deleteTask(1);

      expect(taskProvider.tasks.isEmpty, true);
    });
  });
}
