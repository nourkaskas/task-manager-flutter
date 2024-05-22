import 'package:flutter/material.dart';
import 'package:task_manager_app/widgets/task_list.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: TaskList(),
    );
  }
}
