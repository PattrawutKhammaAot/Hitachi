import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';

class TreatMentStartScanScreen extends StatefulWidget {
  const TreatMentStartScanScreen({super.key});

  @override
  State<TreatMentStartScanScreen> createState() =>
      _TreatMentStartScanScreenState();
}

class _TreatMentStartScanScreenState extends State<TreatMentStartScanScreen> {
  final TextEditingController MachineNoController = TextEditingController();
  final TextEditingController OperatorNameController = TextEditingController();
  final TextEditingController Batch1Controller = TextEditingController();
  final TextEditingController Batch2Controller = TextEditingController();
  final TextEditingController Batch3Controller = TextEditingController();
  final TextEditingController Batch4Controller = TextEditingController();
  final TextEditingController Batch5Controller = TextEditingController();
  final TextEditingController Batch6Controller = TextEditingController();
  final TextEditingController Batch7Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BgWhite(
        isHideAppBar: true,
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
