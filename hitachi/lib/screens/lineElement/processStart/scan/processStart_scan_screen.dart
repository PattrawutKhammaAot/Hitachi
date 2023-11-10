// ignore_for_file: unrelated_type_equality_checks

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/blocs/materialTrace/update_material_trace_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/processModel.dart';
import 'package:hitachi/models/materialTraces/materialTraceUpdateModel.dart';
import 'package:hitachi/models/processStart/processInputModel.dart';
import 'package:hitachi/models/processStart/processOutputModel.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:hitachi/widget/custom_textinput.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ProcessStartScanScreen extends StatefulWidget {
  ProcessStartScanScreen({super.key, this.onChange});
  ValueChanged<List<Map<String, dynamic>>>? onChange;

  @override
  State<ProcessStartScanScreen> createState() => _ProcessStartScanScreenState();
}

class _ProcessStartScanScreenState extends State<ProcessStartScanScreen> {
  final TextEditingController MachineController = TextEditingController();
  final TextEditingController operatorNameController = TextEditingController();
  final TextEditingController operatorName1Controller = TextEditingController();
  final TextEditingController operatorName2Controller = TextEditingController();
  final TextEditingController operatorName3Controller = TextEditingController();
  final TextEditingController batchNoController = TextEditingController();
  final TextEditingController _peakController = TextEditingController();
  final TextEditingController _highVoltageController = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();

  ProcessInputModel? items;

  List<ProcessModel>? processList;
  bool _enabledMachineNo = true;
  bool _enabledOperator = false;
  bool _enabledCheckMachine = false;
  bool _checkSendSqlite = false;
  String Focustxt = "";
  String valuetxtinput = "";
  Color? bgChange;
  DateTime startDate = DateTime.now();
  String StartEndValue = 'S';

  bool isShowHv = false;
  final f1 = FocusNode();
  final f2 = FocusNode();
  final f3 = FocusNode();
  final f4 = FocusNode();
  final f5 = FocusNode();
  final f6 = FocusNode();
  final _p1 = FocusNode();
  final _p2 = FocusNode();
  final _formKey = GlobalKey<FormState>();
  Future<bool> _getProcessStart() async {
    try {
      var sql_processSheet = await databaseHelper.queryDataSelectProcess(
        select1: 'Machine'.trim(),
        select2: 'OperatorName'.trim(),
        select3: 'OperatorName1'.trim(),
        select4: 'OperatorName2'.trim(),
        select5: 'OperatorName3'.trim(),
        select6: 'BatchNo'.trim(),
        formTable: 'PROCESS_SHEET'.trim(),
        where: 'Machine'.trim(),
        stringValue: MachineController.text.trim(),
        keyAnd: 'BatchNo'.trim(),
        value: batchNoController.text.trim(),
      );

      if (sql_processSheet.isEmpty) {
        // setState(() {
        _checkSendSqlite = true;

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

  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('PROCESS_SHEET');
    setState(() {
      widget.onChange
          ?.call(sql.where((element) => element['StartEnd'] == 'S').toList());
    });
  }

  @override
  void initState() {
    super.initState();
    f1.requestFocus();
    _getHold();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LineElementBloc, LineElementState>(
          listener: (context, state) {
            if (state is ProcessStartLoadingState) {
              EasyLoading.show(status: "Loading...");
              print("loading");
            }
            if (state is ProcessStartLoadedState) {
              print("Loaded");
              EasyLoading.dismiss();
              // EasyLoading.show(status: "Loaded");
              if (state.item.RESULT == true) {
                // EasyLoading.showSuccess("SendComplete");
                EasyLoading.dismiss();
                _errorDialog(
                    text: Label("${state.item.MESSAGE}"),
                    isHideCancle: false,
                    onpressOk: () async {
                      MachineController.clear();
                      operatorNameController.clear();
                      operatorName1Controller.clear();
                      operatorName2Controller.clear();
                      operatorName3Controller.clear();
                      batchNoController.clear();
                      Navigator.pop(context);
                    });
                bgChange = Colors.grey;
                f1.requestFocus();
              } else if (state.item.RESULT == false) {
                // EasyLoading.showError("Can not send & save Data");
                EasyLoading.dismiss();
                items = state.item;
                _errorDialog(
                    text: Label(
                        "${state.item.MESSAGE ?? "CheckConnection\n Do you want to Save"}"),
                    onpressOk: () async {
                      Navigator.pop(context);

                      await _getProcessStart();
                      MachineController.clear();
                      operatorNameController.clear();
                      operatorName1Controller.clear();
                      operatorName2Controller.clear();
                      operatorName3Controller.clear();
                      batchNoController.clear();
                      await _getHold();
                    });
              } else {
                EasyLoading.dismiss();
                // EasyLoading.showError("Can not Call API");
                _errorDialog(
                    text: Label(
                        "${state.item.MESSAGE ?? "CheckConnection\n Do you want to Save"}"),
                    onpressOk: () async {
                      Navigator.pop(context);
                      await _getProcessStart();
                      MachineController.clear();
                      operatorNameController.clear();
                      operatorName1Controller.clear();
                      operatorName2Controller.clear();
                      operatorName3Controller.clear();
                      batchNoController.clear();
                      await _getHold();
                    });
              }
              f1.requestFocus();
            }
            if (state is ProcessStartErrorState) {
              print("ERROR");
              EasyLoading.dismiss();
              setState(() {
                _enabledMachineNo = true;
              });
              _errorDialog(
                  text: Label("CheckConnection\n Do you want to Save"),
                  // isHideCancle: false,
                  onpressOk: () async {
                    Navigator.pop(context);
                    await _getProcessStart();
                    await _getHold();
                  });

              f1.requestFocus();
            }
          },
        ),
        BlocListener<UpdateMaterialTraceBloc, UpdateMaterialTraceState>(
            listener: (context, state) async {
          if (state is UpdateMaterialTraceLoadingState) {
            EasyLoading.show(status: "Loading ...");
            print("UpdateMaterialCheck");
          } else if (state is UpdateMaterialTraceLoadedState) {
            EasyLoading.dismiss();
            print("UpdateMaterialCheckSuccess");
            _highVoltageController.clear();
            _peakController.clear();
          } else if (state is UpdateMaterialTraceErrorState) {
            EasyLoading.dismiss();
          }
        })
      ],
      child: Form(
        key: _formKey,
        child: BgWhite(
            isHideAppBar: true,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    RowBoxInputField(
                      labelText: "Machine No :",
                      maxLength: 3,
                      controller: MachineController,
                      height: 35,
                      focusNode: f1,
                      // enabled: _enabledMachineNo,
                      onEditingComplete: () {
                        if (MachineController.text.length > 2) {
                          setState(() {
                            print(MachineController.text);
                            _enabledMachineNo = false;
                            // valuetxtinput = MachineController.text.trim();
                            valuetxtinput = "";
                          });
                          f2.requestFocus();
                        } else {
                          setState(() {
                            _enabledCheckMachine = false;
                            valuetxtinput = "Machine No : INVALID";
                          });
                        }
                      },
                      // onEditingComplete: () => f2.requestFocus(),
                      onChanged: (value) {
                        if (value == 'SD' && value.length == 2 ||
                            value == 'sd' && value.length == 2) {
                          setState(() {
                            _enabledOperator = true;
                            isShowHv = false;
                            // _enabled = !_enabled;
                          });
                        } else if (value.length == 1) {
                          setState(() {
                            _enabledOperator = false;
                            isShowHv = false;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    RowBoxInputField(
                      labelText: "Operator Name :",
                      height: 35,
                      controller: operatorNameController,
                      maxLength: 12,
                      focusNode: f2,
                      // enabled: _enabledCheckMachine,
                      onEditingComplete: () {
                        if (operatorNameController.text.isNotEmpty) {
                          setState(() {
                            if (_enabledOperator == true) {
                              f3.requestFocus();
                            } else {
                              f6.requestFocus();
                            }
                            valuetxtinput = "";
                          });
                        } else {
                          setState(() {
                            valuetxtinput = "Operator Name : User INVALID";
                          });
                        }
                      },
                      type: TextInputType.number,
                      textInputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      onChanged: (value) {
                        if (MachineController.text.isNotEmpty &&
                            batchNoController.text.isNotEmpty) {
                          setState(() {
                            bgChange = COLOR_BLUE_DARK;
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
                    DottedLine(),
                    SizedBox(
                      height: 5,
                    ),
                    RowBoxInputField(
                      labelText: "Operator Name :",
                      height: 35,
                      maxLength: 12,
                      controller: operatorName1Controller,
                      focusNode: f3,
                      enabled: _enabledOperator,
                      onEditingComplete: () => f4.requestFocus(),
                      type: TextInputType.number,
                      textInputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    RowBoxInputField(
                      labelText: "Operator Name :",
                      height: 35,
                      maxLength: 12,
                      controller: operatorName2Controller,
                      focusNode: f4,
                      enabled: _enabledOperator,
                      onEditingComplete: () => f5.requestFocus(),
                      type: TextInputType.number,
                      textInputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    RowBoxInputField(
                      labelText: "Operator Name :",
                      height: 35,
                      maxLength: 12,
                      controller: operatorName3Controller,
                      focusNode: f5,
                      enabled: _enabledOperator,
                      onEditingComplete: () => f6.requestFocus(),
                      type: TextInputType.number,
                      textInputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    DottedLine(),
                    SizedBox(
                      height: 5,
                    ),
                    RowBoxInputField(
                      labelText: "Batch No :",
                      maxLength: 12,
                      height: 35,
                      onEditingComplete: () async {
                        if (batchNoController.text.length == 12) {
                          _btnSend();
                          valuetxtinput = "";
                        } else {
                          setState(() {
                            valuetxtinput = "Batch No : INVALID";
                          });
                        }
                      },
                      controller: batchNoController,
                      type: TextInputType.number,
                      focusNode: f6,
                      textInputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      onChanged: (value) {
                        if (batchNoController.text.length == 12 &&
                            operatorNameController.text.isNotEmpty) {
                          setState(() {
                            bgChange = COLOR_BLUE_DARK;
                          });
                        } else {
                          setState(() {
                            bgChange = Colors.grey;
                          });
                        }
                      },
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
                            " ${valuetxtinput}",
                            color: COLOR_RED,
                          )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Button(
                        height: 40,
                        bgColor: bgChange ?? Colors.grey,
                        text: Label(
                          "Send",
                          color: COLOR_WHITE,
                        ),
                        onPress: () => _btnSend(),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void _saveSendSqlite() async {
    try {
      if (operatorNameController.text.isNotEmpty) {
        await databaseHelper.insertSqlite('PROCESS_SHEET', {
          'Machine': MachineController.text.trim(),
          'OperatorName': operatorNameController.text.trim(),
          'OperatorName1': operatorName1Controller.text == null
              ? ""
              : operatorName1Controller.text.trim(),
          'OperatorName2': operatorName2Controller.text == null
              ? ""
              : operatorName2Controller.text.trim(),
          'OperatorName3': operatorName3Controller.text == null
              ? ""
              : operatorName3Controller.text.trim(),
          'BatchNo': batchNoController.text.trim(),
          'StartDate': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          'StartEnd': StartEndValue.toString(),
          'PeakCurrentWithstands': _peakController.text.trim(),
          'HighVoltageTest': _highVoltageController.text.trim(),
        });
        print("saveSendSqlite");
        setState(() {
          _clearAllData();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _updateSendSqlite() async {
    try {
      if (operatorNameController.text.isNotEmpty) {
        await databaseHelper.upDateProcessStart({
          'OperatorName': int.tryParse(operatorNameController.text.trim()),
          'OperatorName1': int.tryParse(operatorName1Controller.text.trim()),
          'OperatorName2':
              int.tryParse(operatorName2Controller.text.trim() ?? ""),
          'OperatorName3':
              int.tryParse(operatorName3Controller.text.trim() ?? ""),
          'BatchNo': batchNoController.text.trim(),
          'StartDate': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          'Machine': MachineController.text.trim(),
          'PeakCurrentWithstands': _peakController.text.trim(),
          'HighVoltageTest': _highVoltageController.text.trim(),
        }, MachineController.text, batchNoController.text).then((value) {
          _clearAllData();
          MachineController.clear();
        });

        print("updateSendSqlite");
      }
    } catch (e) {
      print(e);
    }
  }

  _serachInGetProd() async {
    try {
      var batch = await DatabaseHelper()
          .queryIPESHEET('IPE_SHEET', [batchNoController.text.trim()]);
      TextEditingController _ipeController = TextEditingController();
      print(batch);

      if (batch.isNotEmpty) {
        for (var item in batch) {
          _ipeController.text = item['IPE_NO'];
        }
      }
      if (_ipeController.text.isNotEmpty) {
        var itemInProd =
            await DatabaseHelper().queryPRODSPEC([_ipeController.text.trim()]);
        print(itemInProd);

        if (itemInProd.isNotEmpty) {
          for (var item in itemInProd) {
            _highVoltageController.text =
                double.parse(item['HighVolt']).toInt().toString();
            _peakController.text =
                double.parse(item['Ipeak']).toInt().toString();
          }
        }
      }
      setState(() {});
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  void _btnSend() async {
    if (MachineController.text.isNotEmpty &&
        operatorNameController.text.isNotEmpty &&
        batchNoController.text.isNotEmpty) {
      await _serachInGetProd();
      if (MachineController.text.toUpperCase().substring(0, 2) == 'HV') {
        bool peakValid = false;
        bool highValid = false;
        if (_peakController.text.isNotEmpty) {
          peakValid = true;
        }
        if (_highVoltageController.text.isNotEmpty) {
          highValid = true;
        }

        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Label('Final Test'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder(
                      future: Future.delayed(Duration
                          .zero), // ใช้ Future.delayed เพื่อทำให้โฟกัสทันที
                      builder: (context, snapshot) {
                        _p1.requestFocus(); // Focus ที่ _p1Focus
                        return SizedBox
                            .shrink(); // ไม่มีการแสดงผลในระหว่างการรอ Future.delayed
                      },
                    ),
                    CustomTextInputField(
                      controller: _peakController,
                      focusNode: _p1,
                      keyboardType: TextInputType.number,
                      isHideLable: true,
                      onFieldSubmitted: (value) {
                        if (value.isNotEmpty) {
                          _p2.requestFocus();
                        }
                      },
                      textInputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                      ],
                      labelText: "Peak Current WithStands",
                      onChanged: (value) {
                        _peakController.text = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          peakValid = false;
                          return 'Please enter a value';
                        }

                        num? intValue = num.tryParse(value);
                        if (intValue == null ||
                            intValue < 100 ||
                            intValue > 200) {
                          peakValid = false;
                          return 'Please enter a value between 100-200';
                        } else {
                          peakValid = true;
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    CustomTextInputField(
                      controller: _highVoltageController,
                      focusNode: _p2,
                      keyboardType: TextInputType.number,
                      isHideLable: true,
                      textInputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                      ],
                      labelText: "High-Voltage Test",
                      onChanged: (value) {
                        _highVoltageController.text = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          highValid = false;
                          return 'Please enter a value';
                        }

                        num? intValue = num.tryParse(value);
                        if (intValue == null ||
                            intValue < 600 ||
                            intValue > 1500) {
                          highValid = false;
                          return 'Please enter a value between 600-1500';
                        } else {
                          highValid = true;
                          return null;
                        }
                      },
                    )
                  ],
                ),
                actions: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(COLOR_RED)),
                      onPressed: () {
                        _peakController.clear();
                        _highVoltageController.clear();
                        Navigator.pop(context);
                      },
                      child: Label(
                        "Cancel",
                        color: COLOR_WHITE,
                      )),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(COLOR_SUCESS)),
                      onPressed: () async {
                        if (highValid && peakValid) {
                          await _callAPI();
                          await callApiMatUp();
                          setState(() {
                            _enabledOperator = false;
                          });
                          Navigator.pop(context);
                        } else {
                          if (!highValid && peakValid) {
                            _p2.requestFocus();
                          } else if (!peakValid && highValid) {
                            _p1.requestFocus();
                          } else if (highValid == false && peakValid == false) {
                            _p1.requestFocus();
                          }
                          EasyLoading.showError("Please enter a valid value");
                        }
                      },
                      child: Label("OK", color: COLOR_WHITE))
                ],
              );
            });
      } else {
        _callAPI();
        setState(() {
          _enabledOperator = false;
        });
      }
    } else {
      EasyLoading.showInfo("กรุณาใส่ข้อมูลให้ครบ");
    }
  }

  Future _callAPI() async {
    BlocProvider.of<LineElementBloc>(context).add(
      ProcessStartEvent(ProcessOutputModel(
        MACHINE: MachineController.text.trim(),
        OPERATORNAME: int.tryParse(operatorNameController.text.trim()),
        OPERATORNAME1: int.tryParse(operatorName1Controller.text.trim()),
        OPERATORNAME2: int.tryParse(operatorName2Controller.text.trim()),
        OPERATORNAME3: int.tryParse(operatorName3Controller.text.trim()),
        BATCHNO: batchNoController.text.trim(),
        STARTDATE: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      )),
    );
  }

  Future callApiMatUp() async {
    var sql = await DatabaseHelper().queryAllRows('MASTERLOT');
    print(sql);
    if (sql.isNotEmpty) {
      for (var itemMasterLOT in sql) {
        BlocProvider.of<UpdateMaterialTraceBloc>(context).add(
            PostUpdateMaterialTraceEvent(
                MaterialTraceUpdateModel(
                    DATE: DateTime.now().toString(),
                    MATERIAL: itemMasterLOT['Material'].toString(),
                    LOT: itemMasterLOT['Lot'].toString(),
                    PROCESS: itemMasterLOT['PROCESS'].toString(),
                    I_PEAK: int.tryParse(_peakController.text),
                    HIGH_VOLT: int.tryParse(_highVoltageController.text),
                    OPERATOR: operatorNameController.text,
                    BATCH_NO: batchNoController.text.trim()),
                "Process"));
      }
    }
  }

  void _clearAllData() async {
    try {
      MachineController.text = "";
      operatorNameController.text = "";
      operatorName1Controller.text = "";
      operatorName2Controller.text = "";
      operatorName3Controller.text = "";
      batchNoController.text = "";
      MachineController.clear();
      _peakController.clear();
      _highVoltageController.clear();
    } catch (e) {
      print(e);
    }
  }

  void _errorDialog(
      {Label? text,
      Function? onpressOk,
      Function? onpressCancel,
      bool isHideCancle = true}) async {
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

        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: isHideCancle,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(COLOR_BLUE_DARK)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              Visibility(
                visible: isHideCancle,
                child: SizedBox(
                  width: 15,
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(COLOR_BLUE_DARK)),
                onPressed: () => onpressOk?.call(),
                child: const Text('OK'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
