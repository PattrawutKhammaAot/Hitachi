import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/route/router_list.dart';

class WindingJobFinishScreen extends StatefulWidget {
  const WindingJobFinishScreen({super.key});

  @override
  State<WindingJobFinishScreen> createState() => _WindingJobFinishScreenState();
}

class _WindingJobFinishScreenState extends State<WindingJobFinishScreen> {
  @override
  Widget build(BuildContext context) {
    return BgWhite(
      textTitle: "Winding job finish",
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  BoxInputField(
                    labelText: "Operator Name :",
                    maxLength: 3,
                  ),
                  BoxInputField(
                    labelText: "Batch No :",
                    maxLength: 3,
                  ),
                  BoxInputField(
                    labelText: "Element QTY :",
                    maxLength: 3,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  child: Button(
                    bgColor: COLOR_RED,
                    text: Label(
                      "Send",
                      color: COLOR_WHITE,
                    ),
                    onPress: () => print("hold"),
                  ),
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
                      onTap: () => Navigator.pushNamed(
                          context, RouterList.WindingJobStart_Hold_Screen),
                      child: Label(
                        "Hold",
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
