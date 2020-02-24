import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(child: new TodoList());
  }
}

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<String> _doneItems = [];
  List<String> _todoItems;

  SharedPreferences prefs;
  void initPrefs() async {
    // _loaded = false;
    prefs = await SharedPreferences.getInstance();
    _todoItems = prefs.getStringList('todoItems');
    _doneItems = prefs.getStringList('doneItems');
    if (_doneItems == null) {
      _doneItems = [];
    }
    // _loaded = true;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initPrefs();

    print('hello');
  }
  //   void setList() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _todoItems = prefs.getStringList('todoItems');
  //   if (prefs == null) {
  //     _todoItems = null;
  //   }
  // }

  // This will be called each time the + button is pressed
  void addTodoItem(String task) {
    // Only add the task if the user actually entered something
    if (task.length > 0) {
      setState(() => _todoItems.add(task));
      prefs.setStringList('todoItems', _todoItems);
      initPrefs();
    }
  }

  // Build the whole list of todo items
  Widget _buildTodoList() {
    if (_todoItems == null) _todoItems = [];
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index], index);
        }
      },
    );
  }

  // Build a single todo item

  Widget _buildTodoItem(String todoText, int index) {
    return new ListTile(
        title: new Text(todoText), onTap: () => _promptRemoveTodoItem(index));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _buildTodoList(),
      floatingActionButton: new FloatingActionButton(
          onPressed:
              pushAddTodoScreen, // pressing this button now opens the new screen
          tooltip: 'Add task',
          child: new Icon(Icons.add)),
    );
  }

  void pushAddTodoScreen() {
    // Push this page onto the stack
    Navigator.of(context).push(
        // MaterialPageRoute will automatically animate the screen entry, as well
        // as adding a back button to close it
        new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(title: new Text('Add a new task')),
          body: new TextField(
            autofocus: true,
            onSubmitted: (val) {
              addTodoItem(val);
              Navigator.pop(context); // Close the add todo screen
            },
            decoration: new InputDecoration(
                hintText: 'Enter something to do...',
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }

  void _removeTodoItem(int index) {
    _doneItems.add(_todoItems[index]);
    setState(() => _todoItems.removeAt(index));
    prefs.setStringList('todoItems', _todoItems);
    // List allDoneItems= prefs.getStringList('allDoneItems');
    // if(allDoneItems==null)

    prefs.setStringList('doneItems', _doneItems);
    print(_doneItems);
  }

  void _promptRemoveTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('Mark "${_todoItems[index]}" as done?'),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('CANCEL'),
                    onPressed: () => Navigator.of(context).pop()),
                new FlatButton(
                    child: new Text('MARK AS DONE'),
                    onPressed: () {
                      _removeTodoItem(index);
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }
}
