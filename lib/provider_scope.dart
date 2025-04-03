import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week8/data/repository/firebase/firebase_task_repository.dart';
import 'package:week8/data/repository/task_repository.dart';
import 'package:week8/ui/provider/task_provider.dart';

class ProviderScope extends StatelessWidget {
  const ProviderScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    TaskRepository taskRepository = FirebaseTaskRepository();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TaskProvider(taskRepository),
        ),
      ],
      child: child,
    );
  }
}
