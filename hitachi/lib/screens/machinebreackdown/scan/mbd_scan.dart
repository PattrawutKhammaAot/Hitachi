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
  final List<String> genderItems = [
    'Male',
    'Female',
  ];
  List<BreakDownSheetModel> bdsList = [];

  String? selectedValue;

  final _formKey = GlobalKey<FormState>();

  void _checkValueController() {
    if (_machineNo_Controller.text.isNotEmpty &&
        _operatorname_Controller.text.isNotEmpty &&
        _serviceNo_Controller.text.isNotEmpty &&
        _start_Technical_1_Controller.text.isNotEmpty &&
        _stop_Technical_1_Controller.text.isNotEmpty &&
        _operator_accept_Controller.text.isNotEmpty &&
        _start_Technical_1_Controller.text ==
            _stop_Technical_1_Controller.text) {
      _sendData();
      Future.delayed(Duration(seconds: 5), () {
        _callBreakDownMachine();
      });
    } else {
      EasyLoading.showError("Please Input Data");
    }
    if (_start_Technical_1_Controller.text !=
        _stop_Technical_1_Controller.text) {
      EasyLoading.showError("Start technical 1 don't match Stop technical 2");
    }
  }

  void _callBreakDownMachine() async {
    var sql = await databaseHelper.queryAllRows('BREAKDOWN_SHEET');
    if (sql.length > 0) {
      setState(() {
        bdsList = sql
            .map((row) => BreakDownSheetModel.fromMap(
                row.map((key, value) => MapEntry(key, value.toString()))))
            .toList();
      });
    } else {
      print(bdsList.length);
    }

    setState(() {
      bdsList.insert(0, BreakDownSheetModel(MACHINE_NO: "NEW"));
    });
  }

  @override
  void initState() {
    _callBreakDownMachine();
    super.initState();
  }

  void _saveMachine() async {
    try {
      var sql = await databaseHelper.queryDataSelect(
          select1: 'MachineNo',
          formTable: 'BREAKDOWN_SHEET',
          where: 'MachineNo',
          stringValue: _machineNo_Controller.text.trim());

      if (sql.length <= 0) {
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
      } else {
        var sql_breakdown = await databaseHelper.queryDataSelect(
            select1: 'MT1StartDate',
            select2: 'MT2StartDate',
            select3: 'MT1StopDate',
            select4: 'MT2StopDate',
            formTable: 'BREAKDOWN_SHEET',
            stringValue: _machineNo_Controller.text.trim());
        if (sql_breakdown.length > 0) {
          var mt = sql_breakdown[0];
          var mt1start, mt2start, mt1stop, mt2stop;
          var mt1StartDate = mt[0]["MT1StartDate"] ?? DateTime.now().toString();

          var mt2StartDate = mt[0]["MT2StartDate"] ?? DateTime.now().toString();
          var mt1StopDate =
              mt[0]["MT1StopDate"] ?? _stop_Technical_1_Controller.text.trim();
          var mt2StopDate =
              mt[0]["MT2StopDate"] ?? _stop_Technical_2_Controller.text.trim();

          await databaseHelper.updateSqlite(
              'BREAKDOWN_SHEET',
              {
                'MachineNo': _machineNo_Controller.text.trim(),
                'CallUser': _operatorname_Controller.text.trim(),
                'RepairNo': _serviceNo_Controller.text.trim(),
                'BreakStartDate': DateTime.now().toString(),
                'MT1': _start_Technical_1_Controller.text.trim(),
                'MT1StartDate': mt1StartDate,
                'MT2': _start_Technical_2_Controller.text.trim(),
                'MT2StartDate': mt2StartDate,
                'MT1StopDate': mt1StopDate,
                'MT2StopDate': mt2StopDate,
                'CheckUser': _operator_accept_Controller.text.trim(),
                'BreakStopDate': "", //ไม่รู้ว่ามาจากไหน
                'CheckComplete': "",
              },
              'MachineNo',
              [_machineNo_Controller.text.trim()]);
        }
      }
      EasyLoading.showError("Save complete & Can not Call Api");
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
            BREAK_START_DATE: DateTime.now().toString(),
            TECH1: _start_Technical_1_Controller.text.trim(),
            START_DATE_TECH_1: DateTime.now().toString(),
            TECH2: _start_Technical_2_Controller.text.trim(),
            START_DATE_TECH_2: _start_Technical_2_Controller.text.isEmpty
                ? ""
                : _start_Technical_2_Controller.text.trim(),
            STOP_TECH_DATE_1: _stop_Technical_1_Controller.text.trim(),
            STOP_TECH_DATE_2: _stop_Technical_2_Controller.text.trim(),
            ACCEPT: _operator_accept_Controller.text.trim(),
            BREAK_STOP_DATE: ""),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MachineBreakDownBloc, MachineBreakDownState>(
          listener: (context, state) {
            if (state is PostMachineBreakdownLoadingState) {
              EasyLoading.show();
            } else if (state is PostMachineBreakdownLoadedState) {
              EasyLoading.dismiss();
              setState(() {
                _respone = state.item;
              });
              if (_respone!.RESULT == true) {
                EasyLoading.showSuccess("Send complete",
                    duration: Duration(seconds: 3));
              } else {
                _saveMachine();
              }
            }
            if (state is PostMachineBreakdownErrorState) {
              EasyLoading.dismiss();
              _saveMachine();
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
                          child: DropdownButtonFormField2(
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
                            // validator: (value) {
                            //   if (value == null) {
                            //     return 'Please select gender.';
                            //   }
                            //   return null;
                            // },
                            onChanged: (value) {
                              for (var item in bdsList) {
                                if (value == item.MACHINE_NO &&
                                    value != 'NEW') {
                                  setState(() {
                                    _machineNo_Controller.text =
                                        item.MACHINE_NO.toString();
                                  });
                                  print(value);
                                  break;
                                } else if (value == 'NEW') {
                                  setState(() {
                                    _machineNo_Controller.text = '';
                                    _operatorname_Controller.text = '';
                                    _serviceNo_Controller.text = '';
                                    _start_Technical_1_Controller.text = '';
                                    _start_Technical_2_Controller.text = '';
                                    _stop_Technical_1_Controller.text = '';
                                    _stop_Technical_2_Controller.text = '';
                                    _operator_accept_Controller.text = '';
                                  });
                                }
                              }
                            },
                            onSaved: (value) {
                              selectedValue = value.toString();
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
                    labelText: "Machine No. : ",
                    height: 30,
                    controller: _machineNo_Controller,
                    maxLength: 3,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    labelText: "Operator Name : ",
                    height: 30,
                    controller: _operatorname_Controller,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[a-zA-Z0-9]+$')),
                      LengthLimitingTextInputFormatter(12),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
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
                          labelText: "Start Technical 1 : ",
                          controller: _start_Technical_1_Controller,
                          height: 30,
                          onChanged: (p0) {
                            setState(() {
                              if (p0.length > 1) {
                                _start_Technical_1_Controller.text.isNotEmpty;
                              }
                            });
                          },
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
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
                          labelText: "Stop Technical 1 : ",
                          controller: _stop_Technical_1_Controller,
                          height: 30,
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          labelText: "Stop Technical 2 : ",
                          controller: _stop_Technical_2_Controller,
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    labelText: "Operator Accept : ",
                    controller: _operator_accept_Controller,
                    height: 30,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Button(
                    onPress: () {
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
}