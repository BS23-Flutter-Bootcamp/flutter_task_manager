import 'package:flutter/material.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Tasks"),
        centerTitle: true,
        backgroundColor: Color(0xFFBBDEFB),
      ),
      body: Center(child: Text('Home page')),
    );
  }
}
