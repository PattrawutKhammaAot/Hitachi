import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/route/router_list.dart';

class WindingJobStartScanScreen extends StatefulWidget {
  const WindingJobStartScanScreen({super.key});

  @override
  State<WindingJobStartScanScreen> createState() =>
      _WindingJobStartScanScreenState();
}

class _WindingJobStartScanScreenState extends State<WindingJobStartScanScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController machineNo = TextEditingController();
    TextEditingController operatorName = TextEditingController();
    TextEditingController batchNo = TextEditingController();
    TextEditingController product = TextEditingController();
    TextEditingController filmPackNo = TextEditingController();
    TextEditingController paperCodeLot = TextEditingController();
    TextEditingController ppFilmLot = TextEditingController();
    TextEditingController foilLot = TextEditingController();

    void checkvalueController() {
      if (machineNo.text.isEmpty &&
          operatorName.text.isEmpty &&
          batchNo.text.isEmpty &&
          product.text.isEmpty &&
          filmPackNo.text.isEmpty &&
          paperCodeLot.text.isEmpty &&
          ppFilmLot.text.isEmpty &&
          foilLot.text.isEmpty) {
        print("isEmpty");
      } else {
        print("isnotEmpty");
      }
    }

    return BgWhite(
      textTitle: "Winding Job Start (Scan)",
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BoxInputField(
                        labelText: "Machine No :",
                        controller: machineNo,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      BoxInputField(
                        labelText: "Operator Name :",
                        controller: operatorName,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      BoxInputField(
                        labelText: "Batch No :",
                        controller: batchNo,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      BoxInputField(
                        labelText: "Product",
                        controller: product,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      BoxInputField(
                        labelText: "Film Pack No :",
                        controller: filmPackNo,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      BoxInputField(
                        labelText: "Paper Code Lot :",
                        controller: paperCodeLot,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      BoxInputField(
                        labelText: "PP Film Lot :",
                        controller: ppFilmLot,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      BoxInputField(
                        labelText: "Foil Lot:",
                        controller: foilLot,
                      ),
                      SizedBox(
                        height: 5,
                      ),

                      Container(
                        child: Row(
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
                              onTap: () => Navigator.pushNamed(context,
                                  RouterList.WindingJobStart_Hold_Screen),
                              child: Label(
                                "Hold",
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                      // Container(
                      //   child: Button(
                      //     text: Label("test"),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Button(
                bgColor: COLOR_BLUE_DARK,
                text: Label(
                  "Send",
                  color: COLOR_WHITE,
                ),
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _popup();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _popup() {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: Label("weight1 :")),
              Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  )),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: Label("weight2 :")),
              Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  )),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Center(
                  child: Button(
                    height: 30,
                    bgColor: COLOR_RED,
                    text: Label(
                      "Cancel",
                      color: COLOR_WHITE,
                    ),
                    onPress: () => Navigator.pop(context),
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
              Expanded(
                child: Center(
                  child: Button(
                    height: 30,
                    bgColor: COLOR_BLUE_DARK,
                    text: Label(
                      "OK",
                      color: COLOR_WHITE,
                    ),
                    onPress: () => print("test"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
