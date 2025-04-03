import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/task.dart';
import '../provider/task_provider.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key, this.task});

  final Task? task;

  @override
  State<TaskForm> createState() {
    return _TaskFormState();
  }
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();

  late String _enteredName;
  late String _enteredDescription;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _enteredName = widget.task!.name;
      _enteredDescription = widget.task!.description;
    } else {
      _enteredName = '';
      _enteredDescription = '';
    }
  }

  void _saveItem() {
    bool isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();

      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      if (widget.task == null) {
        taskProvider.addTask(_enteredName, _enteredDescription);
      } else {
        taskProvider.updateTask(
          widget.task!.id,
          _enteredName,
          _enteredDescription,
        );
      }

      Navigator.of(context).pop();
    }
  }

  String? validateName(String? value) {
    if (value == null ||
        value.isEmpty ||
        value.trim().length <= 1 ||
        value.trim().length > 50) {
      return 'Must be between 1 and 50 characters.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.task != null;

    final String fromTitle = isEdit ? "Edit Task" : "Add Task";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(fromTitle, style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: _enteredName,
                maxLength: 50,
                decoration: const InputDecoration(label: Text('Name')),
                validator: validateName,
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(label: Text('Description')),
                initialValue: _enteredDescription.toString(),
                onSaved: (value) {
                  _enteredDescription = value!;
                },
              ),
              const Expanded(child: SizedBox(height: 12)),
              ElevatedButton(
                onPressed: _saveItem,
                child: Text(fromTitle),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
