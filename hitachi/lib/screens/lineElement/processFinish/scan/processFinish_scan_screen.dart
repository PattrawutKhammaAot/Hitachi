// ignore_for_file: use_build_context_synchronously

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/combobox/comboboxModel.dart';
import 'package:hitachi/models/combobox/comboboxSqliteModel.dart';
import 'package:hitachi/models/processCheck/processCheckModel.dart';
import 'package:hitachi/models/processFinish/processFinishInputModel.dart';
import 'package:hitachi/models/processFinish/processFinishOutput.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:hitachi/widget/custom_textinput.dart';
import 'package:intl/intl.dart';

class ProcessFinishScanScreen extends StatefulWidget {
  ProcessFinishScanScreen({super.key, this.onChange});
  ValueChanged<List<Map<String, dynamic>>>? onChange;

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
  final TextEditingController _zinckController = TextEditingController();
  final TextEditingController _visualControlController =
      TextEditingController();
  final TextEditingController _clearing_visualControlController =
      TextEditingController();
  final TextEditingController _clearingVoltageController =
      TextEditingController();
  final TextEditingController _missingRatioController = TextEditingController();
  final TextEditingController _filingLevelController = TextEditingController();

  String valuetxtinput = "";
  Color? bgChange;
  bool _checkSendSqlite = false;
  List<ComboboxSqliteModel> combolist = [];
  List<ComboboxSqliteModel> combolistForSD = [];

  final f1 = FocusNode();
  final f2 = FocusNode();
  final f3 = FocusNode();
  final f4 = FocusNode();
  final f5 = FocusNode();
  final f6 = FocusNode();

  String StartEndValue = 'E';

  @override
  void initState() {
    rejectQtyController.text = "0";
    super.initState();
    f1.requestFocus();
    _getHold();
  }

  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('PROCESS_SHEET');
    setState(() {
      widget.onChange
          ?.call(sql.where((element) => element['StartEnd'] == 'E').toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LineElementBloc, LineElementState>(
          listener: (context, state) {
            if (state is ProcessFinishLoadingState) {
              EasyLoading.show(status: "Loading...");

              print("isCallSendFinish");
            }
            if (state is ProcessFinishLoadedState) {
              EasyLoading.dismiss();
              // EasyLoading.show(status: "Loaded");

              if (state.item.RESULT == true) {
                EasyLoading.dismiss();
                _errorDialog(
                    text: Label("${state.item.MESSAGE}"),
                    isHideCancle: false,
                    onpressOk: () async {
                      Navigator.pop(context);
                      machineNoController.clear();
                      operatorNameController.clear();
                      batchNoController.clear();
                      setState(() {
                        rejectQtyController.text = '0';
                      });
                    });
              } else if (state.item.RESULT == false) {
                items = state.item;
                EasyLoading.dismiss();
                _errorDialog(
                    text: Label(
                        "${state.item.MESSAGE ?? "CheckConnection\n Do you want to Save"}"),
                    onpressOk: () async {
                      Navigator.pop(context);
                      await _getProcessStart();
                      machineNoController.clear();
                      operatorNameController.clear();
                      batchNoController.clear();
                      await _getHold();
                      setState(() {
                        rejectQtyController.text = '0';
                      });
                    });
              } else {
                print("Error Connection Internet");
                EasyLoading.dismiss();
                _errorDialog(
                    text: Label(
                        "${state.item.MESSAGE ?? "CheckConnection\n Do you want to Save"}"),
                    onpressOk: () async {
                      Navigator.pop(context);
                      await _getProcessStart();
                      machineNoController.clear();
                      operatorNameController.clear();
                      batchNoController.clear();
                      await _getHold();
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

              _errorDialog(
                  text: Label("CheckConnection\n Do you want to Save"),
                  onpressOk: () async {
                    Navigator.pop(context);
                    await _getProcessStart();
                    await _getHold();
                  });
            }
            if (state is ProcessCheckLoadingState) {
              print("isCallProcessCheck");
              // EasyLoading.show(status: "Loading ...");
            } else if (state is ProcessCheckLoadedState) {
              // if (state.item.RESULT == true) {
              //   f1.requestFocus();
              //   _clearAllData();
              //   setState(() {
              //     rejectQtyController.text = '0';
              //   });
              // } else {
              //   EasyLoading.showError(state.item.MESSAGE ?? "Exception");
              // }
            } else if (state is ProcessCheckErrorState) {
              EasyLoading.dismiss();
              // _errorDialog(
              //     text: Label("CheckConnection\n Do you want to Save"),
              //     onpressOk: () async {
              //       Navigator.pop(context);
              //       await _getProcessStart();
              //       machineNoController.clear();
              //       operatorNameController.clear();
              //       batchNoController.clear();
              //       await _getHold();
              //       setState(() {
              //         rejectQtyController.text = '0';
              //       });
              //       f1.requestFocus();
              //     });
            }
          },
        )
      ],
      child: BgWhite(
          isHideAppBar: true,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  RowBoxInputField(
                    labelText: "Machine No : ",
                    maxLength: 3,
                    controller: machineNoController,
                    // type: TextInputType.number,
                    focusNode: f1,
                    onChanged: (value) {
                      if (machineNoController.text.isNotEmpty &&
                          operatorNameController.text.isNotEmpty &&
                          batchNoController.text.isNotEmpty &&
                          rejectQtyController.text.isNotEmpty) {
                        setState(() {
                          bgChange = COLOR_BLUE_DARK;
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
                        valuetxtinput = " ";
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
                          bgChange = COLOR_BLUE_DARK;
                        });
                      } else {
                        setState(() {
                          bgChange = Colors.grey;
                        });
                      }
                    },
                    maxLength: 12,
                    type: TextInputType.number,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    onEditingComplete: () {
                      if (operatorNameController.text.isNotEmpty) {
                        setState(() {
                          f3.requestFocus();
                          valuetxtinput = " ";
                        });
                      } else {
                        setState(() {
                          valuetxtinput = "Operator Name : User INVALID";
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
                        setState(() {
                          valuetxtinput = "";
                        });
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
                                "Must not start with WD because it has been through Winding.";
                          });
                        }
                      }
                      if (machineNoController.text.isNotEmpty &&
                          operatorNameController.text.isNotEmpty &&
                          batchNoController.text.length == 12 &&
                          rejectQtyController.text.isNotEmpty) {
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
                  RowBoxInputField(
                    labelText: "Reject Qty : ",
                    controller: rejectQtyController,
                    focusNode: f4,
                    type: TextInputType.number,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    onEditingComplete: () => _btnSend(),
                    onChanged: (value) {
                      if (machineNoController.text.isNotEmpty &&
                          operatorNameController.text.isNotEmpty &&
                          batchNoController.text.isNotEmpty &&
                          rejectQtyController.text.isNotEmpty) {
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

                    // onPress: () => _updateSendSqlite(),
                    // _updateSendSqlite()
                  ),
                ],
              ),
            ),
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

  void _btnSend() async {
    if (machineNoController.text.isNotEmpty &&
        operatorNameController.text.isNotEmpty &&
        batchNoController.text.isNotEmpty) {
      if (machineNoController.text.length >= 2) {
        switch (machineNoController.text.toUpperCase().trim().substring(0, 2)) {
          case 'ZN':
            try {
              await _getDropdownList('ZN');
              if (combolist.isNotEmpty) {
                _visualControlController.text = combolist
                        .firstWhere((element) => element.VALUEMEMBER == 'G')
                        .VALUEMEMBER ??
                    "G";
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Label('Zinc'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FutureBuilder(
                              future: Future.delayed(Duration
                                  .zero), // ใช้ Future.delayed เพื่อทำให้โฟกัสทันที
                              builder: (context, snapshot) {
                                f5.requestFocus();
                                return SizedBox
                                    .shrink(); // ไม่มีการแสดงผลในระหว่างการรอ Future.delayed
                              },
                            ),
                            CustomTextInputField(
                              focusNode: f5,
                              controller: _zinckController,
                              keyboardType: TextInputType.number,
                              isHideLable: true,
                              onFieldSubmitted: (value) {
                                if (value.isNotEmpty) {}
                              },
                              textInputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]'))
                              ],
                              labelText: 'Zinc Thickness',
                              onChanged: (value) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Entry Value";
                                }

                                return null;
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 45,
                              child: DropdownButtonFormField2(
                                value: combolist.isNotEmpty
                                    ? combolist
                                            .firstWhere((element) =>
                                                element.VALUEMEMBER == 'G')
                                            .VALUEMEMBER ??
                                        "G"
                                    : null,
                                decoration: InputDecoration(
                                  labelText: "Visual Control",
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                isExpanded: true,
                                items: combolist
                                    .toList()
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.VALUEMEMBER,
                                          child: Text(
                                            "${item.VALUEMEMBER}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  _visualControlController.text = value ?? "G";
                                },
                                onSaved: (value) {
                                  print(value);
                                },
                                buttonStyleData: const ButtonStyleData(
                                  height: 50,
                                  padding: EdgeInsets.only(left: 20, right: 10),
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
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(COLOR_RED)),
                              onPressed: () {
                                _zinckController.clear();
                                _clearDataNew();
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
                              onPressed: () {
                                BlocProvider.of<LineElementBloc>(context).add(
                                  ProcessCheckEvent(ProcessCheckModel(
                                    BATCH_NO: batchNoController.text,
                                    IPE_NO: null,
                                    MC_NO: machineNoController.text,
                                    ZN_Thickness:
                                        num.tryParse(_zinckController.text),
                                    ZN_VC: _visualControlController.text,
                                    CR_VC: null,
                                    CR_Voltage: null,
                                    SD_VC: null,
                                    TM_Curve: null,
                                    TM_Time: null,
                                    PU_Ratio: null,
                                    PU_Level: null,
                                    HV_Peak_Current: null,
                                    HV_HighVolt: null,
                                    ME_C_AVG: null,
                                    ME_TGD_AVG: null,
                                    ME_Batch: null,
                                    ME_Serial: null,
                                    ME_Appearance: null,
                                    ME_Quality_Check: null,
                                  )),
                                );
                                _callAPI();
                                Navigator.pop(context);
                              },
                              child: Label("OK", color: COLOR_WHITE))
                        ],
                      );
                    });
              } else {
                EasyLoading.showInfo(
                    "Please Download Dropdown \n Menu dropdown Master");
              }
            } catch (e, s) {
              EasyLoading.showInfo("$e");
            }

            break;
          case 'CR':
            try {
              await _getDropdownList('CR');
              if (combolist.isNotEmpty) {
                _visualControlController.text = combolist
                        .firstWhere((element) => element.VALUEMEMBER == 'G')
                        .VALUEMEMBER ??
                    "G";
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Label('Clearing'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FutureBuilder(
                              future: Future.delayed(Duration
                                  .zero), // ใช้ Future.delayed เพื่อทำให้โฟกัสทันที
                              builder: (context, snapshot) {
                                f5.requestFocus();
                                return SizedBox
                                    .shrink(); // ไม่มีการแสดงผลในระหว่างการรอ Future.delayed
                              },
                            ),
                            SizedBox(
                              height: 45,
                              child: DropdownButtonFormField2(
                                decoration: InputDecoration(
                                  labelText: "Clearing Voltage",
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                isExpanded: true,
                                items: combolist
                                    .where((item) => item.VALUEMEMBER!
                                        .contains(RegExp(r'^\d+$')))
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.VALUEMEMBER,
                                          child: Text(
                                            "${item.VALUEMEMBER}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  _clearingVoltageController.text =
                                      value ?? '-';
                                },
                                onSaved: (value) {
                                  print(value);
                                },
                                buttonStyleData: const ButtonStyleData(
                                  height: 50,
                                  padding: EdgeInsets.only(left: 20, right: 10),
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
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 45,
                              child: DropdownButtonFormField2(
                                value: combolist
                                        .firstWhere((element) =>
                                            element.VALUEMEMBER == 'G')
                                        .VALUEMEMBER ??
                                    "G",
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: COLOR_RED),
                                  labelText: "Visual Control",
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                isExpanded: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == '' || value == null) {
                                    return 'Please Select Clearing Voltage';
                                  }
                                  return null;
                                },
                                items: combolist
                                    .toList()
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.VALUEMEMBER,
                                          child: Text(
                                            "${item.VALUEMEMBER}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  _visualControlController.text = value ?? "G";
                                },
                                onSaved: (value) {
                                  print(value);
                                },
                                buttonStyleData: const ButtonStyleData(
                                  height: 50,
                                  padding: EdgeInsets.only(left: 20, right: 10),
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
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(COLOR_RED)),
                              onPressed: () {
                                _zinckController.clear();
                                _clearDataNew();
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
                              onPressed: () {
                                if (_clearingVoltageController
                                        .text.isNotEmpty ||
                                    _clearingVoltageController.text != '') {
                                  BlocProvider.of<LineElementBloc>(context).add(
                                    ProcessCheckEvent(ProcessCheckModel(
                                      BATCH_NO: batchNoController.text,
                                      IPE_NO: null,
                                      MC_NO: machineNoController.text,
                                      ZN_Thickness: null,
                                      ZN_VC: null,
                                      CR_VC: _visualControlController.text,
                                      CR_Voltage: int.tryParse(
                                          _clearingVoltageController.text),
                                      SD_VC: null,
                                      TM_Curve: null,
                                      TM_Time: null,
                                      PU_Ratio: null,
                                      PU_Level: null,
                                      HV_Peak_Current: null,
                                      HV_HighVolt: null,
                                      ME_C_AVG: null,
                                      ME_TGD_AVG: null,
                                      ME_Batch: null,
                                      ME_Serial: null,
                                      ME_Appearance: null,
                                      ME_Quality_Check: null,
                                    )),
                                  );
                                  _callAPI();
                                  Navigator.pop(context);
                                } else {
                                  EasyLoading.showError(
                                      "Please select Clearing Voltage");
                                }
                              },
                              child: Label("OK", color: COLOR_WHITE))
                        ],
                      );
                    });
              } else {
                EasyLoading.showInfo(
                    "Please Download Dropdown \n Menu dropdown Master");
              }
            } catch (e, s) {
              EasyLoading.showError("$e");
            }
            break;
          case 'SD':
            try {
              await _getDropdownList('SD');
              if (combolist.isNotEmpty) {
                _visualControlController.text = combolistForSD
                        .firstWhere((element) => element.VALUEMEMBER == 'G')
                        .VALUEMEMBER ??
                    "G";

                _clearing_visualControlController.text = combolistForSD
                        .firstWhere((element) => element.VALUEMEMBER == 'G')
                        .VALUEMEMBER ??
                    "G";
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Label('Clearing'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FutureBuilder(
                              future: Future.delayed(Duration
                                  .zero), // ใช้ Future.delayed เพื่อทำให้โฟกัสทันที
                              builder: (context, snapshot) {
                                f5.requestFocus();
                                return SizedBox
                                    .shrink(); // ไม่มีการแสดงผลในระหว่างการรอ Future.delayed
                              },
                            ),
                            SizedBox(
                              height: 45,
                              child: DropdownButtonFormField2(
                                value: combolistForSD.isNotEmpty
                                    ? combolistForSD
                                            .firstWhere((element) =>
                                                element.VALUEMEMBER == 'G')
                                            .VALUEMEMBER ??
                                        "G"
                                    : null,
                                decoration: InputDecoration(
                                  labelText: "Visual Control",
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                isExpanded: true,
                                items: combolistForSD
                                    .toList()
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.VALUEMEMBER,
                                          child: Text(
                                            "${item.VALUEMEMBER}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  _clearing_visualControlController.text =
                                      value ?? "G";
                                },
                                onSaved: (value) {
                                  print(value);
                                },
                                buttonStyleData: const ButtonStyleData(
                                  height: 50,
                                  padding: EdgeInsets.only(left: 20, right: 10),
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
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 45,
                              child: DropdownButtonFormField2(
                                decoration: InputDecoration(
                                  labelText: "Clearing Voltage",
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                isExpanded: true,
                                items: combolist
                                    .where((item) => item.VALUEMEMBER!
                                        .contains(RegExp(r'^\d+$')))
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.VALUEMEMBER,
                                          child: Text(
                                            "${item.VALUEMEMBER}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  _clearingVoltageController.text =
                                      value ?? '-';
                                },
                                onSaved: (value) {
                                  print(value);
                                },
                                buttonStyleData: const ButtonStyleData(
                                  height: 50,
                                  padding: EdgeInsets.only(left: 20, right: 10),
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
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Label(
                                  "Solder",
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 45,
                              child: DropdownButtonFormField2(
                                value: combolistForSD.isNotEmpty
                                    ? combolistForSD
                                            .firstWhere((element) =>
                                                element.VALUEMEMBER == 'G')
                                            .VALUEMEMBER ??
                                        "G"
                                    : null,
                                decoration: InputDecoration(
                                  labelText: "Visual Control",
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                isExpanded: true,
                                items: combolistForSD
                                    .toList()
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.VALUEMEMBER,
                                          child: Text(
                                            "${item.VALUEMEMBER}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  _visualControlController.text = value ?? "G";
                                },
                                onSaved: (value) {
                                  print(value);
                                },
                                buttonStyleData: const ButtonStyleData(
                                  height: 50,
                                  padding: EdgeInsets.only(left: 20, right: 10),
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
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(COLOR_RED)),
                              onPressed: () {
                                _zinckController.clear();
                                _clearDataNew();
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
                              onPressed: () {
                                BlocProvider.of<LineElementBloc>(context).add(
                                  ProcessCheckEvent(ProcessCheckModel(
                                    BATCH_NO: batchNoController.text,
                                    IPE_NO: null,
                                    MC_NO: machineNoController.text,
                                    ZN_Thickness: null,
                                    ZN_VC: null,
                                    CR_VC:
                                        _clearing_visualControlController.text,
                                    CR_Voltage: int.tryParse(
                                        _clearingVoltageController.text),
                                    SD_VC: _visualControlController.text,
                                    TM_Curve: null,
                                    TM_Time: null,
                                    PU_Ratio: null,
                                    PU_Level: null,
                                    HV_Peak_Current: null,
                                    HV_HighVolt: null,
                                    ME_C_AVG: null,
                                    ME_TGD_AVG: null,
                                    ME_Batch: null,
                                    ME_Serial: null,
                                    ME_Appearance: null,
                                    ME_Quality_Check: null,
                                  )),
                                );
                                _callAPI();
                                Navigator.pop(context);
                              },
                              child: Label("OK", color: COLOR_WHITE))
                        ],
                      );
                    });
              } else {
                EasyLoading.showInfo(
                    "Please Download Dropdown \n Menu dropdown Master");
              }
            } catch (e, s) {
              EasyLoading.showInfo("$e");
            }
            break;
          case 'PU':
            try {
              await _getDropdownList('PU');
              if (combolist.isNotEmpty) {
                _filingLevelController.text = combolist
                        .firstWhere((element) => element.VALUEMEMBER == 'G')
                        .VALUEMEMBER ??
                    "G";
                _missingRatioController.text = '2.86 :1';
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Label('Pur'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FutureBuilder(
                              future: Future.delayed(Duration
                                  .zero), // ใช้ Future.delayed เพื่อทำให้โฟกัสทันที
                              builder: (context, snapshot) {
                                f5.requestFocus();
                                return SizedBox
                                    .shrink(); // ไม่มีการแสดงผลในระหว่างการรอ Future.delayed
                              },
                            ),
                            CustomTextInputField(
                              focusNode: f5,
                              controller: _missingRatioController,
                              keyboardType: TextInputType.number,
                              isHideLable: true,
                              onFieldSubmitted: (value) {
                                if (value.isNotEmpty) {}
                              },
                              textInputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]'))
                              ],
                              labelText: 'MissingRatio',
                              onChanged: (value) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Entry Value";
                                }

                                return null;
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 45,
                              child: DropdownButtonFormField2(
                                value: combolist
                                        .firstWhere((element) =>
                                            element.VALUEMEMBER == 'G')
                                        .VALUEMEMBER ??
                                    "G",
                                decoration: InputDecoration(
                                  labelText: "Filing Level",
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                isExpanded: true,
                                items: combolist
                                    .toList()
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.VALUEMEMBER,
                                          child: Text(
                                            "${item.VALUEMEMBER}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  _filingLevelController.text = value ?? "G";
                                },
                                onSaved: (value) {
                                  print(value);
                                },
                                buttonStyleData: const ButtonStyleData(
                                  height: 50,
                                  padding: EdgeInsets.only(left: 20, right: 10),
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
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(COLOR_RED)),
                              onPressed: () {
                                _zinckController.clear();
                                _clearDataNew();
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
                              onPressed: () {
                                BlocProvider.of<LineElementBloc>(context).add(
                                  ProcessCheckEvent(ProcessCheckModel(
                                    BATCH_NO: batchNoController.text,
                                    IPE_NO: null,
                                    MC_NO: machineNoController.text,
                                    ZN_Thickness: null,
                                    ZN_VC: null,
                                    CR_VC: null,
                                    CR_Voltage: null,
                                    SD_VC: null,
                                    TM_Curve: null,
                                    TM_Time: null,
                                    PU_Ratio: _missingRatioController.text,
                                    PU_Level: _filingLevelController.text,
                                    HV_Peak_Current: null,
                                    HV_HighVolt: null,
                                    ME_C_AVG: null,
                                    ME_TGD_AVG: null,
                                    ME_Batch: null,
                                    ME_Serial: null,
                                    ME_Appearance: null,
                                    ME_Quality_Check: null,
                                  )),
                                );
                                _callAPI();

                                Navigator.pop(context);
                              },
                              child: Label("OK", color: COLOR_WHITE))
                        ],
                      );
                    });
              } else {
                EasyLoading.showInfo(
                    "Please Download Dropdown \n Menu dropdown Master");
              }
            } catch (e, s) {
              EasyLoading.showInfo("$e");
            }
            break;
          default:
            _callAPI();
            break;
        }
      }
    } else {
      EasyLoading.showInfo("กรุณาใส่ข้อมูลให้ครบ");
    }
  }

  void _validatorBatch(String title,
      {String? labelText,
      String? errorText,
      String? contoller,
      String? type}) {}

  void _callAPI() {
    BlocProvider.of<LineElementBloc>(context).add(
      ProcessFinishInputEvent(ProcessFinishOutputModel(
        MACHINE: machineNoController.text.trim(),
        OPERATORNAME: int.tryParse(operatorNameController.text.trim()),
        BATCHNO: batchNoController.text.trim(),
        REJECTQTY: int.tryParse(rejectQtyController.text.trim()),
        FINISHDATE: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      )),
    );
  }

  void _clearAllData() async {
    try {
      machineNoController.text = "";
      operatorNameController.text = "";
      batchNoController.text = "";
      rejectQtyController.text = "";
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

  Future<bool> _getProcessStart() async {
    try {
      var sql_processSheet = await databaseHelper.queryProcessSF(
        select1: 'Machine'.trim(),
        select2: 'OperatorName'.trim(),
        select3: 'BatchNo'.trim(),
        select4: 'Garbage'.trim(),
        formTable: 'PROCESS_SHEET'.trim(),
        where: 'Machine'.trim(),
        stringValue: machineNoController.text.trim(),
        keyAnd: 'BatchNo'.trim(),
        value: batchNoController.text.trim(),
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

  void _updateSendSqlite() async {
    try {
      if (operatorNameController.text.isNotEmpty) {
        await databaseHelper
            .updateProcessFinish(
                table: 'PROCESS_SHEET',
                key1: 'OperatorName',
                yieldKey1: int.tryParse(operatorNameController.text.trim()),
                key2: 'BatchNo',
                yieldKey2: batchNoController.text.trim(),
                key3: 'Garbage',
                yieldKey3: rejectQtyController.text.trim(),
                key4: 'FinDate',
                yieldKey4:
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                key5: 'StartEnd'.trim(),
                yieldKey5: StartEndValue.trim(),
                whereKey: 'Machine',
                value: machineNoController.text.trim(),
                whereKey2: 'BatchNo',
                value2: batchNoController.text.trim(),
                ZinckThickness: _zinckController.text.trim(),
                visualControl: _visualControlController.text.trim(),
                missingRatio: _missingRatioController.text.trim(),
                filingLevel: _filingLevelController.text.trim(),
                clearingVoltage: _clearingVoltageController.text.trim())
            .then((value) => _clearAllData());
        print("updateSendSqlite");
      }
    } catch (e) {
      print(e);
    }
  }

  void _saveSendSqlite() async {
    try {
      await databaseHelper.insertSqlite('PROCESS_SHEET', {
        'Machine': machineNoController.text.trim(),
        'OperatorName': operatorNameController.text.trim(),
        'BatchNo': int.tryParse(batchNoController.text.trim()),
        'Garbage': rejectQtyController.text.trim(),
        'FinDate': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        'StartEnd': StartEndValue.toString(),
        'ZinckThickness': _zinckController.text.trim(),
        'visualControl_v': _clearing_visualControlController.text.trim(),
        'visualControl': _visualControlController.text.trim(),
        'clearingVoltage': _clearingVoltageController.text.trim(),
        'MissingRatio': _missingRatioController.text.trim(),
        'FilingLevel': _filingLevelController.text.trim(),
      }).then((value) => _clearAllData());
      print("ok");
    } catch (e) {
      print(e);
    }
  }
}
