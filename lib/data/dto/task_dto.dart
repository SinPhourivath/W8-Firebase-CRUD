import '../../model/task.dart';

class TaskDto {
  static Map<String, dynamic> toJson(Task model) {
    return {'name': model.name, 'description': model.description};
  }

  static Task fromJson(String id, Map<String, dynamic> json) {
    return Task(id: id, name: json['name'], description: json['description']);
  }
}
