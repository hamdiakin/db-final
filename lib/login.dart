import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sumoapp/sign.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:smart_select/smart_select.dart';
import 'package:sumoapp/workoutPlan.dart';
import 'databaseHelper.dart';
import 'userList.dart';

// ignore: camel_case_types
class login extends StatefulWidget {
  final dbHelper = DatabaseHelper.instance;

  @override
  _loginState createState() => _loginState();
}

SharedPreferences? preferences;

// ignore: camel_case_types
class id_variable {
  // ignore: non_constant_identifier_names
  static int user_Id = 1;
}

// ignore: camel_case_types
class _loginState extends State<login> {
  int userID = -1;
  var dbHelper = DatabaseHelper.instance;

  bool rm = false;

  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance.database;
    getPref();
  }

  getPref() async {
    preferences = await SharedPreferences.getInstance();

    setState(() {
      /*Remember me process*/
      rm = preferences!.getBool("remember") ?? false;
      _mailController.text = preferences!.getString("name") ?? "";
      _passwordController.text = preferences!.getString("password") ?? "";
    });
  }

  Future<int> insertUser(DatabaseHelper db) async {
    Map<String, dynamic> row = {
      "UserFirstName": "${_sign_nameController.text}",
      "UserLastName": "${_sign_surnameController.text}",
      "UserPassword": "${_sign_passwordController.text}"
    };
    int a = await db.signUser1(row);
    return a;
  }

  final GlobalKey<ScaffoldState> _scaffoldLogin =
      new GlobalKey<ScaffoldState>();

  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _mailController = new TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController _sign_nameController = new TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController _sign_surnameController = new TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController _sign_passwordController = new TextEditingController();
  bool login = true;
  List<bool> c = [true, false];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          Image.asset(
            "asset/login.jpg",
            height: size.height,
            width: size.width,
            fit: BoxFit.cover,
          ),
          Scaffold(
            key: _scaffoldLogin,
            backgroundColor: CupertinoColors.darkBackgroundGray,
            body: SizedBox.expand(
              child: ListView(
                children: [
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Container(
                    height: size.height * 0.35,
                    child: Image.asset(
                      "asset/icon.png",
                      height: size.height * 0.02,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: card("Log in", c[0], size),
                        onTap: () {
                          setState(() {
                            c[1] = false;
                            c[0] = true;
                            login = true;
                          });
                        },
                      ),
                      GestureDetector(
                        child: card("Sign up", c[1], size),
                        onTap: () {
                          setState(() {
                            c[0] = false;
                            c[1] = true;
                            login = false;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.002,
                  ),
                  login
                      ? Column(
                          children: [
                            info("Log in", size, dbHelper),
                            Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.07,
                                ),
                                Checkbox(
                                  activeColor: Colors.redAccent,
                                  value: rm,
                                  onChanged: (newValue) {
                                    setState(() {
                                      rm = newValue!;
                                      preferences!.setBool("remember", rm);
                                      preferences!.setString(
                                          "name", _mailController.text);
                                      preferences!.setString(
                                          "password", _passwordController.text);
                                    });
                                  },
                                ),
                                Text(
                                  "Remember me",
                                  style: TextStyle(
                                      color: CupertinoColors
                                          .extraLightBackgroundGray,
                                      fontSize: 14),
                                ),
                              ],
                            )
                          ],
                        )
                      : Column(
                          children: [
                            Container(
                              width: size.width * 0.83,
                              child: TextField(
                                style: TextStyle(color: Colors.white),
                                controller: _sign_nameController,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: "Name",
                                  labelStyle: TextStyle(
                                    color: CupertinoColors
                                        .extraLightBackgroundGray,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: CupertinoColors.systemRed,
                                        width: 1.0,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: CupertinoColors.systemRed,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.04),
                            info2("Next", size, dbHelper),
                          ],
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  card(String s, bool c, Size size) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
      child: Container(
        height: size.height * 0.07,
        width: size.width * 0.18,
        child: Column(
          children: [
            Text(
              s,
              style: TextStyle(
                fontSize: 15.0,
                color: c ? Colors.redAccent : Colors.white,
              ),
            ),
            Divider(
              color: c ? Colors.redAccent : Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  info(String s, Size size, DatabaseHelper db) {
    return Column(
      children: [
        Container(
          width: size.width * 0.83,
          child: TextField(
            controller: _mailController,
            obscureText: false,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "User ID",
              labelStyle: TextStyle(
                color: CupertinoColors.extraLightBackgroundGray,
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: CupertinoColors.systemRed,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(15.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CupertinoColors.systemRed,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ),
        SizedBox(height: size.height * 0.04),
        Container(
          width: size.width * 0.83,
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Password",
              labelStyle: TextStyle(
                color: CupertinoColors.extraLightBackgroundGray,
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: CupertinoColors.destructiveRed,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(15.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CupertinoColors.systemRed,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Container(
          width: size.width * 0.83,
          height: size.height * 0.06,
          child: Center(
            child: SizedBox.expand(
              // ignore: deprecated_member_use
              child: RaisedButton(
                color: Colors.transparent.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: CupertinoColors.black)),
                child: Text(
                  s,
                  style: TextStyle(
                      color: CupertinoColors.extraLightBackgroundGray,
                      fontSize: size.width * 0.035),
                ),
                onPressed: () {
                  setState(() async {
                    id_variable.user_Id = int.parse(mailController.text);
                    int? check;
                    if ((s == "Log in") &&
                        (int.parse(_mailController.text)==1 ||int.parse(_mailController.text)==2)) {
                      check = await db.fetchAdmin(
                          int.parse(_mailController.text),
                          _passwordController.text);
                      if (check == 2) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => userList()));
                      }else{

                        final snackBar1 =
                        SnackBar(content: Text('No such a user with this info'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar1);

                      }
                    } else if ((s == "Log in") &&
                        (int.parse(_mailController.text) >= 3)) {
                      check = await db.fetchUser(
                          int.parse(_mailController.text),
                          _passwordController.text);
                      if (check == 2) {

                        var x = await db.getUser(int.parse(_mailController.text));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => workoutPlan(
                                int.parse(_mailController.text), x)));
                      }else{
                        final snackBar2 =
                        SnackBar(content: Text('No such a user with this info'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                      }
                    }
                    if (check == 0) {
                      check = await db.fetchUser(
                          int.parse(_mailController.text),
                          _passwordController.text);
                    }
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ignore: unnecessary_getters_setters
  TextEditingController get mailController => _mailController;

  // ignore: unnecessary_getters_setters
  set mailController(TextEditingController value) {
    _mailController = value;
  }

  info2(String s, Size size, DatabaseHelper db) {
    return Column(
      children: [
        Container(
          width: size.width * 0.83,
          child: TextField(
            controller: _sign_surnameController,
            obscureText: false,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Surname",
              labelStyle: TextStyle(
                color: CupertinoColors.extraLightBackgroundGray,
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: CupertinoColors.systemRed,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(15.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CupertinoColors.systemRed,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ),
        SizedBox(height: size.height * 0.04),
        Container(
          width: size.width * 0.83,
          child: TextField(
            controller: _sign_passwordController,
            obscureText: true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Password",
              labelStyle: TextStyle(
                color: CupertinoColors.extraLightBackgroundGray,
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: CupertinoColors.destructiveRed,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(15.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CupertinoColors.systemRed,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Container(
          width: size.width * 0.83,
          height: size.height * 0.06,
          child: Center(
            child: SizedBox.expand(
              // ignore: deprecated_member_use
              child: RaisedButton(
                color: Colors.transparent.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: CupertinoColors.black)),
                child: Text(
                  s,
                  style: TextStyle(
                      color: CupertinoColors.extraLightBackgroundGray,
                      fontSize: size.width * 0.035),
                ),
                onPressed: () async {
                  if(_sign_passwordController.text=="" || _sign_surnameController.text=="" || _sign_nameController.text==""){
                    final snackBar =
                    SnackBar(content: Text('Please fill the whole areas'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }else{
                    int u = await insertUser(db);
                    final snackBar =
                    SnackBar(content: Text('Your User ID is $u'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    setState(() async {
                      if (s == "Next") {
                        var list2 = await db.getCenter();
                        List<S2Choice<String>> options1 = [];
                        for (var element in list2) {
                          options1.add(S2Choice<String>(
                              value: '${element['CenterID']}',
                              title: '${element['CenterName']}'));
                        }

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => sign(u, options1,_sign_nameController.text)));
                      }
                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                    });
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
