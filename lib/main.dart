import 'package:flutter/material.dart';
import 'package:week8/provider_scope.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'ui/screens/task_manager.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: TaskManager());
  }
}
