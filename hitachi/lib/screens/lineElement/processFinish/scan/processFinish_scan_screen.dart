import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';

class ProcessFinishScanScreen extends StatefulWidget {
  const ProcessFinishScanScreen({super.key});

  @override
  State<ProcessFinishScanScreen> createState() =>
      _ProcessFinishScanScreenState();
}

class _ProcessFinishScanScreenState extends State<ProcessFinishScanScreen> {
  @override
  Widget build(BuildContext context) {
    return BgWhite(
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
                ),
                SizedBox(
                  height: 5,
                ),
                RowBoxInputField(
                  labelText: "Operator Name : ",
                ),
                SizedBox(
                  height: 5,
                ),
                RowBoxInputField(
                  labelText: "Batch No : ",
                ),
                SizedBox(
                  height: 5,
                ),
                RowBoxInputField(
                  labelText: "Reject Qty : ",
                  type: TextInputType.number,
                ),
                SizedBox(
                  height: 15,
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
              ],
            ),
          ),
        ));
  }
}
