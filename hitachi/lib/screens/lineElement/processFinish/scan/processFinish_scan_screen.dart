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
import 'package:intl/intl.dart';

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

  String StartEndValue = 'E';

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
              EasyLoading.dismiss();
              // EasyLoading.show(status: "Loaded");

              if (state.item.RESULT == true) {
                // EasyLoading.showSuccess("SendComplete");
                EasyLoading.dismiss();
                _errorDialog(
                    text: Label("${state.item.MESSAGE}"),
                    onpressOk: () async {
                      Navigator.pop(context);
                      await _getProcessStart();
                      machineNoController.clear();
                      operatorNameController.clear();
                      batchNoController.clear();
                      setState(() {
                        rejectQtyController.text = '0';
                      });
                    });
              } else if (state.item.RESULT == false) {
                // EasyLoading.dismiss();
                // EasyLoading.showError("Can not send & save Data");
                items = state.item;
                EasyLoading.dismiss();
                _errorDialog(
                    text: Label("${state.item.MESSAGE}"),
                    onpressOk: () async {
                      Navigator.pop(context);
                      await _getProcessStart();
                      machineNoController.clear();
                      operatorNameController.clear();
                      batchNoController.clear();
                      setState(() {
                        rejectQtyController.text = '0';
                      });
                    });
              } else {
                // EasyLoading.dismiss();
                // EasyLoading.showError("Can not Call API");
                EasyLoading.dismiss();
                _errorDialog(
                    text: Label("${state.item.MESSAGE}"),
                    onpressOk: () async {
                      Navigator.pop(context);
                      await _getProcessStart();
                      machineNoController.clear();
                      operatorNameController.clear();
                      batchNoController.clear();
                      setState(() {
                        rejectQtyController.text = '0';
                      });
                    });
              }
              f1.requestFocus();
            }
            if (state is ProcessFinishErrorState) {
              print("ERROR");
              // EasyLoading.dismiss();
              _getProcessStart();
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
                    type: TextInputType.number,
                    focusNode: f1,
                    onChanged: (value) {
                      if (machineNoController.text.isNotEmpty &&
                          operatorNameController.text.isNotEmpty &&
                          batchNoController.text.isNotEmpty &&
                          rejectQtyController.text.isNotEmpty) {
                        setState(() {
                          bgChange = COLOR_RED;
                        });
                      } else {
                        setState(() {
                          bgChange = Colors.grey;
                        });
                      }
                    },
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
                    onChanged: (value) {
                      if (machineNoController.text.isNotEmpty &&
                          operatorNameController.text.isNotEmpty &&
                          batchNoController.text.isNotEmpty &&
                          rejectQtyController.text.isNotEmpty &&
                          batchNoController.text.length == 12) {
                        setState(() {
                          bgChange = COLOR_RED;
                        });
                      } else {
                        setState(() {
                          bgChange = Colors.grey;
                        });
                      }
                    },
                    maxLength: 12,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^(?!.*\d{12})[a-zA-Z0-9]+$'),
                      ),
                    ],
                    onEditingComplete: () {
                      setState(() {
                        f3.requestFocus();
                      });
                      // if (operatorNameController.text.length == 12) {
                      //   setState(() {
                      //     f3.requestFocus();
                      //   });
                      // } else {
                      //   setState(() {
                      //     valuetxtinput = "User INVALID";
                      //   });
                      // }
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
                      } else {
                        setState(() {
                          valuetxtinput = "Batch No : INVALID";
                        });
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
                          operatorNameController.text.isNotEmpty &&
                          batchNoController.text.isNotEmpty &&
                          rejectQtyController.text.isNotEmpty) {
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
                    onChanged: (value) {
                      if (machineNoController.text.isNotEmpty &&
                          operatorNameController.text.isNotEmpty &&
                          batchNoController.text.isNotEmpty &&
                          rejectQtyController.text.isNotEmpty) {
                        setState(() {
                          bgChange = COLOR_RED;
                        });
                      } else {
                        setState(() {
                          bgChange = Colors.grey;
                        });
                      }
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
        FINISHDATE:
            DateFormat('yyyy MM dd HH:mm:ss').format(DateTime.now()).toString(),
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
            key4: 'FinDate',
            yieldKey4: DateFormat('yyyy MM dd HH:mm:ss')
                .format(DateTime.now())
                .toString(),
            whereKey: 'Machine',
            value: machineNoController.text.trim());
        print("updateSendSqlite");
      }
    } catch (e) {
      print(e);
    }
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
      print(machineNoController.text.trim());
      print(sql_processSheet.length);
      if (sql_processSheet.isEmpty) {
        print("if");
        // setState(() {
        _checkSendSqlite = true;
        print("_checkSendSqlite = true;");
        _saveSendSqlite();
        // });
      } else {
        // setState(() {
        _checkSendSqlite = false;
        print("_checkSendSqlite = false;");
        _updateSendSqlite();
        // });
        print("else");
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
        'OperatorName1': operatorNameController.text.trim(),
        'BatchNo': int.tryParse(batchNoController.text.trim()),
        'Garbage': rejectQtyController.text.trim(),
        'FinDate':
            DateFormat('yyyy MM dd HH:mm:ss').format(DateTime.now()).toString(),
        'StartEnd': StartEndValue.toString(),
      });
      print("ok");
    } catch (e) {
      print(e);
    }
  }
}
