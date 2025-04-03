import 'package:flutter/material.dart';
import 'package:week8/model/task.dart';

import '../../data/repository/task_repository.dart';
import 'async_value.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository _repository;
  AsyncValue<List<Task>>? tasksState;

  TaskProvider(this._repository) {
    fetchTasks();
  }

  bool get isLoading =>
      tasksState != null && tasksState!.state == AsyncValueState.loading;
  bool get hasData =>
      tasksState != null && tasksState!.state == AsyncValueState.success;

  void fetchTasks() async {
    try {
      tasksState = AsyncValue.loading();
      notifyListeners();

      tasksState = AsyncValue.success(await _repository.getTasks());
    } catch (error) {
      tasksState = AsyncValue.error(error);
    }

    notifyListeners();
  }

  void addTask(String name, String description) async {
    await _repository.addTask(name: name, description: description);

    fetchTasks();
  }

  void deleteTask(String taskId) async {
    await _repository.deleteTask(taskId: taskId);
    fetchTasks();
  }

  void updateTask(String taskId, String name, String description) async {
    await _repository.updateTask(
      taskId: taskId,
      name: name,
      description: description,
    );
    fetchTasks();
  }
}
