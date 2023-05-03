import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:hitachi/models-Sqlite/dataSheetModel.dart';
import 'package:hitachi/models-Sqlite/windingSheetModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'my_database.db');
    var database = await openDatabase(dbPath, version: 1, onCreate: _createDb);
    return database;
  }
  //สร้างไฟล์กับ Column

  void _createDb(Database db, int newVersion) async {
    _createTableDataSheet(db, newVersion);
    _createTableWinding(db, newVersion);
    _createDateTimeNow(db, newVersion);
    _createTableJob(db, newVersion);
    _createTableProcess(db, newVersion);
    _createTableTreatment(db, newVersion);
    _createComboProblem(db, newVersion);
    _createTableBreakDown(db, newVersion);
    _createTableProblem(db, newVersion);
    _createSpecification(db, newVersion);
    _createWindingWeightSheet(db, newVersion);
  }

  Future<int> insertDataSheet(
      String tableName, Map<String, dynamic> row) async {
    Database db = await this.database;
    return await db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    Database db = await this.database;
    return await db.query(tableName);
  }

  //เขียนข้อมูลในSQlite

  //ลบข้อมูลในSQLITE
  Future<void> deleteDataFromSQLite(int id,
      {String? tableName, String? keyName}) async {
    try {
      Database db = await DatabaseHelper().database;
      int count = await db
          .delete('${tableName!}', where: '${keyName} = ?', whereArgs: [id]);
      print('Data deleted from SQLite with count: $count');
    } catch (e) {
      print('Error deleting from SQLite: $e');
    }
  }

  // Future<void> findSqliteFile() async {
  //   Directory appDocDir = await getApplicationDocumentsDirectory();
  //   String sqliteFilePath = '${appDocDir.path}/my_database.db';
  //   print(sqliteFilePath);
  //   // ตรวจสอบว่าไฟล์มีอยู่จริงหรือไม่
  //   if (await File(sqliteFilePath).exists()) {
  //     print('Found SQLite file at $sqliteFilePath');
  //   } else {
  //     print('SQLite file not found!');
  //   }
  // }
  //
  //TableDataSheetTable---------------------------------------------------------------------------------------------------------------------------------
  //
  Future<void> writeTableDataSheet_ToSQLite(DataSheetTableModel model) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'PO_NO': model.PO_NO,
        'INVOICE': model.IN_VOICE,
        'FRIEGHT': model.FRIEGHT,
        'INCOMING_DATE': model.INCOMING_DATE,
        'STORE_BY': model.STORE_BY,
        'PACK_NO': model.PACK_NO,
        'STORE_DATE': model.STORE_DATE,
        'STATUS': model.STATUS,
        'W1': model.W1,
        'W2': model.W2,
        'WEIGHT': model.WEIGHT,
        'MFG_DATE': model.MFG_DATE,
        'THICKNESS': model.THICKNESS,
        'WRAP_GRADE': model.WRAP_GRADE,
        'ROLL_NO': model.ROLL_NO,
        'checkComplete': model.CHECK_COMPLETE,
      };
      int id = await db.insert('DATA_SHEET', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  void _createTableDataSheet(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE DATA_SHEET (PO_NO INTEGER PRIMARY KEY AUTOINCREMENT, INVOICE TEXT,FRIEGHT TEXT,INCOMING_DATE TEXT,STORE_BY TEXT,PACK_NO TEXT,STORE_DATE TEXT,  STATUS TEXT, W1 REAL,W2 REAL,WEIGHT REAL,MFG_DATE TEXT,THICKNESS REAL,WRAP_GRADE TEXT,ROLL_NO REAL,checkComplete TEXT)');
  }

  ///
  //TABLE WINDING ------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  Future<void> writeTableWindingSheet_ToSqlite(WindingSheetModel items) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'MachineNo': items.MACHINE_NO,
        'OperatorName': items.OPERATOR_NAME,
        'BatchNo': items.BATCH_NO,
        'Product': items.PRODUCT,
        'PackNo': items.PACK_NO,
        'PaperCore': items.PAPER_CORE,
        'PPCore': items.PP_CORE,
        'FoilCore': items.FOIL_CORE,
        'BatchStartDate': items.BATCH_START_DATE,
        'BatchEndDate': items.BATCH_END_DATE,
        'Element': items.ELEMENT,
        'Status': items.STATUS,
        'start_end': items.START_END,
        'checkComplete': items.CHECK_COMPLETE
      };
      int id = await db.insert('WINDING_SHEET', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  void _createTableWinding(Database db, int newVersion) async {
    await db.execute('CREATE TABLE WINDING_SHEET ('
        'MachineNo INTEGER PRIMARY KEY AUTOINCREMENT, '
        'OperatorName TEXT, '
        'BatchNo INTEGER, '
        'Product INTEGER, '
        'PackNo INTEGER, '
        'PaperCore TEXT, '
        'PPCore TEXT, '
        'FoilCore TEXT, '
        'BatchStartDate TEXT, '
        'BatchEndDate TEXT, '
        'Element INTEGER, '
        'Status TEXT, '
        'start_end TEXT, '
        'checkComplete TEXT '
        ')');
  }

  ///
  //TABLE DATETIMENOW ------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  Future<void> writeTableDateTimeNow_ToSqlite({String? dateTimeNow}) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'DateTimeNow': dateTimeNow,
      };
      int id = await db.insert('DATE_TIME_NOW_SHEET', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  void _createDateTimeNow(Database db, int newVersion) async {
    await db.execute('CREATE TABLE DATE_TIME_NOW_SHEET ('
        'DateTimeNow TEXT '
        ')');
  }

  ///
  //TABLE JOBB------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  Future<void> writeTableJob_ToSqlite({
    int? machineNo,
    String? operator_Name,
    int? batch_No,
    int? product,
    int? pack_No,
    String? batchStartDate,
    String? batchEndDate,
    String? status,
    int? element,
    String? startEnd,
    String? checkComplete,
  }) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'MachineNo': machineNo,
        'OperatorName': operator_Name,
        'BatchNo': batch_No,
        'Product': product,
        'PackNo': pack_No,
        'BatchStartDate': batchStartDate,
        'BatchEndDate': batchEndDate,
        'Status': status,
        'Element': element,
        'StartEnd': startEnd,
        'CheckComplete': checkComplete,
      };
      int id = await db.insert('JOB_SHEET', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  void _createTableJob(Database db, int newVersion) async {
    await db.execute('CREATE TABLE JOB_SHEET ('
        'MachineNo INTEGER PRIMARY KEY AUTOINCREMENT,'
        'OperatorName TEXT,'
        'BatchNo INTEGER,'
        'Product INTEGER,'
        'PackNo INTEGER,'
        'BatchStartDate TEXT,'
        'BatchEndDate TEXT, '
        'Status TEXT,'
        'Element INTEGER,'
        'StartEnd TEXT,'
        'CheckComplete TEXT'
        ')');
  }

  ///
  //TABLE PROCESS------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  Future<void> writeTableProcess_ToSqlite({
    String? machine_No,
    String? operator_Name,
    String? operator_Name1,
    String? operator_Name2,
    String? operator_Name3,
    int? batch_No,
    String? start_Date,
    String? garbage,
    String? fin_Date,
    String? start_End,
    String? check_Complete,
  }) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'Machine': machine_No,
        'OperatorName': operator_Name,
        'OperatorName1': operator_Name1,
        'OperatorName2': operator_Name2,
        'OperatorName3': operator_Name3,
        'BatchNo': batch_No,
        'StartDate': start_Date,
        'Garbage': garbage,
        'FinDate': fin_Date,
        'StartEnd': start_End,
        'CheckComplete': check_Complete,
      };
      int id = await db.insert('PROCESS_SHEET', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  void _createTableProcess(Database db, int newVersion) async {
    await db.execute('CREATE TABLE PROCESS_SHEET ('
        'Machine INTEGER PRIMARY KEY AUTOINCREMENT,'
        'OperatorName TEXT,'
        'OperatorName1 TEXT,'
        'OperatorName2 TEXT,'
        'OperatorName3 TEXT,'
        'BatchNo INTEGER,'
        'StartDate TEXT, '
        'Garbage TEXT,'
        'FinDate TEXT,'
        'StartEnd TEXT,'
        'CheckComplete TEXT'
        ')');
  }

  ///
  //TABLE TREATMENT------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  Future<void> writeTableTreatment_ToSqlite({
    String? machineno,
    String? operatorname,
    int? batch1,
    int? batch2,
    int? batch3,
    int? batch4,
    int? batch5,
    int? batch6,
    int? batch7,
    String? startdate,
    String? findate,
    String? startend,
    String? checkcomplete,
  }) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'MachineNo': machineno,
        'OperatorName': operatorname,
        'Batch1': batch1,
        'Batch2': batch2,
        'Batch3': batch3,
        'Batch4': batch4,
        'Batch5': batch5,
        'Batch6': batch6,
        'Batch7': batch7,
        'StartDate': startdate,
        'FinDate': findate,
        'StartEnd': startend,
        'CheckComplete': checkcomplete,
      };
      int id = await db.insert('TREATMENT_SHEET', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  void _createTableTreatment(Database db, int newVersion) async {
    await db.execute('CREATE TABLE TREATMENT_SHEET ('
        'MachineNo INTEGER PRIMARY KEY AUTOINCREMENT,'
        'OperatorName TEXT,'
        'Batch1 INTEGER,'
        'Batch2 INTEGER,'
        'Batch3 INTEGER,'
        'Batch4 INTEGER,'
        'Batch5 INTEGER, '
        'Batch6 INTEGER,'
        'Batch7 INTEGER,'
        'StartDate TEXT,'
        'FinDate TEXT,'
        'StartEnd TEXT,'
        'CheckComplete TEXT'
        ')');
  }

  ///
  //TABLE PROBLEM------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  Future<void> writeTableProblem_ToSqlite({
    String? machineNo,
    String? operatorName,
    int? batchNo,
    String? pDate,
    String? problemAlway,
    String? problemETC,
    String? checkComplete,
  }) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'MachineNo': machineNo,
        'OperatorName': operatorName,
        'BatchNo': batchNo,
        'PDate': pDate,
        'ProblemAlway': problemAlway,
        'ProblemETC': problemETC,
        'CheckComplete': checkComplete,
      };
      int id = await db.insert('PROBLEM_SHEET', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  void _createTableProblem(Database db, int newVersion) async {
    await db.execute('CREATE TABLE PROBLEM_SHEET ('
        'MachineNo INTEGER PRIMARY KEY AUTOINCREMENT,'
        'OperatorName TEXT,'
        'BatchNo INTEGER,'
        'PDate TEXT,'
        'ProblemAlway TEXT,'
        'ProblemETC TEXT,'
        'CheckComplete TEXT'
        ')');
  }

  ///
  //TABLE BREAKDOWN------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  Future<void> writeTableBreakDown_ToSqlite({
    int? machineNo,
    String? callUser,
    String? repairNo,
    String? breakStartDate,
    String? mt1,
    String? mt1StartDate,
    String? mt2,
    String? mt2StartDate,
    String? mt1StopDate,
    String? mt2StopDate,
    String? checkUser,
    String? breakStopDate,
    String? checkComplete,
  }) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'MachineNo': machineNo,
        'CallUser': callUser,
        'RepairNo': repairNo,
        'BreakStartDate': breakStartDate,
        'MT1': mt1,
        'MT1StartDate': mt1StartDate,
        'MT2': mt2,
        'MT2StartDate': mt2StartDate,
        'MT1StopDate': mt1StopDate,
        'MT2StopDate': mt2StopDate,
        'CheckUser': checkUser,
        'BreakStopDate': breakStopDate,
        'CheckComplete': checkComplete,
      };
      int id = await db.insert('BREAKDOWN_SHEET', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  void _createTableBreakDown(Database db, int newVersion) async {
    await db.execute('CREATE TABLE BREAKDOWN_SHEET ('
        'MachineNo INTEGER PRIMARY KEY AUTOINCREMENT,'
        'CallUser TEXT,'
        'RepairNo TEXT,'
        'BreakStartDate TEXT,'
        'MT1 TEXT,'
        'MT1StartDate TEXT,'
        'MT2 TEXT,'
        'MT2StartDate TEXT,'
        'MT1StopDate TEXT,'
        'MT2StopDate TEXT,'
        'CheckUser TEXT,'
        'BreakStopDate TEXT,'
        'CheckComplete TEXT'
        ')');
  }

  ///
  //TABLE COMBOTPROBLEM------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  Future<void> writeTableComboProblem_ToSqlite({
    int? ID,
    String? process,
    String? probelm,
  }) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'ID': ID,
        'Process': process,
        'Problem': probelm,
      };
      int id = await db.insert('COMBO_PROBLEM_SHEET', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  void _createComboProblem(Database db, int newVersion) async {
    await db.execute('CREATE TABLE COMBO_PROBLEM_SHEET ('
        'ID INTEGER PRIMARY KEY AUTOINCREMENT, '
        'Process TEXT,'
        'Problem TEXT'
        ')');
  }

  //////////////////////////////////////////////////////////////
  ////////////////////////////Phase 2////////////////////////////
  //////////////////////////////////////////////////////////////////

  ///
  //TABLE SPECIFICATION_SHEET------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  Future<void> writeTableSpecification_ToSqlite({
    String? JUMET,
    String? IPE,
    num? Wind_min,
    num? Wind_Avg,
    num? Wind_Max,
    num? Wind_Dia,
    num? Wind_Turn,
    String? Clearing,
    String? Treatment,
    String? Ipeak,
    String? HighVolt,
    String? Reactor,
    num? Measure_Min,
    num? Measure_Max,
    String? Tangent,
    num? BomP,
    num? SM,
    num? S1,
    num? S2,
  }) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'JUMET': JUMET,
        'IPE': IPE,
        'Wind_min': Wind_min,
        'Wind_Avg': Wind_Avg,
        'Wind_Max': Wind_Max,
        'Wind_Dia': Wind_Dia,
        'Wind_Turn': Wind_Turn,
        'Clearing': Clearing,
        'Treatment': Treatment,
        'Ipeak': Ipeak,
        'HighVolt': HighVolt,
        'Reactor': Reactor,
        'Measure_Min': Measure_Min,
        'Measure_Max': Measure_Max,
        'Tangent': Tangent,
        'BomP': BomP,
        'SM': SM,
        'S1': S1,
        'S2': S2,
      };
      int id = await db.insert('SPECIFICATION_SHEET', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  void _createSpecification(Database db, int newVersion) async {
    await db.execute('CREATE TABLE SPECIFICATION_SHEET ('
        'JUMET TEXT, '
        'IPE TEXT,'
        'Wind_min REAL,'
        'Wind_Avg REAL,'
        'Wind_Max REAL,'
        'Wind_Dia REAL,'
        'Wind_Turn REAL,'
        'Clearing TEXT,'
        'Treatment TEXT,'
        'Ipeak TEXT,'
        'HighVolt TEXT,'
        'Reactor TEXT,'
        'Measure_Min REAL,'
        'Measure_Max REAL,'
        'Tangent TEXT,'
        'BomP REAL,'
        'SM REAL,'
        'S1 REAL,'
        'S2 REAL'
        ')');
  }

  ///
  //TABLE WINDING_WEIGHT_SHEET------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  Future<void> writeTableWindingWeightSheet_ToSqlite({
    int? machineNo,
    int? batchNo,
    num? target,
  }) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'MachineNo': machineNo,
        'BatchNo': batchNo,
        'Target': target,
      };
      int id = await db.insert('WINDING_WEIGHT_SHEET', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  void _createWindingWeightSheet(Database db, int newVersion) async {
    await db.execute('CREATE TABLE WINDING_WEIGHT_SHEET ('
        'MachineNo INTEGER PRIMARY KEY AUTOINCREMENT, '
        'BatchNo INTEGER,'
        'Target REAL,'
        ')');
  }
}
