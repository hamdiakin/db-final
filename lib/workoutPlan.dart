import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sumoapp/databaseHelper.dart';
import 'login.dart';

// ignore: camel_case_types
class workoutPlan extends StatefulWidget {
  final int userID;
  // ignore: non_constant_identifier_names
  final String UserName;
  const workoutPlan(this.userID, this.UserName);
  @override
  _workoutPlan createState() => _workoutPlan();
}

// ignore: camel_case_types
class _workoutPlan extends State<workoutPlan> {
  DatabaseHelper db = DatabaseHelper.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late List<Map<dynamic, dynamic>> list;

  @override
  void initState() {
    super.initState();

  }

  String value = 'flutter';
  int id = id_variable.user_Id;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: SizedBox(
            height: 80,
            width: 80,
            child: Image.asset("asset/DynaBeatLogo.png"),
          ),
          backgroundColor: Color(0xFF580400),
          centerTitle: true,
          title: Text(
            'Your Workout Plan',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: FutureBuilder<List>(
          future: db.getWorkoutDetails(widget.userID),
          initialData: [],
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: (snapshot.data!.length),
                    itemBuilder: (_, int position) {
                      return Dismissible(
                        key: ValueKey(position),
                        child: ListTile(
                          title: Text(snapshot.data![(position)].row[0]),
                          subtitle: Text(""),
                        ),
                        onDismissed: (direction) {
                          setState(() async {
                            await db.DeleteItem(
                                snapshot.data![(position)].row[1]);
                            snapshot.data!.removeAt(position);
                          });
                        },
                      );
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
        endDrawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Color(
                0xFF402929), //This will change the drawer background to blue.
            //other styles
          ),
          child: Drawer(
            elevation: 10.0,
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(color: Color(0xFF4B0F0F)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage("asset/user.jpg"),radius: 40.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.UserName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 25.0),
                          ),
                          SizedBox(height: 10.0),
                        ],
                      )
                    ],
                  ),
                ),

                //Here you place your menu items
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home Page', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // Here you can give your route to navigate
                  },
                ),
                Divider(height: 3.0),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // Here you can give your route to navigate
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // Here you can give your route to navigate
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete_forever),
                  title: Text('Delete Account', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // ignore: deprecated_member_use
                    _scaffoldKey.currentState!.showSnackBar(SnackBar(
                      content: Text('Are you sure to delete account?'),
                      duration: Duration(seconds: 10),
                      behavior: SnackBarBehavior.floating,
                      action: SnackBarAction(
                        label: 'Yes',
                        onPressed: () {
                          print(widget.userID);
                          db.DeleteAccount(widget.userID);
                          Navigator.pop(context);
                        },
                      ),
                    ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
