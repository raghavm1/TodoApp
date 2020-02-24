import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'todo.dart';

class Done extends StatelessWidget {
  Widget build(BuildContext context) {
    return new Container(child: new DoneList());
  }
}

class DoneList extends StatefulWidget {
  @override
  createState() => new DoneListState();
}

class DoneListState extends State<DoneList> {
  SharedPreferences prefs;
  List<String> _doneItems;
  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    _doneItems = prefs.getStringList('doneItems');
    print(_doneItems);
    if (_doneItems == null) {
      _doneItems = [];
    }
    print(_doneItems);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPrefs();
    print('hello');
  }

  Widget _buildDoneList() {
    if (_doneItems == null) _doneItems = [];
    return ListView.builder(itemBuilder: (context, index) {
      if (index < _doneItems.length) {
        return _buildDoneItem(_doneItems[index], index);
      }
    });
  }

  Widget _buildDoneItem(String doneText, int index) {
    return new ListTile(
        title: new Text(doneText), onTap: () => _promptRemoveDoneItem(index));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _buildDoneList();
  }

  void _removeDoneItem(int index) {
    setState(() => _doneItems.removeAt(index));
    prefs.setStringList('doneItems', _doneItems);
    print(_doneItems);
  }

  void _promptRemoveDoneItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('Remove "${_doneItems[index]}" permanently?'),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('CANCEL'),
                    onPressed: () => Navigator.of(context).pop()),
                new FlatButton(
                    child: new Text('YES'),
                    onPressed: () {
                      _removeDoneItem(index);
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }
}
