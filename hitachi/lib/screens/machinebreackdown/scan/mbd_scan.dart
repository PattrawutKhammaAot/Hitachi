import 'package:dotted_line/dotted_line.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/machineBreakDown/machine_break_down_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/breakdownSheetModel.dart';
import 'package:hitachi/models/ResponeDefault.dart';
import 'package:hitachi/models/machineBreakdown/machinebreakdownOutputMode.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:intl/intl.dart';

class MachineBreakDownScanScreen extends StatefulWidget {
  const MachineBreakDownScanScreen({super.key});

  @override
  State<MachineBreakDownScanScreen> createState() =>
      _MachineBreakDownScanScreenState();
}

class _MachineBreakDownScanScreenState
    extends State<MachineBreakDownScanScreen> {
  final TextEditingController _dpbMachineNo_Controller =
      TextEditingController();
  final TextEditingController _machineNo_Controller = TextEditingController();
  final TextEditingController _operatorname_Controller =
      TextEditingController();
  final TextEditingController _serviceNo_Controller = TextEditingController();
  final TextEditingController _start_Technical_1_Controller =
      TextEditingController();
  final TextEditingController _start_Technical_2_Controller =
      TextEditingController();
  final TextEditingController _stop_Technical_1_Controller =
      TextEditingController();
  final TextEditingController _stop_Technical_2_Controller =
      TextEditingController();
  final TextEditingController _operator_accept_Controller =
      TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();
  ResponeDefault? _respone;

  List<BreakDownSheetModel> bdsList = [];

  String? selectedValue;
  //FOCUS
  final f1 = FocusNode();
  final f2 = FocusNode();
  final f3 = FocusNode();
  final f4 = FocusNode();
  final f5 = FocusNode();
  final f6 = FocusNode();
  final f7 = FocusNode();
  final f8 = FocusNode();
  final f9 = FocusNode();
  final f10 = FocusNode();
//
  final _formKey = GlobalKey<FormState>();

  void _checkValueController() async {
    if (_machineNo_Controller.text.isNotEmpty &&
        _operatorname_Controller.text.isNotEmpty &&
        _serviceNo_Controller.text.isNotEmpty &&
        _start_Technical_1_Controller.text.isNotEmpty &&
        _stop_Technical_1_Controller.text.isNotEmpty &&
        _operator_accept_Controller.text.isNotEmpty) {
      _sendData();
    } else if (_machineNo_Controller.text.isNotEmpty &&
        _operatorname_Controller.text.isNotEmpty &&
        _start_Technical_1_Controller.text.isNotEmpty) {
      _errorDialog(
          text: Label("Do you wanna Save ?"),
          onpressOk: () async {
            await _saveMachine();
            await _callBreakDownMachine();
            _checkControllerIsNull();
            f1.requestFocus();
            Navigator.pop(context);
            EasyLoading.showSuccess("Save Successs");
          });
    } else {
      EasyLoading.showInfo("Please Input Info");
    }
  }

  void _checkControllerIsNull() {
    _dpbMachineNo_Controller.clear();
    _machineNo_Controller.text.isNotEmpty
        ? _machineNo_Controller.clear()
        : _machineNo_Controller.text;
    _operatorname_Controller.text.isNotEmpty
        ? _operatorname_Controller.clear()
        : _operatorname_Controller.text;
    _serviceNo_Controller.text.isNotEmpty
        ? _serviceNo_Controller.clear()
        : _serviceNo_Controller.text;
    _start_Technical_1_Controller.text.isNotEmpty
        ? _start_Technical_1_Controller.clear()
        : _start_Technical_1_Controller.text;
    _stop_Technical_1_Controller.text.isNotEmpty
        ? _stop_Technical_1_Controller.clear()
        : _stop_Technical_1_Controller.text;
    _operator_accept_Controller.text.isNotEmpty
        ? _operator_accept_Controller.clear()
        : _operator_accept_Controller.text;
  }

  Future<void> _callBreakDownMachine({bool isCallBdm = false}) async {
    var sql = await databaseHelper.queryAllRows('BREAKDOWN_SHEET');
    if (sql.length > 0) {
      setState(() {
        bdsList = sql
            .map((row) => BreakDownSheetModel.fromMap(
                row.map((key, value) => MapEntry(key, value))))
            .toList();
      });
    }

    // เช็คว่า "NEW" อยู่ในรายการ bdsList หรือไม่
    bool isNewExist = false;
    for (var item in bdsList) {
      if (item.MACHINE_NO == "NEW") {
        isNewExist = true;
        break;
      }
    }

    // ถ้า "NEW" ยังไม่อยู่ในรายการ bdsList ให้เพิ่มเข้าไป
    if (!isNewExist) {
      setState(() {
        bdsList.insert(0, BreakDownSheetModel(MACHINE_NO: "NEW"));
      });
    }
  }

  @override
  void initState() {
    f1.requestFocus();
    _callBreakDownMachine(isCallBdm: true);
    super.initState();
  }

  Future _saveMachine() async {
    try {
      var sql = await databaseHelper.queryAllRows('BREAKDOWN_SHEET');
      bool found = false;
      var items;
      for (items in sql) {
        if (_machineNo_Controller.text.trim() == items['MachineNo'].trim()) {
          found = true;
          print(found);
          break;
        } else {
          found = false;
          print("Check ${found} = false");
        }
      }

      if (found == true) {
        var sql_breakdown = await databaseHelper.queryDataSelect(
            select1: 'MT1StartDate',
            select2: 'MT2StartDate',
            select3: 'MT1StopDate',
            select4: 'MT2StopDate',
            formTable: 'BREAKDOWN_SHEET',
            stringValue: _machineNo_Controller.text.trim());

        await databaseHelper.updateSqlite(
            'BREAKDOWN_SHEET',
            {
              'MachineNo': _machineNo_Controller.text.trim(),
              'CallUser': _operatorname_Controller.text.trim(),
              'RepairNo': _serviceNo_Controller.text.trim(),
              'BreakStartDate':
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
              'MT1': _start_Technical_1_Controller.text.trim(),
              'MT1StartDate':
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
              'MT2': _start_Technical_2_Controller.text.trim(),
              'MT2StartDate': _start_Technical_2_Controller.text.isEmpty
                  ? ""
                  : DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
              'MT1StopDate': _stop_Technical_1_Controller.text.trim(),
              'MT2StopDate': _stop_Technical_2_Controller.text.trim(),
              'CheckUser': _operator_accept_Controller.text.trim(),
              'BreakStopDate': "", //ไม่รู้ว่ามาจากไหน
              'CheckComplete': "",
            },
            'MachineNo = ?',
            [_machineNo_Controller.text.trim()]);
        _dpbMachineNo_Controller.clear();
        _machineNo_Controller.clear();
        _operatorname_Controller.clear();
        _serviceNo_Controller.clear();
        _start_Technical_1_Controller.clear();
        _start_Technical_2_Controller.clear();
        _stop_Technical_1_Controller.clear();
        _stop_Technical_2_Controller.clear();
        _operator_accept_Controller.clear();
      } else if (found == false) {
        print("INSERT TESTING DEBUG");
        await databaseHelper.insertSqlite('BREAKDOWN_SHEET', {
          'MachineNo': _machineNo_Controller.text.trim(),
          'CallUser': _operatorname_Controller.text.trim(),
          'RepairNo': _serviceNo_Controller.text.trim(),
          'BreakStartDate':
              DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          'MT1': _start_Technical_1_Controller.text.trim(),
          'MT1StartDate':
              DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          'MT2': _start_Technical_2_Controller.text.trim(),
          'MT2StartDate': _start_Technical_2_Controller.text.isEmpty
              ? ""
              : DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          'MT1StopDate': _stop_Technical_1_Controller.text.trim(),
          'MT2StopDate': _stop_Technical_2_Controller.text.trim(),
          'CheckUser': _operator_accept_Controller.text.trim(),
          'BreakStopDate': _operator_accept_Controller.text.isEmpty
              ? ""
              : DateFormat('yyyy-MM-dd HH:mm:ss')
                  .format(DateTime.now()), //ไม่รู้ว่ามาจากไหน
          'CheckComplete': "",
        });
      }
    } catch (e, s) {
      print("${e}${s}");
      EasyLoading.showError("Can not Save");
    }
  }

  void _sendData() {
    BlocProvider.of<MachineBreakDownBloc>(context).add(
      MachineBreakDownSendEvent(
        MachineBreakDownOutputModel(
            MACHINE_NO: _machineNo_Controller.text.trim(),
            OPERATOR_NAME: _operatorname_Controller.text.trim(),
            SERVICE: _serviceNo_Controller.text.trim(),
            BREAK_START_DATE:
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
            MT1: _start_Technical_1_Controller.text.trim(),
            MT1_START_DATE:
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
            MT2: _start_Technical_2_Controller.text.trim(),
            MT2_START_DATE: _start_Technical_2_Controller.text.isEmpty
                ? ""
                : DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
            MT1_STOP: _stop_Technical_1_Controller.text.trim(),
            MT2_STOP: _stop_Technical_2_Controller.text.trim(),
            ACCEPT: _operator_accept_Controller.text.trim(),
            BREAK_STOP_DATE: _operator_accept_Controller.text.isEmpty
                ? ""
                : DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())),
      ),
    );
  }

  Future _delete() async {
    setState(() {
      bdsList.clear();
    });
    await databaseHelper.deletedRowSqlite(
        tableName: 'BREAKDOWN_SHEET',
        columnName: 'MachineNo',
        columnValue: _machineNo_Controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MachineBreakDownBloc, MachineBreakDownState>(
          listener: (context, state) async {
            if (state is PostMachineBreakdownLoadingState) {
              EasyLoading.show(status: "Loading");
            } else if (state is PostMachineBreakdownLoadedState) {
              EasyLoading.dismiss();
              setState(() {
                _respone = state.item;
              });
              if (_respone!.RESULT == true) {
                await _delete();
                await _callBreakDownMachine();

                _checkControllerIsNull();
                f1.requestFocus();
                EasyLoading.showSuccess("Send complete",
                    duration: Duration(seconds: 3));
              } else {
                _errorDialog(
                    text: Label(
                        "${_respone?.MESSAGE ?? "Check Connection\n Do you want to Save Data"}"),
                    onpressOk: () async {
                      await _saveMachine();
                      _checkControllerIsNull();
                      f1.requestFocus();
                      Navigator.pop(context);
                    });
              }
            }
            if (state is PostMachineBreakdownErrorState) {
              EasyLoading.dismiss();
              // _saveMachine();
              EasyLoading.showError("Can not send");
            }
          },
        )
      ],
      child: BgWhite(
          isHideAppBar: true,
          body: Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Label("Machine No. : "),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: bdsList.isNotEmpty
                              ? DropdownButtonFormField2(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  isExpanded: true,
                                  hint: Center(
                                    child: Text(
                                      'New',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  items: bdsList
                                      .where((item) => item.MACHINE_NO != null)
                                      .toSet()
                                      .toList()
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item.MACHINE_NO,
                                            child: Text(
                                              "${item.MACHINE_NO}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    for (var item in bdsList) {
                                      if (value == item.MACHINE_NO &&
                                          value != 'NEW') {
                                        setState(() {
                                          _machineNo_Controller.text =
                                              item.MACHINE_NO.toString();
                                          _operatorname_Controller.text =
                                              item.OPERATOR_NAME.toString();
                                          _serviceNo_Controller.text =
                                              item.SERVICE_NO.toString();
                                          if (item.TECH_1 != null) {
                                            _start_Technical_1_Controller.text =
                                                item.TECH_1.toString();
                                          }
                                          if (item.STOP_DATE_TECH_1 != null) {
                                            _stop_Technical_1_Controller.text =
                                                item.STOP_DATE_TECH_1
                                                    .toString();
                                          }
                                          if (item.OPERATOR_ACCEPT != null) {
                                            _operator_accept_Controller.text =
                                                item.OPERATOR_ACCEPT.toString();
                                          }
                                          if (item.TECH_2 != null) {
                                            _start_Technical_2_Controller.text =
                                                item.TECH_2.toString();
                                          }
                                          if (item.STOP_DATE_TECH_2 != null) {
                                            _stop_Technical_2_Controller.text =
                                                item.STOP_DATE_TECH_2
                                                    .toString();
                                          }
                                        });
                                        break;
                                      } else if (value == 'NEW') {
                                        setState(() {
                                          _machineNo_Controller.clear();
                                          _operatorname_Controller.clear();
                                          _serviceNo_Controller.clear();
                                          _start_Technical_1_Controller.clear();
                                          _start_Technical_2_Controller.clear();
                                          _stop_Technical_1_Controller.clear();
                                          _stop_Technical_2_Controller.clear();
                                          _operator_accept_Controller.clear();
                                          f1.requestFocus();
                                        });
                                      }
                                    }
                                  },
                                  onSaved: (value) {
                                    selectedValue = value.toString();
                                    print(value);
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    height: 50,
                                    padding:
                                        EdgeInsets.only(left: 20, right: 10),
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black45,
                                    ),
                                    iconSize: 30,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const DottedLine(),
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    focusNode: f1,
                    onEditingComplete: () {
                      if (_machineNo_Controller.text.length == 3) {
                        f2.requestFocus();
                      }
                    },
                    labelText: "Machine No. : ",
                    height: 30,
                    controller: _machineNo_Controller,
                    maxLength: 3,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    focusNode: f2,
                    onEditingComplete: () {
                      if (_operatorname_Controller.text.length == 12) {
                        f3.requestFocus();
                      }
                    },
                    labelText: "Operator Name : ",
                    height: 30,
                    controller: _operatorname_Controller,
                    maxLength: 12,
                    type: TextInputType.number,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    focusNode: f3,
                    onEditingComplete: () => f4.requestFocus(),
                    labelText: "Service No. : ",
                    controller: _serviceNo_Controller,
                    height: 30,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          focusNode: f4,
                          onEditingComplete: () {
                            f6.requestFocus();
                          },
                          labelText: "Start Technical 1 : ",
                          controller: _start_Technical_1_Controller,
                          height: 30,
                          onChanged: (p0) {
                            setState(() {
                              if (p0.length >= 1) {
                                _start_Technical_1_Controller.text.isNotEmpty;
                              } else {
                                _start_Technical_1_Controller.text.isEmpty;
                                _start_Technical_2_Controller.text = '';
                                _stop_Technical_2_Controller.text = '';
                              }
                            });
                          },
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          focusNode: f5,
                          onEditingComplete: () {
                            f7.requestFocus();
                            setState(() {
                              if (_start_Technical_2_Controller.text != null) {
                                _start_Technical_2_Controller.text.isNotEmpty;
                              } else {
                                _start_Technical_2_Controller.text.isNotEmpty;
                              }
                            });
                          },
                          onChanged: (p0) {
                            setState(() {
                              if (p0.length > 1) {
                                _start_Technical_2_Controller.text.isNotEmpty;
                              } else {
                                _start_Technical_2_Controller.text.isEmpty;
                              }
                            });
                          },
                          labelText: "Start Technical 2 : ",
                          controller: _start_Technical_2_Controller,
                          height: 30,
                          enabled:
                              _start_Technical_1_Controller.text.isNotEmpty,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          focusNode: f6,
                          onEditingComplete: () => f5.requestFocus(),
                          labelText: "Stop Technical 1 : ",
                          controller: _stop_Technical_1_Controller,
                          height: 30,
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          focusNode: f7,
                          onEditingComplete: () => f8.requestFocus(),
                          labelText: "Stop Technical 2 : ",
                          controller: _stop_Technical_2_Controller,
                          height: 30,
                          enabled:
                              _start_Technical_2_Controller.text.isNotEmpty,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    focusNode: f8,
                    onEditingComplete: () => _checkValueController(),
                    labelText: "Operator Accept : ",
                    controller: _operator_accept_Controller,
                    height: 30,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Button(
                    onPress: () {
                      // _testInsert();
                      _checkValueController();
                    },
                    text: Label(
                      "send",
                      color: COLOR_WHITE,
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  void _errorDialog(
      {Label? text, Function? onpressOk, Function? onpressCancel}) async {
    // EasyLoading.showError("Error[03]", duration: Duration(seconds: 5));//if password
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('AlertDialog Title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: text,
            ),
          ],
        ),

        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => onpressOk?.call(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _testInsert() async {
    await databaseHelper.insertSqlite('BREAKDOWN_SHEET', {
      'MachineNo': _machineNo_Controller.text.trim(),
      'CallUser': _operatorname_Controller.text.trim(),
      'RepairNo': _serviceNo_Controller.text.trim(),
      'BreakStartDate': DateTime.now().toString(),
      'MT1': _start_Technical_1_Controller.text.trim(),
      'MT1StartDate': DateTime.now().toString(),
      'MT2': _start_Technical_2_Controller.text.trim(),
      'MT2StartDate': DateTime.now().toString(),
      'MT1StopDate': _stop_Technical_1_Controller.text.trim(),
      'MT2StopDate': _stop_Technical_2_Controller.text.trim(),
      'CheckUser': _operator_accept_Controller.text.trim(),
      'BreakStopDate': "", //ไม่รู้ว่ามาจากไหน
      'CheckComplete': "",
    });
  }
}
