import 'package:flutter/material.dart';
import 'login.dart';
import 'kanban.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kanban',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: KanbanPage()
    );
  }
}
