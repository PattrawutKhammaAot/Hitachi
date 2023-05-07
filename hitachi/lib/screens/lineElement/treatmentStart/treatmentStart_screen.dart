import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';

class TreatMentStartScreen extends StatefulWidget {
  const TreatMentStartScreen({super.key});

  @override
  State<TreatMentStartScreen> createState() => _TreatMentStartScreenState();
}

class _TreatMentStartScreenState extends State<TreatMentStartScreen> {
  @override
  Widget build(BuildContext context) {
    return BgWhite(
        textTitle: "Treatment Start",
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                RowBoxInputField(
                  labelText: "Machine No. : ",
                  height: 35,
                ),
                SizedBox(
                  height: 5,
                ),
                RowBoxInputField(
                  labelText: "Operator Name : ",
                  height: 35,
                ),
                SizedBox(
                  height: 5,
                ),
                RowBoxInputField(
                  labelText: "Batch 1 : ",
                  height: 35,
                ),
                SizedBox(
                  height: 5,
                ),
                RowBoxInputField(
                  labelText: "Batch 2 : ",
                  height: 35,
                ),
                SizedBox(
                  height: 5,
                ),
                RowBoxInputField(
                  labelText: "Batch 3 : ",
                  height: 35,
                ),
                SizedBox(
                  height: 5,
                ),
                RowBoxInputField(
                  labelText: "Batch 4 : ",
                  height: 35,
                ),
                SizedBox(
                  height: 5,
                ),
                RowBoxInputField(
                  labelText: "Batch 5 : ",
                  height: 35,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RowBoxInputField(
                        labelText: "Batch 6 : ",
                        height: 35,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: RowBoxInputField(
                        labelText: "Batch 7 : ",
                        height: 35,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
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
                  height: 5,
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
