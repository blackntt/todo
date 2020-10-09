import 'package:flutter/material.dart';
import './todo.dart';
import './model/todo.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos;
  List<Todo> completedToDos;
  final myController = TextEditingController();

  @override
  void initState() {
    this.todos = [];
    this.completedToDos = [];
    super.initState();
    Todo.getTodos().then((todos) {
      setState(() {
        this.todos = todos;
      });
    });
    Todo.getCompletedTodos().then((completedTodos) {
      setState(() {
        this.completedToDos = completedTodos;
      });
    });
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  addToDo(String title) {
    var todo = Todo(title, false);
    todo.insert().then((newTodo) {
      if (newTodo != null) {
        setState(() {
          todos.add(newTodo);
        });
      }
    });
  }

  void showAddPopUp() {
    var newTodoBox = new TextField(
      controller: myController,
      decoration: InputDecoration(
          border: InputBorder.none, hintText: 'Enter title of todos'),
    );
    var addBtn = new FlatButton(
        onPressed: () {
          addToDo(myController.text);
          myController.clear();
          Navigator.of(context).pop();
        },
        child: new Text('Add'));
    var closeBtn = new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: new Text('Close'));
    var newTodoDialog = AlertDialog(
      title: new Text('New Todo'),
      content: newTodoBox,
      actions: <Widget>[addBtn, closeBtn],
    );
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return newTodoDialog;
        });
  }

  List<Widget> buildTodoWidgets(List<Todo> todos, List<Todo> otherTodos) {
    var widgets = <Widget>[];
    for (var index = 0; index < todos.length; index++) {
      widgets.add(TodoItem(Key(todos[index].id), todos[index], () {
        todos[index].isCompleted = !todos[index].isCompleted;
        todos[index].update().then((changedCount) {
          if (changedCount) {
            setState(() {
              otherTodos.add(todos[index]);
              todos.removeAt(index);
            });
          } else {
            todos[index].isCompleted = !todos[index].isCompleted;
          }
        });
      }));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    var todos = buildTodoWidgets(this.todos, this.completedToDos);
    var completedList = ExpansionTile(
      title: Text(
        "Completed",
        style: TextStyle(color: Colors.black),
      ),
      initiallyExpanded: true,
      children: buildTodoWidgets(this.completedToDos, this.todos),
    );
    todos.add(completedList);
    var todosContainer = ListView(
      children: todos,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: todosContainer,
      floatingActionButton: FloatingActionButton(
        onPressed: showAddPopUp,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
