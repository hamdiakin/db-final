import 'dart:io';
import 'package:path/path.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:sqflite/sqflite.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'Movie_table';
  static final tableFavorite = 'Favorite_table';
  static final tableUpcoming = 'Upcoming_table';

  static final columnId = '_id';
  static final columnTitle = 'title';
  static final columnOverview = 'overview';
  static final columnMovieID = 'id';
  static final columnPoster = 'poster_path';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onConfigure: _onConfigure,
        onCreate: _onCreate);
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {

    await db.execute('''
          CREATE TABLE `WorkoutDetails` (
          `WorkoutDetailsID` INTEGER PRIMARY KEY,
          `WorkoutName` varchar(20),
          `WorkoutDuration` int
          )

          ''');



    await db.execute('''
          CREATE TABLE `Center` (
          `CenterID` INTEGER PRIMARY KEY,
          `CenterName` varchar(20),
          `CenterCity` varchar(20),
          `WorkoutType` varchar(20),
          `CenterPopulation` int,
          `CenterMaxLimit` int
          )

          ''');
    await db.execute('''
          CREATE TABLE `Equipment` (
          `EquipmentID` INTEGER PRIMARY KEY,
          `EquipmentPackageName` varchar(50)
          )

          ''');
    await db.execute('''
          CREATE TABLE `User` (
          `UserID` INTEGER PRIMARY KEY,
          `UserFirstName` varchar(20),
          `UserLastName` varchar(20),
          `UserPassword` varchar(20),
          `UserPhoneNumber` varchar(11),
          `UserDOB` date,
          `CenterID` int,
          `UserGender` varchar(1),
          FOREIGN key (CenterID) references center(CenterID)
          )
          ''');
    await db.execute('''
          CREATE TABLE `Trainer` (
          `TrainerID` INTEGER PRIMARY KEY,
          `TrainerFirstName` varchar(20),
          `TrainerLastName` varchar(20),
          `TrainerSalary` int,
          `TrainerGender` varchar(1),
          `CenterID` int,
          `TrainerDOB` date,
          `TrainerSpeciality` varchar(20),
          FOREIGN key (CenterID) references center(CenterID)
           )

          ''');
    await db.execute('''
          CREATE TABLE `UserPlan` (
          `TypeID` INTEGER PRIMARY KEY,
          `MonthlyFee` int,
          `TrainerID` int,
          `StartingDate` date,
          `EndingDate` date,
            FOREIGN key (TrainerID)
            references trainer(TrainerID)
          )


          ''');
    await db.execute('''
          CREATE TABLE `Admin` (
          `UserID` INTEGER PRIMARY KEY,
          `CenterName` varchar(20),
          `AdminName` varchar(20),
          `AdminType` int,
          `AdminPassword` varchar(20),
           FOREIGN key (UserID)
            references user(UserID)
          )



          ''');
    await db.execute('''
          CREATE TABLE `EquipmentList` (
          `CenterID` int,
          `EquipmentID` int,
          FOREIGN key (CenterID)
            references center(CenterID),
                FOREIGN key (EquipmentID)
            references equipment(EquipmentID)
          )




          ''');
    await db.execute('''
          CREATE TABLE `Client` (
          `UserID`  INTEGER PRIMARY KEY,
          `TypeID` int,
          `UserCity` varchar(20),
          `UserWeight` float,
          `UserHeight` int,
          FOREIGN key (TypeID)
            references UserPlan(TypeID),
          FOREIGN key (UserID)
            references user(UserID)
          )





          ''');

    await db.execute('''
         CREATE TABLE `WorkoutPlan` (
        `ItemID`  INTEGER PRIMARY KEY,
        `UserID` int,
        `WorkoutDetailsID` int,
        FOREIGN key (UserID)
          references User(UserID) ON DELETE CASCADE,
        FOREIGN key (WorkoutDetailsID)
          references WorkoutDetails(WorkoutDetailsID) ON DELETE CASCADE
        )






          ''');
    await db.rawInsert(
        '     INSERT INTO WorkoutDetails(WorkoutName,WorkoutDuration) values ("Push up",5),("Pull up",5),("Cardio",15)');

    await db.rawInsert(
        'INSERT INTO Center(CenterName,CenterCity,WorkoutType,CenterPopulation,CenterMaxLimit) values ("3X GYM","Niğde","Gym",18,30),("Ege Fitness","İzmir","Body Building",15,30),("Kayseri Fitness","Kayseri","Strecthing",12,30)');

    await db.rawInsert(
        '    INSERT INTO Equipment(EquipmentPackageName) values ("Dumbells"),("Rope"),("Benchpress")');

    await db.rawInsert(
        '        INSERT INTO Trainer(TrainerFirstName,TrainerLastName,TrainerSalary,TrainerGender,CenterID,TrainerDOB,TrainerSpeciality) values ("Adem","Demir",5000,"M",1,"1988-05-01","Body Building"),("Yeşim","Çilek",5600,"F",2,"2000-01-05","Gym"),("Sena","Deniz",8000,"F",2,"1998-08-08","Medical Helper"),("Mert","Aydın",7200,"M",1,"1988-02-12","Aeorobic")');
    await db.rawInsert(
        '        INSERT INTO UserPlan(MonthlyFee,TrainerID,StartingDate,EndingDate) values (100,2,"2021-04-07","2021-05-07")');

    await db.rawInsert(
        '            INSERT INTO User (UserFirstName,UserLastName,UserPassword,UserPhoneNumber,UserDOB,CenterID,UserGender) values("Murat", "Kara", "mstf123", "05352551325", "1998-02-15", 1, "M"),("Ege", "Deniz", "mstf123", "05352551325", "1998-02-15", 1, "M")');

    await db.rawInsert(
        '        INSERT INTO Admin(CenterName,AdminName,AdminType,AdminPassword) values ("3X GYM","Murat",1,"Murat123"),("Ege Fitness","Ege",1,"Ege123")');
    await db.rawInsert(
        '        INSERT INTO EquipmentList(CenterID,EquipmentID) values (1,1),(1,2),(1,3),(2,1),(2,2),(2,3),(3,1),(3,2),(3,3)');

  }


  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row,String tableName) async {
    Database? db = await instance.database;
    return await db!.insert(tableName, row);
  }

  Future<int>fetchAdmin(int id,String ps) async {
    Database? db = await instance.database;
    var list1=await db!.rawQuery('SELECT * FROM User where UserID=$id');
    var list=await db.rawQuery('SELECT * FROM Admin where UserID=$id');
    if(list.isEmpty){
      print("Wrong id");
      return 0;
    }
    else if (list1[0]["UserPassword"]!=ps){
      print("wrong password");
      return 1;

    }else if (list1[0]["UserPassword"]==ps){
      print("hello admin");
    }
    return 2;
  }

  Future<int>fetchUser(int id,String ps) async {
    Database? db = await instance.database;
    var list1=await db!.rawQuery('SELECT * FROM User where UserID=$id');
    if(list1.isEmpty){
      print("Wrong id");
      return 0;
    }
    else if (list1[0]["UserPassword"]!=ps){
      print("wrong password");
      return 1;

    }else if (list1[0]["UserPassword"]==ps){
      print("hello user");
    }
    return 2;
  }

  Future<int> signUser1(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id1 = await db!.rawInsert(
        'INSERT INTO User(UserFirstName, UserLastName, UserPassword) VALUES(?, ?, ?)',[row['UserFirstName'],row['UserLastName'],row['UserPassword']]);
    print('inserted1: $id1');
    return id1;
  }

  /*Future<int> signUser1(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id1 = await db!.rawInsert(
        'INSERT INTO User(UserFirstName, UserLastName, UserPassword) VALUES("${row['UserFirstName']}", "${row['UserLastName']}", "${row['UserPassword']}")');
    print('inserted1: $id1');
    int id2 = await db.rawInsert(
        'INSERT INTO Client(UserWeight, UserHeight) VALUES("90", "190")');

    return id1;
  }*/


  Future<int> signUser2(Map<String, dynamic> row) async {
    int x=int.parse(row['id']);
    Database? db = await instance.database;
    int id1 = await db!.rawUpdate(
        'UPDATE User SET UserPhoneNumber = ?, CenterID = ?, UserDOB = ?, UserGender = ? WHERE UserID = "$x"',
        ['${row['UserPhoneNumber']}', '${row['CenterID']}', '${row['UserDOB']}', '${row['UserGender']}']);
    print('updated: $id1');
    return id1;
  }

  /*
  Future<int> signUser2(Map<String, dynamic> row) async {
    int x=int.parse(row['id']);
    Database? db = await instance.database;
    int id1 = await db!.rawUpdate(
        'UPDATE User SET UserPhoneNumber = ?, CenterID = ?, UserDOB = ?, UserGender = ? WHERE UserID = "$x"',
        ['${row['UserPhoneNumber']}', '${row['CenterID']}', '${row['UserDOB']}', '${row['UserGender']}']);
    print('updated: $id1');
    return id1;
  }*/

  Future<int> workoutAdd(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id3 = await db!.rawInsert(
        'INSERT INTO WorkoutPlan(UserID, WorkoutDetailsID) VALUES(?, ?)',[row['UserID'],row['WorkoutDetailsID']]);
    print('inserted1: $id3');

    return id3;
  }
  /*
  Future<int> workoutAdd(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id3 = await db!.rawInsert(
        'INSERT INTO WorkoutPlan(UserID, WorkoutDetailsID) VALUES("${row['UserID']}", "${row['WorkoutDetailsID']}")');
    print('inserted1: $id3');

    return id3;
  }*/




  Future<List<Map>> getCenter() async{
    Database? db = await instance.database;
    var list=await db!.rawQuery('SELECT * FROM Center');

    return list;
  }
  Future<List<Map>> getUserInfo() async{
    Database? db = await instance.database;
    var list=await db!.rawQuery('SELECT UserID, UserFirstName,UserLastName FROM User');
    return list;
  }


  Future<List<Map<dynamic,dynamic>>> getWorkoutDetails(int id) async{
    Database? db = await instance.database;

    var list=await db!.rawQuery('SELECT WorkoutName,ItemID FROM WorkoutDetails Natural JOIN WorkoutPlan WHERE UserID = ?',[id]);
    return list;

  }
  // ignore: non_constant_identifier_names
  DeleteItem(int itemID) async{
    Database? db = await instance.database;
    await db!.rawQuery('DELETE from WorkoutPlan where ItemID= ?',[itemID]);
  }
  // ignore: non_constant_identifier_names
  DeleteAccount(int id) async{
    Database? db = await instance.database;
    //await db!.rawQuery('DELETE from WorkoutPlan where UserID=$id');
    await db!.rawQuery('DELETE from User where UserID=$id');

  }

  Future<String> getUser(int id) async{
    Database? db = await instance.database;

    var list=await db!.rawQuery('SELECT UserFirstName FROM User WHERE UserID=?',[id]);
    print(list[0]["UserFirstName"]);
    return list[0]["UserFirstName"];

  }

  Future<String> getUserDOB(int id) async{
    Database? db = await instance.database;

    var list=await db!.rawQuery('SELECT UserDOB FROM User WHERE UserID=?',[id]);
    print(list[0]["UserDOB"]);
    return list[0]["UserDOB"];

  }
  
  Future<int> getAge(String date) async{
    Database? db = await instance.database;
    var age=await db!.query("CREATE VIEW user_age_list As SELECT UserFirtsName, UserLastName,UserDOB,timestampdiff(YEAR, user.UserDOB, CURDATE()) AS age FROM user");
    print(age[2].toString());
    return int.parse(age[2].toString());
  }
}