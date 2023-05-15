import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/services/databaseHelper.dart';

class ProcessStartScanScreen extends StatefulWidget {
  const ProcessStartScanScreen({super.key});

  @override
  State<ProcessStartScanScreen> createState() => _ProcessStartScanScreenState();
}

class _ProcessStartScanScreenState extends State<ProcessStartScanScreen> {
  final TextEditingController MachineNoController = TextEditingController();
  final TextEditingController operatorNameController = TextEditingController();
  final TextEditingController operatorName1Controller = TextEditingController();
  final TextEditingController operatorName2Controller = TextEditingController();
  final TextEditingController operatorName3Controller = TextEditingController();
  final TextEditingController batchNoController = TextEditingController();

  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return BgWhite(
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
                  controller: MachineNoController,
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
                  onPress: () => print("send"),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Button(
                    bgColor: COLOR_BLUE,
                    text: Label(
                      "TestSend",
                      color: COLOR_WHITE,
                    ),
                    onPress: () => {_testSendSqlite()},
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _testSendSqlite() async {
    try {
      if (operatorNameController.text.isNotEmpty) {
        await databaseHelper.insertSqlite('PROCESS_SHEET', {
          'Machine': MachineNoController.text.trim(),
          'OperatorName': operatorNameController.text.trim(),
          'OperatorName1': operatorName1Controller.text.trim(),
          'OperatorName2': operatorName2Controller.text.trim(),
          'OperatorName3': operatorName3Controller.text.trim(),
          'BatchNo': int.tryParse(batchNoController.text.trim()),
          'StartDate': DateTime.now().toString(),
        });
        print("ok");
      }
    } catch (e) {
      print(e);
    }
  }
}
