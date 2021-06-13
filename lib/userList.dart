import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:smart_select/smart_select.dart';
import 'package:sumoapp/databaseHelper.dart';

// ignore: camel_case_types
class userList extends StatefulWidget {

  @override
  _userList createState() => _userList();
}

// ignore: camel_case_types
class _userList extends State<userList> {
  DatabaseHelper db= DatabaseHelper.instance;
  
  late List<Map<dynamic,dynamic>>list;
  @override
  void initState() {
    super.initState();

  }

  String value = 'flutter';
  // ignore: non_constant_identifier_names
  int user_id = 1;
  // ignore: non_constant_identifier_names
  int detail_id=1;

  List<S2Choice<String>> options =[
    S2Choice<String>(value: '1', title: 'Push Up'),
    S2Choice<String>(value: '2', title: 'Pull Up'),
    S2Choice<String>(value: '3', title: 'Cardio'),
  ];


  @override
  Widget build(BuildContext context) {
    // List<String> work_list;
    //
    // db.getWorkoutNames()


    //
    // for( var i = 0 ; i < work_list.length; i++ ) {
    //   options.add(S2Choice<String>(value: i.toString(), title: work_list[i]));
    // }


    Future<int> insertWorkout(DatabaseHelper db) async {
      Map<String, dynamic> row = {
        "UserID": "$user_id",
        "WorkoutDetailsID": "$detail_id",
      };
      int a = await db.workoutAdd(row);
      return a;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: SizedBox(
            height: 80,
            width: 80,
            child: Image.asset("asset/DynaBeatLogo.png"),
          ),
          backgroundColor: Color(0xFF580400),
          centerTitle: true,
          title: Text(
            'User List',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: FutureBuilder<List>(
          future: db.getUserInfo(),
          initialData: [],
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
              itemCount: snapshot.data!.length-2,
              itemBuilder: (_, int position) {
                //get your item data here ...
                return Card(
                  child: SmartSelect<String>.single(
                    placeholder: "Add workout",
                    modalTitle: "Workout Plans",
                    value: value,
                    choiceItems: options,
                    onChange: (state) => setState(() { value = state.value;
                        user_id = snapshot.data![position+2].row[0];
                        detail_id = int.parse(value);
                        insertWorkout(db);
                    }),
                    tileBuilder: (context, state){
                      return S2Tile(
                        title: Text(snapshot.data![position+2].row[1]+" "+snapshot.data![position+2].row[2],style: TextStyle(color: Colors.black),),
                        onTap: state.showModal,
                        value: state.valueDisplay,
                      );
                    },
                  ),
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
                        backgroundImage: AssetImage(
                            'asset/user.jpg'),
                        radius: 40.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Admin',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
