import 'package:week8/model/task.dart';

abstract class TaskRepository {
  Future<Task> addTask({required String name, required String description});

  Future<List<Task>> getTasks();

  Future<void> deleteTask({required String taskId});

  Future<void> updateTask({required String taskId, required String name, required String description});
}
