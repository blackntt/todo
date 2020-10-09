import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './todolist.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ToDoApp());
}

class ToDoApp extends StatelessWidget {
  final String username = "Toan Nguyen";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: this.username,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.black,
      ),
      home: HomePage(title: this.username),
    );
  }
}
