import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/processModel.dart';
import 'package:hitachi/models/processStart/processOutputModel.dart';
import 'package:hitachi/services/databaseHelper.dart';

class ProcessStartScanScreen extends StatefulWidget {
  const ProcessStartScanScreen({super.key});

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

  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LineElementBloc, LineElementState>(
          listener: (context, state) {
            if (state is ProcessInputLoadingState) {
              EasyLoading.show();
            } else if (state is ProcessInputLoadedState) {
              if (state.item.RESULT == true) {
                EasyLoading.showSuccess("SendComplete");
              } else if (state.item.RESULT == false) {
                EasyLoading.showError("Can not send & save Data");
                _testSendSqlite();
              }
            } else if (state is ProcessInputErrorState) {
              EasyLoading.dismiss();
              _testSendSqlite();
              EasyLoading.showError("Please Check Connection Internet");
            }
          },
        )
      ],
      child: BgWhite(
          isHideAppBar: true,
          textTitle: "Process Start",
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
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    labelText: "Operator Name :",
                    height: 35,
                    controller: operatorNameController,
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
                    controller: operatorName1Controller,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    labelText: "Operator Name :",
                    height: 35,
                    controller: operatorName2Controller,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    labelText: "Operator Name :",
                    height: 35,
                    controller: operatorName3Controller,
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
                    maxLength: 8,
                    height: 35,
                    controller: batchNoController,
                    type: TextInputType.number,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
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
                          "Batch No. INVAILD",
                          color: COLOR_RED,
                        )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Button(
                    height: 40,
                    bgColor: COLOR_RED,
                    text: Label(
                      "Send",
                      color: COLOR_WHITE,
                    ),
                    onPress: () => _btnSend(),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Container(
                  //   child: Button(
                  //     bgColor: COLOR_BLUE,
                  //     text: Label(
                  //       "TestSend",
                  //       color: COLOR_WHITE,
                  //     ),
                  //     onPress: () => {_testSendSqlite()},
                  //   ),
                  // ),
                ],
              ),
            ),
          )),
    );
  }

  void _testSendSqlite() async {
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
          'BatchNo': int.tryParse(batchNoController.text.trim()),
          'StartDate': DateTime.now().toString(),
        });
        print("ok");
      }
    } catch (e) {
      print(e);
    }
  }
  // void _saveDataToSqlite() async {
  //   await databaseHelper.insertSqlite('TREATMENT_SHEET', {
  //     'MachineNo': _machineNoController.text.trim(),
  //     'OperatorName': _operatorNameController.text.trim(),
  //     'Batch1': _batch1Controller.text.trim(),
  //     'Batch2':
  //     _batch2Controller.text == null ? "" : _batch2Controller.text.trim(),
  //     'Batch3':
  //     _batch3Controller.text == null ? "" : _batch3Controller.text.trim(),
  //     'Batch4':
  //     _batch4Controller.text == null ? "" : _batch4Controller.text.trim(),
  //     'Batch5':
  //     _batch5Controller.text == null ? "" : _batch5Controller.text.trim(),
  //     'Batch6':
  //     _batch6Controller.text == null ? "" : _batch6Controller.text.trim(),
  //     'Batch7':
  //     _batch7Controller.text == null ? "" : _batch7Controller.text.trim(),
  //     'StartDate': DateTime.now().toString(),
  //     'FinDate': '',
  //     'StartEnd': '',
  //     'CheckComplete': 'S',
  //   });
  // }

  void _btnSend() async {
    if (MachineController.text.isNotEmpty &&
        operatorNameController.text.isNotEmpty &&
        operatorName1Controller.text.isNotEmpty) {
      _callAPI();
      // _saveDataToSqlite();
    } else {
      EasyLoading.showError("Please Input Info");
    }
  }

  void _callAPI() {
    BlocProvider.of<LineElementBloc>(context).add(
      ProcessInputEvent(ProcessOutputModel(
        MACHINE: MachineController.text.trim(),
        OPERATORNAME: operatorNameController.text.trim(),
        OPERATORNAME1: operatorName1Controller.text.trim(),
        OPERATORNAME2: operatorName2Controller.text.trim(),
        OPERATORNAME3: operatorName3Controller.text.trim(),
        BATCHNO: int.tryParse(batchNoController.text.trim()),
        STARTDATE: DateTime.now().toString(),
      )),
    );
  }
}
