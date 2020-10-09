import 'package:flutter/material.dart';
import './model/todo.dart';

class TodoItem extends StatefulWidget {
  TodoItem(Key key, this.data, this.onTapCallback) : super(key: key);
  final Todo data;
  final void Function() onTapCallback;
  @override
  TodoState createState() => TodoState();
}

class TodoState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    var completedIcon = Icon(
      Icons.check,
      size: 20.0,
      color: Colors.black,
    );
    var imCompletedIcon = Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.black)),
        child: Icon(
          Icons.check,
          size: 15.0,
          color: Colors.white,
        ));
    return Dismissible(
      key: UniqueKey(),
      child: ListTile(
        onTap: () => setState(() {
          // this.widget.data.isCompleted = !this.widget.data.isCompleted;
          this.widget.onTapCallback();
        }),
        leading: this.widget.data.isCompleted ? completedIcon : imCompletedIcon,
        title: this.widget.data.isCompleted
            ? Text(this.widget.data.title,
                style: TextStyle(decoration: TextDecoration.lineThrough))
            : Text(
                this.widget.data.title,
              ),
      ),
      background: Container(),
      secondaryBackground: Container(
        child: Center(
          child: Text(
            'Delete',
            style: TextStyle(color: Colors.white),
          ),
        ),
        color: Colors.red,
      ),
    );
  }
}
