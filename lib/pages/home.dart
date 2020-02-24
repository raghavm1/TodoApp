import 'package:flutter/material.dart';
import 'package:note_app/config.dart';
import 'package:note_app/pages/alarm.dart';
import 'package:note_app/pages/history.dart';
import 'package:note_app/pages/todo.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

// func() async {
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   pref.getStringList('todoitems');
// }

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int selectedIndex;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        // DefaultTabController(
        //     initialIndex: selectedIndex,
        //     length: 3,
        Scaffold(
      appBar: AppBar(
        title: Text(APP_TITLE),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.notifications)),
            Tab(icon: Icon(Icons.history)),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Todo'),
              onTap: () {
                setState(() {
                  _tabController.index = 0;
                  Navigator.of(context).pop();
                });
              },
            ),
            ListTile(
              title: Text('History'),
              onTap: () {
                setState(() {
                  _tabController.index = 1;
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          TodoApp(),
          //check this one after everything is fine

          DoneList()
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     print("1234");
      //   }, // pressing this button now opens the new screen
      //   tooltip: 'Add task',
      // ),
    );
  }
}
