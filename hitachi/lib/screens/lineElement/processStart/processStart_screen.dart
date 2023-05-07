import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';

class ProcessStartScreen extends StatefulWidget {
  const ProcessStartScreen({super.key});

  @override
  State<ProcessStartScreen> createState() => _ProcessStartScreenState();
}

class _ProcessStartScreenState extends State<ProcessStartScreen> {
  @override
  Widget build(BuildContext context) {
    return BgWhite(
        textTitle: "Process Start",
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                RowBoxInputField(
                  labelText: "Machine No :",
                  maxLength: 3,
                  height: 35,
                ),
                SizedBox(
                  height: 5,
                ),
                RowBoxInputField(
                  labelText: "Operator Name :",
                  height: 35,
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
                ),
                SizedBox(
                  height: 5,
                ),
                RowBoxInputField(
                  labelText: "Operator Name :",
                  height: 35,
                ),
                SizedBox(
                  height: 5,
                ),
                RowBoxInputField(
                  labelText: "Operator Name :",
                  height: 35,
                ),
                SizedBox(
                  height: 5,
                ),
                DottedLine(),
                SizedBox(
                  height: 5,
                ),
                RowBoxInputField(
                  labelText: "Machine No :",
                  maxLength: 3,
                  height: 35,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Label("Scan"),
                    SizedBox(
                      height: 15,
                      child: VerticalDivider(
                        color: COLOR_BLACK,
                        thickness: 2,
                      ),
                    ),
                    GestureDetector(
                      // onTap: () => Navigator.pushNamed(
                      //     context, RouterList.WindingJobStart_Hold_Screen),
                      child: Label(
                        "Hold",
                        color: Colors.grey,
                      ),
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
              ],
            ),
          ),
        ));
  }
}
