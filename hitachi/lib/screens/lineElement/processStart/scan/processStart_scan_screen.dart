// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously

import 'package:dotted_line/dotted_line.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hitachi/appdata.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/blocs/materialTrace/update_material_trace_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/processModel.dart';
import 'package:hitachi/models/combobox/comboboxSqliteModel.dart';
import 'package:hitachi/models/materialTraces/materialTraceUpdateModel.dart';
import 'package:hitachi/models/processCheck/processCheckModel.dart';
import 'package:hitachi/models/processStart/processInputModel.dart';
import 'package:hitachi/models/processStart/processOutputModel.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:hitachi/widget/alertSnackBar.dart';
import 'package:hitachi/widget/custom_textinput.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
  final TextEditingController _clearing_visualControlController =
      TextEditingController();
  final TextEditingController _clearingVoltageController =
      TextEditingController();
  final TextEditingController _missingRatioController = TextEditingController();
  final TextEditingController _filingLevelController = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<ComboboxSqliteModel> combolist = [];
  List<ComboboxSqliteModel> combolistForSD = [];
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
  final TextEditingController _zinckController = TextEditingController();
  final TextEditingController _visualControlController =
      TextEditingController();
  final TextEditingController _ipe_noController = TextEditingController();
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
  bool isLoading = true;
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
              print("ProcessStartLoadingState");
            }
            if (state is ProcessStartLoadedState) {
              isLoading = true;
              setState(() {});
              EasyLoading.dismiss();
              if (state.item.RESULT == true) {
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
                      _highVoltageController.clear();
                      _peakController.clear();
                      _ipe_noController.clear();
                      Navigator.pop(context);
                    });
                bgChange = Colors.grey;
                f1.requestFocus();
              } else if (state.item.RESULT == false) {
                EasyLoading.dismiss();

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
              EasyLoading.dismiss();
              setState(() {
                _enabledMachineNo = true;
                isLoading = true;
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
            if (state is GetIPEProdSpecByBatchLoadingState) {
            } else if (state is GetIPEProdSpecByBatchLoadedState) {
              if (state.item.I_PEAK != null && state.item.HIGH_VOLT != null) {
                _peakController.text = state.item.I_PEAK!;
                _highVoltageController.text = state.item.HIGH_VOLT!;
              }
              if (state.item.IPE_NO != null && state.item.IPE_NO != '') {
                _ipe_noController.text = state.item.IPE_NO!;
              }
              setState(() {});
            } else if (state is GetIPEProdSpecByBatchErrorState) {}
          },
        ),
        BlocListener<UpdateMaterialTraceBloc, UpdateMaterialTraceState>(
            listener: (context, state) async {
          if (state is UpdateMaterialTraceLoadingState) {
            print("UpdateMaterialCheck");
          } else if (state is UpdateMaterialTraceLoadedState) {
            setState(() {
              isLoading = false;
            });
            // print("UpdateMaterialCheckSuccess");
            BlocProvider.of<LineElementBloc>(context).add(
              GetIPEProdSpecByBatchEvent(
                batchNoController.text.trim(),
              ),
            );

            EasyLoading.dismiss();
          } else if (state is UpdateMaterialTraceErrorState) {
            EasyLoading.dismiss();
            setState(() {
              isLoading = false;
            });
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
                        if (value.toUpperCase() == 'SD') {
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
          'visualControl_v': _clearing_visualControlController.text.trim(),
          'visualControl': _visualControlController.text.trim(),
          'clearingVoltage': _clearingVoltageController.text.trim(),
          'MissingRatio': _missingRatioController.text.trim(),
          'FilingLevel': _filingLevelController.text.trim(),
          'ZinckThickness': _zinckController.text.trim()
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

  // _serachInGetProd() async {
  //   try {
  //     var batch = await DatabaseHelper()
  //         .queryIPESHEET('IPE_SHEET', [batchNoController.text.trim()]);
  //     TextEditingController _ipeController = TextEditingController();
  //     print(batch);

  //     if (batch.isNotEmpty) {
  //       for (var item in batch) {
  //         _ipeController.text = item['IPE_NO'];
  //       }
  //     }
  //     if (_ipeController.text.isNotEmpty) {
  //       var itemInProd =
  //           await DatabaseHelper().queryPRODSPEC([_ipeController.text.trim()]);
  //       print(itemInProd);

  //       if (itemInProd.isNotEmpty) {
  //         for (var item in itemInProd) {
  //           _highVoltageController.text =
  //               double.parse(item['HighVolt']).toInt().toString();
  //           _peakController.text =
  //               double.parse(item['Ipeak']).toInt().toString();
  //         }
  //       }
  //     }
  //     setState(() {});
  //   } catch (e, s) {
  //     print(e);
  //     print(s);
  //   }
  // }

  void _btnSend() async {
    if (MachineController.text.isNotEmpty &&
        operatorNameController.text.isNotEmpty &&
        batchNoController.text.isNotEmpty) {
      _highVoltageController.clear();
      _peakController.clear();
      _ipe_noController.clear();

      BlocProvider.of<LineElementBloc>(context).add(
        GetIPEProdSpecByBatchEvent(
          batchNoController.text.trim(),
        ),
      );
      var sql1 = await DatabaseHelper()
          .queryMasterlotProcess(MachineController.text.trim().toUpperCase());
      if (MachineController.text.length >= 2) {
        if (MachineController.text.substring(0, 2).toUpperCase() == 'HV' &&
            sql1.isNotEmpty) {
          try {
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
                          // onChanged: (value) {
                          //   _peakController.text = value;
                          // },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            num? intValue = num.tryParse(value);
                            if (intValue == null ||
                                intValue < 100 ||
                                intValue > 200) {
                              return 'Value 100-200';
                            } else {
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
                          onChanged: (value) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            num? intValue = num.tryParse(value);
                            if (intValue == null ||
                                intValue < 600 ||
                                intValue > 1500) {
                              return 'Value 600-1500';
                            } else {
                              return null;
                            }
                          },
                        )
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(COLOR_RED)),
                          onPressed: () {
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
                            if (isLoading == true) {
                              if (sql1.isNotEmpty) {
                                for (var itemMasterLOT in sql1) {
                                  BlocProvider.of<UpdateMaterialTraceBloc>(context)
                                      .add(PostUpdateMaterialTraceEvent(
                                          MaterialTraceUpdateModel(
                                              DATE: DateTime.now().toString(),
                                              MATERIAL:
                                                  itemMasterLOT['Material'] ??
                                                      "",
                                              LOT: itemMasterLOT['Lot']
                                                  .toString(),
                                              PROCESS:
                                                  itemMasterLOT['PROCESS'] ??
                                                      "",
                                              IPE_NO:
                                                  _ipe_noController.text.trim(),
                                              I_PEAK: int.tryParse(
                                                  _peakController.text),
                                              HIGH_VOLT: int.tryParse(
                                                  _highVoltageController.text),
                                              OPERATOR:
                                                  operatorNameController.text,
                                              BATCH_NO: batchNoController.text
                                                  .trim()),
                                          "Process"));

                                  await Future.delayed(
                                      Duration(milliseconds: 300));
                                }

                                await _callAPI();
                                isLoading = true;
                                setState(() {});
                                Navigator.pop(context);
                              } else {
                                AlertSnackBar.show(
                                    title: 'MasterLot Invalid',
                                    message: 'Please Input MasterLot',
                                    type: AlertType.error,
                                    duration: const Duration(seconds: 5));
                              }

                              EasyLoading.dismiss();
                            } else {
                              Navigator.pop(context);
                              EasyLoading.showError("Please Reload Page");
                            }
                          },
                          child: Label("OK", color: COLOR_WHITE))
                    ],
                  );
                });
          } catch (e) {
            EasyLoading.showInfo("$e");
          }
        } else if (MachineController.text.substring(0, 2).toUpperCase() !=
                'HV' &&
            MachineController.text.substring(0, 2).toUpperCase() != 'TM') {
          if (sql1.isNotEmpty) {
            for (var itemMasterLOT in sql1) {
              BlocProvider.of<UpdateMaterialTraceBloc>(context).add(
                  PostUpdateMaterialTraceEvent(
                      MaterialTraceUpdateModel(
                          DATE: DateTime.now().toString(),
                          MATERIAL: itemMasterLOT['Material'].toString(),
                          IPE_NO: null,
                          LOT: itemMasterLOT['Lot'].toString(),
                          PROCESS: itemMasterLOT['PROCESS'].toString(),
                          I_PEAK: null,
                          HIGH_VOLT: null,
                          OPERATOR: operatorNameController.text,
                          BATCH_NO: batchNoController.text.trim()),
                      "Process"));
            }
          }
          _callAPI();
        } else {
          _callAPI();
        }
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

  Future _getDropdownList(String type) async {
    if (type == 'ZN') {
      combolist.clear();
      combolistForSD.clear();
      var sql = await DatabaseHelper().queryDropdown(['Visual_Inspection']);

      var zincSql =
          await DatabaseHelper().queryBatch(batchNoController.text.trim());
      if (sql.isNotEmpty) {
        combolist = sql.map((e) => ComboboxSqliteModel.fromMap(e)).toList();
      }
      if (zincSql.isNotEmpty) {
        double totalSum = 0;

        for (var row in zincSql) {
          double thickness6 = double.tryParse(row['Thickness6'] ?? '0') ?? 0;
          double thickness7 = double.tryParse(row['Thickness7'] ?? '0') ?? 0;
          double thickness8 = double.tryParse(row['Thickness8'] ?? '0') ?? 0;
          double thickness9 = double.tryParse(row['Thickness9'] ?? '0') ?? 0;

          double average =
              (thickness6 + thickness7 + thickness8 + thickness9) / 4;
          totalSum += average;
        }

        _zinckController.text = totalSum.toStringAsFixed(2);
      } else {
        _zinckController.text = '0.5';
      }
    } else if (type == "CR") {
      combolist.clear();
      combolistForSD.clear();
      var sql = await DatabaseHelper()
          .queryDropdown(['Visual_Inspection', 'Clearing_Voltage']);

      if (sql.isNotEmpty) {
        combolist = sql.map((e) => ComboboxSqliteModel.fromMap(e)).toList();
      }
    } else if (type == 'SD') {
      combolist.clear();
      combolistForSD.clear();
      var sqlClearing =
          await DatabaseHelper().queryDropdown(['Clearing_Voltage']);
      var sqlVisual =
          await DatabaseHelper().queryDropdown(['Visual_Inspection']);
      print(sqlClearing.length);
      if (sqlClearing.isNotEmpty) {
        combolist =
            sqlClearing.map((e) => ComboboxSqliteModel.fromMap(e)).toList();
        combolistForSD =
            sqlVisual.map((e) => ComboboxSqliteModel.fromMap(e)).toList();
      }
    } else if (type == 'PU') {
      combolist.clear();
      combolistForSD.clear();
      var sql = await DatabaseHelper().queryDropdown(['Visual_Inspection']);
      if (sql.isNotEmpty) {
        combolist = sql.map((e) => ComboboxSqliteModel.fromMap(e)).toList();
      }
    }
    setState(() {});
  }

  void _clearDataNew() async {
    try {
      _zinckController.clear();
      _visualControlController.clear();
      _clearingVoltageController.clear();
      _missingRatioController.clear();
      _filingLevelController.clear();
      _clearing_visualControlController.clear();
    } catch (e) {
      print(e);
    }
  }

  void _clearAllData() async {
    try {
      MachineController.text = "";
      operatorNameController.text = "";
      batchNoController.text = "";

      _zinckController.clear();
      _visualControlController.clear();
      _clearingVoltageController.clear();
      _missingRatioController.clear();
      _filingLevelController.clear();
      _clearing_visualControlController.clear();
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
