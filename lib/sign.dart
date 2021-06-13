import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:smart_select/smart_select.dart';
import 'package:sumoapp/databaseHelper.dart';
import 'package:sumoapp/login.dart';
import 'package:date_format/date_format.dart';

// ignore: camel_case_types
class sign extends StatefulWidget {
  final int id1;
  final List<S2Choice<String>> options1;
  // ignore: non_constant_identifier_names
  final String user_name;
  //sign({Key key, @required this.id}) : super(key: key);
  const sign(this.id1, this.options1, this.user_name);
  @override
  _signState createState() => _signState();
}

// ignore: camel_case_types
class _signState extends State<sign> {
  DatabaseHelper db = DatabaseHelper.instance;
  late List<Map<dynamic, dynamic>> list;
  @override
  void initState() {
    super.initState();
  }

  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _genderController = new TextEditingController();
  TextEditingController _dobController = new TextEditingController();
  String value = 'flutter';
  @override
  Widget build(BuildContext context) {
    int id = widget.id1;
    List<S2Choice<String>> options = widget.options1;
    Size size = MediaQuery.of(context).size;

    DateTime now = DateTime.now();
    DateTime tenYearsAgo = DateTime(now.year - 10);
    DateTime afterTime = DateTime(
      now.year,
      now.month,
      now.day + 20,
    );

    updateUser(
        DatabaseHelper db, String phone, String gender, String dob) async {
      Map<String, dynamic> row = {
        "UserPhoneNumber": "$phone",
        "CenterID": "$value",
        "UserDOB": "$dob",
        "UserGender": "$gender",
        "id": "$id"
      };
      await db.signUser2(row);
    }

    return Container(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Hello ${widget.user_name}!"),
          leading: Image.asset(
            "asset/icon.png",
          ),
          backgroundColor: CupertinoColors.systemRed,
        ),
        body: Container(
          color: CupertinoColors.darkBackgroundGray,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Please fulfill the required options",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: size.height * 0.04),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1, color: CupertinoColors.systemRed),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    width: size.width * 0.83,
                    child: DefaultTextStyle(
                      child: SmartSelect<String>.single(
                        modalTitle: "Choose the center",
                        value: value,
                        choiceItems: options,
                        onChange: (state) => setState(() {
                          value = state.value;
                        }),
                        tileBuilder: (context, state) {
                          return S2Tile(
                            title: Text(
                              "Center",
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: state.showModal,
                            value: state.valueDisplay,
                          );
                        },
                      ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  Container(
                    width: size.width * 0.83,
                    child: TextField(
                      controller: _phoneController,
                      obscureText: false,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Phone Number",
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
                      controller: _genderController,
                      obscureText: false,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Gender",
                        hintText: "Write M or W",
                        hintStyle: TextStyle(
                          color: CupertinoColors.extraLightBackgroundGray,
                        ),
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
                    child: TextFormField(
                      controller: _dobController,
                      obscureText: false,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            {
                              showDatePicker(
                                      context: context,
                                      initialDate: now,
                                      firstDate: tenYearsAgo,
                                      lastDate: afterTime)
                                  .then((date) {
                                _dobController.text =
                                    formatDate(date!, [yyyy, "-", mm, "-", dd]);
                              });
                            }
                          },
                        ),
                        labelText: "Date of Birth",
                        hintText: "YYYY:MM:DD",
                        hintStyle: TextStyle(
                            color: CupertinoColors.extraLightBackgroundGray),
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
                    height: size.height * 0.06,
                    child: SizedBox.expand(
                      child: ElevatedButton(
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                              color: CupertinoColors.extraLightBackgroundGray,
                              fontSize: size.width * 0.035),
                        ),
                        onPressed: () {
                          if(value=="flutter" || _phoneController.text=="" || _dobController.text=="" || _genderController.text==""){
                            final snackBar =
                            SnackBar(content: Text('Please fill the whole variables'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }else{
                            updateUser(db, _phoneController.text,
                                _genderController.text, _dobController.text);
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => login()));
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
