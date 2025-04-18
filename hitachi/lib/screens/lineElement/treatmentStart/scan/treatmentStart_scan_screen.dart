import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/materialTrace/update_material_trace_bloc.dart';
import 'package:hitachi/blocs/treatment/treatment_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/materialTraces/materialTraceUpdateModel.dart';
import 'package:hitachi/models/treatmentModel/treatmentOutputModel.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:intl/intl.dart';

class TreatMentStartScanScreen extends StatefulWidget {
  TreatMentStartScanScreen({super.key, this.onChange});
  ValueChanged<List<Map<String, dynamic>>>? onChange;

  @override
  State<TreatMentStartScanScreen> createState() =>
      _TreatMentStartScanScreenState();
}

class _TreatMentStartScanScreenState extends State<TreatMentStartScanScreen> {
  final TextEditingController _machineNoController = TextEditingController();
  final TextEditingController _operatorNameController = TextEditingController();
  final TextEditingController _batch1Controller = TextEditingController();
  final TextEditingController _batch2Controller = TextEditingController();
  final TextEditingController _batch3Controller = TextEditingController();
  final TextEditingController _batch4Controller = TextEditingController();
  final TextEditingController _batch5Controller = TextEditingController();
  final TextEditingController _batch6Controller = TextEditingController();
  final TextEditingController _batch7Controller = TextEditingController();
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

  Color? bgChange;

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> itemMasterLotTreatment = [];

  void _btnSend() async {
    if (_machineNoController.text.isNotEmpty &&
        _operatorNameController.text.isNotEmpty &&
        _batch1Controller.text.isNotEmpty) {
      if (_machineNoController.text.substring(0, 2).toUpperCase() == 'TM' &&
          itemMasterLotTreatment.isNotEmpty) {
        if (_batch1Controller.text.isNotEmpty) {
          _callApiUpdateMaterialTrace(_batch1Controller);
        }
        if (_batch2Controller.text.isNotEmpty) {
          _callApiUpdateMaterialTrace(_batch2Controller);
        }
        if (_batch3Controller.text.isNotEmpty) {
          _callApiUpdateMaterialTrace(_batch3Controller);
        }
        if (_batch4Controller.text.isNotEmpty) {
          _callApiUpdateMaterialTrace(_batch4Controller);
        }
        if (_batch5Controller.text.isNotEmpty) {
          _callApiUpdateMaterialTrace(_batch5Controller);
        }
        if (_batch6Controller.text.isNotEmpty) {
          _callApiUpdateMaterialTrace(_batch6Controller);
        }
        if (_batch7Controller.text.isNotEmpty) {
          _callApiUpdateMaterialTrace(_batch7Controller);
        }
      }
      _callApi();

      // _saveDataToSqlite();
    } else {
      EasyLoading.showError("Please Input Info");
    }
  }

  Future _callApiUpdateMaterialTrace(TextEditingController batch) async {
    for (var itemMasterLOT in itemMasterLotTreatment) {
      BlocProvider.of<UpdateMaterialTraceBloc>(context).add(
          PostUpdateMaterialTraceEvent(
              MaterialTraceUpdateModel(
                  DATE: DateTime.now().toString(),
                  MATERIAL: itemMasterLOT['Material'].toString(),
                  IPE_NO: null,
                  LOT: itemMasterLOT['Lot'].toString(),
                  PROCESS: _machineNoController.text.trim(),
                  I_PEAK: null,
                  HIGH_VOLT: null,
                  OPERATOR: _operatorNameController.text.trim(),
                  BATCH_NO: batch.text.trim()),
              "Process"));

      setState(() {});
    }
  }

  void _callApi() {
    BlocProvider.of<TreatmentBloc>(context).add(
      TreatmentStartSendEvent(TreatMentOutputModel(
        MACHINE_NO: _machineNoController.text.trim(),
        OPERATOR_NAME: int.tryParse(_operatorNameController.text.trim()),
        BATCH_NO_1: _batch1Controller.text,
        BATCH_NO_2: _batch2Controller.text,
        BATCH_NO_3: _batch3Controller.text,
        BATCH_NO_4: _batch4Controller.text,
        BATCH_NO_5: _batch5Controller.text,
        BATCH_NO_6: _batch6Controller.text,
        BATCH_NO_7: _batch7Controller.text,
        START_DATE: DateTime.now().toString(),
      )),
    );
  }

  @override
  void initState() {
    f1.requestFocus();
    _getHold();
    super.initState();
  }

  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('TREATMENT_SHEET');
    setState(() {
      widget.onChange
          ?.call(sql.where((element) => element['StartEnd'] == 'S').toList());
    });
  }

  Future _saveDataToSqlite() async {
    await databaseHelper.insertSqlite('TREATMENT_SHEET', {
      'MachineNo': _machineNoController.text.trim(),
      'OperatorName': _operatorNameController.text.trim(),
      'Batch1': _batch1Controller.text.trim(),
      'Batch2': _batch2Controller.text.trim(),
      'Batch3': _batch3Controller.text.trim(),
      'Batch4': _batch4Controller.text.trim(),
      'Batch5': _batch5Controller.text.trim(),
      'Batch6': _batch6Controller.text.trim(),
      'Batch7': _batch7Controller.text.trim(),
      'StartDate': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      'FinDate': '',
      'StartEnd': 'S',
      'CheckComplete': 'S',
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TreatmentBloc, TreatmentState>(
          listener: (context, state) {
            if (state is TreatmentStartSendLoadingState) {
              EasyLoading.show(status: "Loading...");
            } else if (state is TreatmentStartSendLoadedState) {
              EasyLoading.dismiss();
              if (state.item.RESULT == true) {
                _machineNoController.clear();
                _operatorNameController.clear();
                _batch1Controller.clear();
                _batch2Controller.clear();
                _batch3Controller.clear();
                _batch4Controller.clear();
                _batch5Controller.clear();
                _batch6Controller.clear();
                _batch7Controller.clear();
                f1.requestFocus();
                setState(() {
                  bgChange = Colors.grey;
                });

                EasyLoading.showSuccess("${state.item.MESSAGE}");
              } else if (state.item.RESULT == false) {
                if (_machineNoController.text.isNotEmpty &&
                    _operatorNameController.text.isNotEmpty &&
                    _batch1Controller.text.isNotEmpty) {
                  _errorDialog(
                      text: Label(
                          "${state.item.MESSAGE ?? "CheckConnection\n Do you want to Save"}"),
                      onpressOk: () async {
                        Navigator.pop(context);
                        await _saveDataToSqlite();
                        await _getHold();
                        _machineNoController.clear();
                        _operatorNameController.clear();
                        _batch1Controller.clear();
                        _batch2Controller.clear();
                        _batch3Controller.clear();
                        _batch4Controller.clear();
                        _batch5Controller.clear();
                        _batch6Controller.clear();
                        _batch7Controller.clear();
                        f1.requestFocus();
                      });
                } else {
                  EasyLoading.showError("Please Input Info");
                }
              } else {
                if (_machineNoController.text.isNotEmpty &&
                    _operatorNameController.text.isNotEmpty &&
                    _batch1Controller.text.isNotEmpty) {
                  _errorDialog(
                      text: Label(
                          "${state.item.MESSAGE ?? "CheckConnection\n Do you want to Save"}"),
                      onpressOk: () async {
                        Navigator.pop(context);
                        await _saveDataToSqlite();
                        await _getHold();
                        _machineNoController.clear();
                        _operatorNameController.clear();
                        _batch1Controller.clear();
                        _batch2Controller.clear();
                        _batch3Controller.clear();
                        _batch4Controller.clear();
                        _batch5Controller.clear();
                        _batch6Controller.clear();
                        _batch7Controller.clear();
                        f1.requestFocus();
                      });
                } else {
                  EasyLoading.showError("Please Input Info");
                }
              }
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
                    focusNode: f1,
                    onEditingComplete: () async {
                      if (_machineNoController.text.length == 3) {
                        itemMasterLotTreatment = await DatabaseHelper()
                            .queryMasterlotTmProcess(
                                _machineNoController.text.substring(0, 2));
                        setState(() {});
                        f2.requestFocus();
                      }
                    },
                    labelText: "Machine No. : ",
                    height: 35,
                    maxLength: 3,
                    controller: _machineNoController,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    focusNode: f2,
                    onEditingComplete: () => f3.requestFocus(),
                    labelText: "Operator Name : ",
                    height: 35,
                    maxLength: 12,
                    type: TextInputType.number,
                    controller: _operatorNameController,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    focusNode: f3,
                    onEditingComplete: () {
                      if (_batch1Controller.text.length == 12) {
                        f4.requestFocus();
                      }
                    },
                    labelText: "Batch 1 : ",
                    height: 35,
                    maxLength: 12,
                    controller: _batch1Controller,
                    type: TextInputType.number,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    onChanged: (value) {
                      if (_machineNoController.text.isNotEmpty &&
                          _operatorNameController.text.isNotEmpty &&
                          _batch1Controller.text.isNotEmpty) {
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
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    focusNode: f4,
                    onEditingComplete: () {
                      if (_batch2Controller.text.length == 12) {
                        f5.requestFocus();
                      }
                    },
                    labelText: "Batch 2 : ",
                    height: 35,
                    maxLength: 12,
                    controller: _batch2Controller,
                    type: TextInputType.number,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    focusNode: f5,
                    onEditingComplete: () {
                      if (_batch3Controller.text.length == 12) {
                        f6.requestFocus();
                      }
                    },
                    labelText: "Batch 3 : ",
                    height: 35,
                    maxLength: 12,
                    controller: _batch3Controller,
                    type: TextInputType.number,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    focusNode: f6,
                    onEditingComplete: () {
                      if (_batch4Controller.text.length == 12) {
                        f7.requestFocus();
                      }
                    },
                    labelText: "Batch 4 : ",
                    height: 35,
                    maxLength: 12,
                    controller: _batch4Controller,
                    type: TextInputType.number,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    focusNode: f7,
                    maxLength: 12,
                    onEditingComplete: () {
                      if (_batch5Controller.text.length == 12) {
                        f8.requestFocus();
                      }
                    },
                    labelText: "Batch 5 : ",
                    height: 35,
                    controller: _batch5Controller,
                    type: TextInputType.number,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    focusNode: f8,
                    maxLength: 12,
                    onEditingComplete: () {
                      if (_batch6Controller.text.length == 12) {
                        f9.requestFocus();
                      }
                    },
                    labelText: "Batch 6 : ",
                    height: 35,
                    controller: _batch6Controller,
                    type: TextInputType.number,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    focusNode: f9,
                    maxLength: 12,
                    onEditingComplete: () {
                      if (_batch7Controller.text.length == 12) {
                        _btnSend();
                      }
                    },
                    labelText: "Batch 7 : ",
                    height: 35,
                    controller: _batch7Controller,
                    type: TextInputType.number,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                  SizedBox(
                    height: 5,
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
