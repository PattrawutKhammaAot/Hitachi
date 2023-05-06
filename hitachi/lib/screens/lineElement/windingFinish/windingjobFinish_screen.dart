// ignore_for_file: unrelated_type_equality_checks

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/SendWdFinish/sendWdsFinish_output_Model.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:hitachi/services/databaseHelper.dart';

class WindingJobFinishScreen extends StatefulWidget {
  const WindingJobFinishScreen({super.key});

  @override
  State<WindingJobFinishScreen> createState() => _WindingJobFinishScreenState();
}

class _WindingJobFinishScreenState extends State<WindingJobFinishScreen> {
  final TextEditingController operatorNameController = TextEditingController();
  final TextEditingController batchNoController = TextEditingController();
  final TextEditingController elementQtyController = TextEditingController();

  DatabaseHelper databaseHelper = DatabaseHelper();
  SendWdsFinishOutputModel? _outputModel;

  void _btnSend_Click() {
    CallApi();
    // if (batchNoController.text.trim().isNotEmpty ||
    //     operatorNameController.text.trim().isNotEmpty ||
    //     elementQtyController.text.trim().isNotEmpty) {
    //   bool isCallWindingFin = callWindingFin(
    //       batchNo: int.tryParse(
    //         batchNoController.text.trim(),
    //       ),
    //       element: int.tryParse(
    //         elementQtyController.text.trim(),
    //       ),
    //       batchEnddate: DateTime.now().toString());
    //   if (isCallWindingFin == true) {}
    // }
  }

  bool callWindingFin({int? batchNo, int? element, String? batchEnddate}) {
    bool checkSave = false;
    try {
      checkSave = true;
      // ใส่โค้ดที่ต้องการให้ทำงานได้ตรงนี้
    } catch (e) {
      // กรณีเกิดข้อผิดพลาด ใส่โค้ดที่ต้องการจัดการตรงนี้
    }
    if (checkSave == true) {
      try {
        // ใส่โค้ดที่ต้องการให้ทำงานได้ตรงนี้
      } catch (e) {
        // กรณีเกิดข้อผิดพลาด ใส่โค้ดที่ต้องการจัดการตรงนี้
      }
    }
    // ใส่โค้ดที่ต้องการให้ทำงานต่อไปได้ตรงนี้
    return checkSave;
  }

  bool CallApi({int? batchNo, int? element}) {
    try {
      BlocProvider.of<LineElementBloc>(context).add(
        PostSendWindingFinishEvent(
          SendWdsFinishOutputModel(
            BATCH_NO: batchNo,
            ELEMNT_QTY: element,
            FINISH_DATE: DateTime.now().toString(),
            OPERATOR_NAME: int.tryParse(
              operatorNameController.text.trim(),
            ),
          ),
        ),
      );
      print("isture");
      return true;
    } catch (e) {
      print("false");
      return false;
    }
  }

  void checkformtxtBatchNo({DateTime? batchEndDate}) {
    var tempTarget;
    String tempCheckRow = "";
    if (batchNoController.text.trim().isEmpty &&
        batchNoController.text.trim().length >= 8) {
      batchEndDate = DateTime.now();
      tempTarget = 0.0;
      if (queryTarget(
              batchNo: int.tryParse(
                batchNoController.text.trim(),
              ),
              target: tempTarget,
              checkRow: tempCheckRow) ==
          true) {
        if (tempCheckRow == tempCheckRow.isEmpty) {
          ///ให้ทำการ showTargetของ(tempTarget)
        } else {
          //ให้ทำการโชว์ Target ของ tempCheckRow
        }
      } else {
        //ให้ทำการโชว์ showTarget ของ tempTarget
      }
    } else {
      //Show Batch No. INVALID
    }
  }

  Future<bool> queryTarget(
      {int? batchNo, num? target, String? checkRow}) async {
    try {
      var sql = await databaseHelper.queryDataSelect(
          select1: 'Target',
          formTable: 'WINDING_WEIGHT_SHEET',
          where: 'Batch',
          value: batchNo.toString());

      if (sql.length > 0) {
        var ds = sql[0];
        final targetTable = ds['Target'];
        final targetValue = targetTable.rows[0]['Target'] as double;
        final roundedTarget = targetValue.round();
        target = roundedTarget;
        return true;
      } else {
        target = 0.0;
        checkRow = "N/A";
        return true;
      }
    } catch (e) {
      EasyLoading.show(status: "Element Error", dismissOnTap: true);
      target = null;
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      textTitle: "Winding job finish",
      body: MultiBlocListener(
        listeners: [
          BlocListener<LineElementBloc, LineElementState>(
            listener: (context, state) {
              if (state is PostSendWindingFinishLoadingState) {
                EasyLoading.show();
              }
              if (state is PostSendWindingFinishLoadedState) {
                if (state.item.RESULT == true) {
                  callWindingFin();
                }
                EasyLoading.dismiss();
                print("isLoaded");
              }

              if (state is PostSendWindingFinishErrorState) {
                EasyLoading.dismiss();

                print(state.error);
              }
            },
          )
        ],
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    BoxInputField(
                      labelText: "Operator Name :",
                      maxLength: 3,
                      controller: operatorNameController,
                    ),
                    BoxInputField(
                      labelText: "Batch No :",
                      maxLength: 3,
                      controller: batchNoController,
                    ),
                    BoxInputField(
                      labelText: "Element QTY :",
                      maxLength: 3,
                      controller: elementQtyController,
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
                      onPress: () => {_btnSend_Click()},
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
      ),
    );
  }
}
