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
import 'package:hitachi/models/SendWdFinish/sendWdsFinish_Input_Model.dart';
import 'package:hitachi/models/SendWdFinish/sendWdsFinish_output_Model.dart';
import 'package:hitachi/models/reportRouteSheet/reportRouteSheetModel.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class WindingJobFinishScreen extends StatefulWidget {
  const WindingJobFinishScreen({super.key});

  @override
  State<WindingJobFinishScreen> createState() => _WindingJobFinishScreenState();
}

class _WindingJobFinishScreenState extends State<WindingJobFinishScreen> {
  final TextEditingController operatorNameController = TextEditingController();
  final TextEditingController batchNoController = TextEditingController();
  final TextEditingController elementQtyController = TextEditingController();
  String batchEndate = DateTime.now().toString();

  DatabaseHelper databaseHelper = DatabaseHelper();
  SendWdsFinishInputModel? items;
  SendWdsFinishOutputModel? _outputModel;
  int batch = 100136982104;
  ReportRouteSheetModel? itemsReport;
  void _btnSend_Click() async {
    if (batchNoController.text.trim().isNotEmpty &&
        operatorNameController.text.trim().isNotEmpty &&
        elementQtyController.text.trim().isNotEmpty) {
      try {
        _callApi(
            batchNo: int.tryParse(batchNoController.text.trim()),
            element: int.tryParse(elementQtyController.text.trim()),
            batchEnddate: batchEndate);
        await databaseHelper.deleteSave(
            tableName: 'WINDING_SHEET',
            where: 'BatchNo',
            keyWhere: batchNoController.text.trim());
        EasyLoading.showSuccess("sendComplete");
      } catch (e) {
        EasyLoading.showError("Can not send");
      }
    } else {
      EasyLoading.show(
          status: "data incomplete ${elementQtyController.text.toString()}");
    }
  }

  Future<void> _callApi(
      {int? batchNo, int? element, String? batchEnddate}) async {
    BlocProvider.of<LineElementBloc>(context).add(
      PostSendWindingFinishEvent(
        SendWdsFinishOutputModel(
            BATCH_NO: batchNo, ELEMNT_QTY: element, FINISH_DATE: batchEnddate),
      ),
    );
  }

  Future<void> _insertSqlite() async {
    var sql = await databaseHelper.queryDataSelect(
        select1: 'BatchNo',
        select2: 'MachineNo',
        formTable: 'WINDING_SHEET',
        where: 'BatchNo',
        intValue: int.tryParse(batchNoController.text.trim()),
        keyAnd: 'MachineNo',
        value: 'WD',
        keyAnd2: 'start_end',
        value2: 'E');

    if (sql.length <= 0) {
      var sqlInsertWINDING_SHEET =
          await databaseHelper.insertSqlite('WINDING_SHEET', {
        'BatchNo': int.tryParse(batchNoController.text.trim()),
        'Element': int.tryParse(elementQtyController.text.trim()),
        'BatchEndDate': batchNoController.text.trim(),
        'start_end': 'E',
        'checkComplete': '0',
        'value': 'WD'
      });
    }
  }

  Future<bool?> _queryPackno(
      {int? batchNo, int? element, String? batchEnddate}) async {
    bool ischeck = false;
    Database db = await databaseHelper.database;
    try {} catch (e) {
      print("Error Catch ${e}");
      EasyLoading.show(status: "CAN not SAVE.", dismissOnTap: true);
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
  void initState() {
    super.initState();
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
                setState(() {
                  items = state.item;
                });
              }
              if (state is PostSendWindingFinishErrorState) {
                _insertSqlite();
                EasyLoading.showError("Can not send");
              }
            },
          )
        ],
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                SizedBox(
                  height: 15,
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
                          context, RouterList.WindingJobFinish_hold_Screen),
                      child: Label(
                        "Hold",
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
