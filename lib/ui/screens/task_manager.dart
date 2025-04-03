import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/task.dart';
import '../provider/async_value.dart';
import '../provider/task_provider.dart';
import 'task_form.dart';

class TaskManager extends StatelessWidget {
  const TaskManager({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskProvider taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Task Manager"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => TaskForm()));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(child: _buildBody(taskProvider)),
    );
  }

  Widget _buildBody(TaskProvider taskProvider) {
    final taskState = taskProvider.tasksState;

    if (taskState == null) {
      return Text('Tap refresh to display post'); // display an empty state
    }

    switch (taskState.state) {
      case AsyncValueState.loading:
        return CircularProgressIndicator(); // display a progress

      case AsyncValueState.error:
        return Text('Error: ${taskState.error}'); // display a error

      case AsyncValueState.success:
        if (taskState.data!.isEmpty) {
          return Center(child: Text("No posts for now"));
        }

        return ListView.builder(
          itemCount: taskState.data!.length,
          itemBuilder: (ctx, index) => TaskCard(task: taskState.data![index]),
        ); // display the post
    }
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return GestureDetector(
      child: ListTile(
        title: Text(task.name),
        subtitle: Text(task.description),
        trailing: IconButton(
          onPressed: () {
            taskProvider.deleteTask(task.id);
          },
          icon: Icon(Icons.delete, color: Colors.red),
        ),
      ),
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => TaskForm(task: task)));
      },
    );
  }
}
