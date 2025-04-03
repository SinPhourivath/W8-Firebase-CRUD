import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:week8/data/dto/task_dto.dart';
import 'package:week8/model/task.dart';
import 'package:week8/data/repository/task_repository.dart';

import 'package:http/http.dart' as http;

class FirebaseTaskRepository implements TaskRepository {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  static const String tasksCollection = "tasks";
  static final String alltasksUrl = '$baseUrl/$tasksCollection.json';

  @override
  Future<Task> addTask({
    required String name,
    required String description,
  }) async {
    Uri uri = Uri.parse(alltasksUrl);

    // Create a new data
    final newTaskData = {'name': name, 'description': description};
    final http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newTaskData),
    );

    // Handle errors
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to add user');
    }

    // Firebase returns the new ID in 'name'
    final newId = json.decode(response.body)['name'];

    // Return created task
    return Task(id: newId, name: name, description: description);
  }

  @override
  Future<List<Task>> getTasks() async {
    Uri uri = Uri.parse(alltasksUrl);

    final response = await http.get(uri);

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to get tasks');
    }

    final Map<String, dynamic>? data = json.decode(response.body);

    if (data == null) return [];

    return data.entries.map((e) => TaskDto.fromJson(e.key, e.value)).toList();
  }

  @override
  Future<void> updateTask({
    required String taskId,
    required String name,
    required String description,
  }) async {
    Uri uri = Uri.parse("$baseUrl/$tasksCollection/$taskId.json");

    final updatedTaskData = {'name': name, 'description': description};

    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedTaskData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  @override
  Future<void> deleteTask({required String taskId}) async {
    Uri uri = Uri.parse("$baseUrl/$tasksCollection/$taskId.json");

    final response = await http.delete(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}
