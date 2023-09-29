import 'package:flutter/widgets.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/widget/custom_textinput.dart';

class WindingRecordScanScreen extends StatefulWidget {
  const WindingRecordScanScreen({super.key});

  @override
  State<WindingRecordScanScreen> createState() =>
      _WindingRecordScanScreenState();
}

class _WindingRecordScanScreenState extends State<WindingRecordScanScreen> {
  @override
  Widget build(BuildContext context) {
    return const BgWhite(
        isHideAppBar: true,
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextInputField(
                      isHideLable: true,
                      labelText: "Test",
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomTextInputField(
                      isHideLable: true,
                      labelText: "Test",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextInputField(
                      isHideLable: true,
                      labelText: "Test",
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomTextInputField(
                      isHideLable: true,
                      labelText: "Test",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextInputField(
                      isHideLable: true,
                      labelText: "Test",
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomTextInputField(
                      isHideLable: true,
                      labelText: "Test",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextInputField(
                      isHideLable: true,
                      labelText: "Test",
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomTextInputField(
                      isHideLable: true,
                      labelText: "Test",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextInputField(
                      isHideLable: true,
                      labelText: "Test",
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomTextInputField(
                      isHideLable: true,
                      labelText: "Test",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ));
  }
}
