import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/processFinish/processFinishInputModel.dart';
import 'package:hitachi/models/processFinish/processFinishOutput.dart';
import 'package:hitachi/services/databaseHelper.dart';

class ProcessFinishScanScreen extends StatefulWidget {
  const ProcessFinishScanScreen({super.key});

  @override
  State<ProcessFinishScanScreen> createState() =>
      _ProcessFinishScanScreenState();
}

class _ProcessFinishScanScreenState extends State<ProcessFinishScanScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  ProcessFinishInputModel? items;

  final TextEditingController machineNoController = TextEditingController();
  final TextEditingController operatorNameController = TextEditingController();
  final TextEditingController batchNoController = TextEditingController();
  final TextEditingController rejectQtyController = TextEditingController();

  String valuetxtinput = "";
  Color? bgChange;
  bool _checkSendSqlite = false;

  final f1 = FocusNode();
  final f2 = FocusNode();
  final f3 = FocusNode();
  final f4 = FocusNode();

  @override
  void initState() {
    rejectQtyController.text = "0";
    super.initState();
    f1.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LineElementBloc, LineElementState>(
          listener: (context, state) {
            if (state is ProcessFinishLoadingState) {
              EasyLoading.show();
              print("loading");
            }
            if (state is ProcessFinishLoadedState) {
              print("Loaded");

              EasyLoading.show(status: "Loaded");

              if (state.item.RESULT == true) {
                EasyLoading.showSuccess("SendComplete");
                _clearAllData();
              } else if (state.item.RESULT == false) {
                EasyLoading.showError("Can not send & save Data");
                items = state.item;
                _getProcessStart();
                if (_checkSendSqlite == true) {
                  _saveSendSqlite();
                  print("save true");
                } else if (_checkSendSqlite == false) {
                  _updateSendSqlite();
                  print("save false");
                }
                _clearAllData();
              } else {
                EasyLoading.showError("Can not Call API");
                _getProcessStart();
                if (_checkSendSqlite == true) {
                  _saveSendSqlite();
                  print("save true");
                } else if (_checkSendSqlite == false) {
                  _updateSendSqlite();
                  print("save false");
                }
                _clearAllData();
              }
            }
            if (state is ProcessFinishErrorState) {
              print("ERROR");
              EasyLoading.dismiss();
              _getProcessStart();
              if (_checkSendSqlite == true) {
                _saveSendSqlite();
                print("save true");
              } else if (_checkSendSqlite == false) {
                _updateSendSqlite();
                print("save false");
              }
              _clearAllData();
              EasyLoading.showError("Please Check Connection Internet");
            }
          },
        )
      ],
      child: BgWhite(
          isHideAppBar: true,
          textTitle: "ProcessFinish",
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  RowBoxInputField(
                    labelText: "Machine No : ",
                    maxLength: 3,
                    controller: machineNoController,
                    focusNode: f1,
                    onEditingComplete: () {
                      // f2.requestFocus();
                      if (machineNoController.text.length > 2) {
                        setState(() {
                          print(machineNoController.text);
                          // _enabledMachineNo = false;
                        });
                        f2.requestFocus();
                      } else {
                        setState(() {
                          // _enabledCheckMachine = false;
                          valuetxtinput = "Machine No. INVALID";
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    labelText: "Operator Name : ",
                    controller: operatorNameController,
                    focusNode: f2,
                    maxLength: 12,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    onEditingComplete: () {
                      if (operatorNameController.text.length == 12) {
                        setState(() {
                          f3.requestFocus();
                        });
                      } else {
                        setState(() {
                          valuetxtinput = "User INVALID";
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    labelText: "Batch No : ",
                    controller: batchNoController,
                    type: TextInputType.number,
                    focusNode: f3,
                    maxLength: 12,
                    onEditingComplete: () {
                      if (batchNoController.text.length == 12) {
                        f4.requestFocus();
                      }
                    },
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    onChanged: (value) {
                      if (value.length == 2) {
                        if (value == "WD") {
                          setState(() {
                            _clearAllData();
                            valuetxtinput =
                                "จะต้องไม่ขึ้นต้นด้วย WD เพราะผ่านการ Winding มาแล้ว";
                          });
                        }
                      }
                      if (machineNoController.text.isNotEmpty &&
                          operatorNameController.text.isNotEmpty) {
                        setState(() {
                          bgChange = COLOR_RED;
                        });
                      } else {
                        setState(() {
                          bgChange = Colors.grey;
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    labelText: "Reject Qty : ",
                    controller: rejectQtyController,
                    focusNode: f4,
                    type: TextInputType.number,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    onEditingComplete: () {
                      _btnSend();
                    },
                    // type: TextInputType.number,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Visibility(
                        visible: true,
                        child: Container(
                            child: Label(
                          valuetxtinput,
                          color: COLOR_RED,
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Button(
                    height: 40,
                    bgColor: bgChange ?? Colors.grey,
                    text: Label(
                      "Send",
                      color: COLOR_WHITE,
                    ),
                    onPress: () => _btnSend(),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void _btnSend() async {
    if (machineNoController.text.isNotEmpty &&
        operatorNameController.text.isNotEmpty &&
        batchNoController.text.isNotEmpty) {
      _callAPI();
    } else {
      EasyLoading.showInfo("กรุณาใส่ข้อมูลให้ครบ");
    }
  }

  void _callAPI() {
    BlocProvider.of<LineElementBloc>(context).add(
      ProcessFinishInputEvent(ProcessFinishOutputModel(
        MACHINE: machineNoController.text.trim(),
        OPERATORNAME: int.tryParse(operatorNameController.text.trim()),
        BATCHNO: int.tryParse(batchNoController.text.trim()),
        REJECTQTY: rejectQtyController.text.trim(),
        FINISHDATE: DateTime.now().toString(),
      )),
    );
  }

  void _clearAllData() async {
    try {
      machineNoController.text = "";
      operatorNameController.text = "";
      batchNoController.text = "";
      rejectQtyController.text = "";
    } catch (e) {
      print(e);
    }
  }

  void _updateSendSqlite() async {
    try {
      if (operatorNameController.text.isNotEmpty) {
        await databaseHelper.updateProcessFinish(
            table: 'PROCESS_SHEET',
            key1: 'OperatorName',
            yieldKey1: int.tryParse(operatorNameController.text.trim()),
            key2: 'BatchNo',
            yieldKey2: operatorNameController.text.trim(),
            key3: 'Garbage',
            yieldKey3: rejectQtyController.text.trim(),
            key4: 'StartEnd',
            yieldKey4: DateTime.now().toString(),
            whereKey: 'Machine',
            value: machineNoController.text.trim());
        print("updateSendSqlite");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _getProcessStart() async {
    try {
      var sql_processSheet = await databaseHelper.queryDataSelectProcess(
        select1: 'Machine'.trim(),
        select2: 'OperatorName'.trim(),
        select3: 'BatchNo'.trim(),
        select4: 'Garbage'.trim(),
        formTable: 'PROCESS_SHEET'.trim(),
        where: 'Machine'.trim(),
        stringValue: machineNoController.text.trim(),
      );
      print(sql_processSheet.length);

      // if (sql_processSheet[0]['Machine'] != MachineController.text.trim()) {
      if (sql_processSheet.isEmpty) {
        print(machineNoController.text.trim());
        print(sql_processSheet.length);
        if (sql_processSheet.isEmpty) {
          print("if");
          setState(() {
            _checkSendSqlite = true;
          });
          _saveSendSqlite();
        } else {
          setState(() {
            _checkSendSqlite = false;
          });
          print("else");
        }
      }
      return true;
    } catch (e) {
      print("Catch : ${e}");
      return false;
    }
  }

  void _saveSendSqlite() async {
    try {
      await databaseHelper.insertSqlite('PROCESS_SHEET', {
        'Machine': machineNoController.text.trim(),
        'OperatorName1': rejectQtyController.text.trim(),
        'BatchNo': int.tryParse(batchNoController.text.trim()),
        'RejectQty': rejectQtyController.text.trim(),
        'StartEnd': DateTime.now().toString(),
      });
      print("ok");
    } catch (e) {
      print(e);
    }
  }
}
