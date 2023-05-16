// ignore_for_file: unrelated_type_equality_checks

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

//FOCUS
  final f1 = FocusNode();
  final f2 = FocusNode();
  final f3 = FocusNode();

  ///
  Color bgColor = Colors.grey;
  DatabaseHelper databaseHelper = DatabaseHelper();
  SendWdsFinishInputModel? items;
  SendWdsFinishOutputModel? _outputModel;

  ReportRouteSheetModel? itemsReport;
  String? target = "invaild";
  void _btnSend_Click() async {
    if (batchNoController.text.trim().isNotEmpty &&
        operatorNameController.text.trim().isNotEmpty &&
        elementQtyController.text.trim().isNotEmpty) {
      try {
        _callApi(
            batchNo: int.tryParse(batchNoController.text.trim()),
            element: int.tryParse(elementQtyController.text.trim()),
            batchEnddate: batchEndate);

        EasyLoading.showSuccess("sendComplete");
      } catch (e) {
        EasyLoading.showError("Can not send");
      }
    } else {
      EasyLoading.showError("Data incomplete", duration: Duration(seconds: 2));
    }
  }

  void _deleteSave() async {
    await databaseHelper.deleteSave(
        tableName: 'WINDING_SHEET',
        where: 'BatchNo',
        keyWhere: batchNoController.text.trim());
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
        intValue:
            int.tryParse(batchNoController.text.trim()), // If error check here
        keyAnd: 'MachineNo',
        value: 'WD',
        keyAnd2: 'start_end',
        value2: 'E');

    if (sql.length <= 0) {
      var sqlInsertWINDING_SHEET =
          await databaseHelper.insertSqlite('WINDING_SHEET', {
        'MachineNo': 'WD',
        'BatchNo': batchNoController.text.trim(),
        'Element': batchNoController.text.trim(),
        'BatchEndDate': DateTime.now().toString(),
        'start_end': 'E',
        'checkComplete': '0',
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

  void checkformtxtBatchNo() {
    queryTarget();
  }

  Future<bool> queryTarget({String? checkRow}) async {
    try {
      var sql = await databaseHelper.queryDataSelect(
          select1: 'Target',
          formTable: 'WINDING_WEIGHT_SHEET',
          where: 'BatchNo',
          value: batchNoController.text.trim());

      if (sql.length > 0) {
        var ds = sql[0];

        setState(() {
          final targetTable = ds['Target'];
          final targetValue = targetTable.rows[0]['Target'] as double;
          final roundedTarget = targetValue.round();
          target = roundedTarget.toString();
        });
        print(target);

        return true;
      } else {
        target = "0";
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
    f1.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      isHideAppBar: true,
      textTitle: "Winding job finish",
      body: MultiBlocListener(
        listeners: [
          BlocListener<LineElementBloc, LineElementState>(
            listener: (context, state) {
              if (state is PostSendWindingFinishLoadingState) {
                EasyLoading.show(status: "Loading...");
              } else if (state is PostSendWindingFinishLoadedState) {
                setState(() {
                  items = state.item;
                });
                if (items!.RESULT == true) {
                  _deleteSave();
                  EasyLoading.showSuccess("Send Complete");
                } else if (items!.RESULT == false) {
                  if (batchNoController.text.trim().isNotEmpty &&
                      operatorNameController.text.trim().isNotEmpty &&
                      elementQtyController.text.trim().isNotEmpty) {
                    _insertSqlite();
                    EasyLoading.showError("Save Complete &  Can not  Send");
                  } else {
                    EasyLoading.showError("Please Input Info");
                  }
                } else {
                  if (batchNoController.text.trim().isNotEmpty &&
                      operatorNameController.text.trim().isNotEmpty &&
                      elementQtyController.text.trim().isNotEmpty) {
                    _insertSqlite();
                    EasyLoading.showError(
                        "Please Check Connection Internet & Save Complete");
                  }
                }
              } else {
                EasyLoading.showError("Can not send",
                    duration: Duration(seconds: 3));
                // _insertSqlite();
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
                  focusNode: f1,
                  onEditingComplete: () => f2.requestFocus(),
                  labelText: "Operator Name :",
                  controller: operatorNameController,
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^(?!.*\d{12})[a-zA-Z0-9]+$'),
                    ),
                  ],
                ),
                BoxInputField(
                  focusNode: f2,
                  onEditingComplete: () => f3.requestFocus(),
                  labelText: "Batch No :",
                  maxLength: 12,
                  controller: batchNoController,
                  onChanged: (value) {
                    setState(() {
                      checkformtxtBatchNo();
                      batchNoController.text.trim();
                    });
                  },
                ),
                BoxInputField(
                  focusNode: f3,
                  onEditingComplete: () => _btnSend_Click(),
                  labelText: "Element QTY :",
                  controller: elementQtyController,
                  type: TextInputType.number,
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  onChanged: (p0) {
                    if (p0.length > 0) {
                      setState(() {
                        bgColor = COLOR_RED;
                      });
                    } else {
                      setState(() {
                        bgColor = COLOR_BLUE_DARK;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(
                          "Batch No. : ${batchNoController.text.trim()}",
                          color: COLOR_RED,
                        ),
                        Label(
                          "Target : ${target}",
                          color: COLOR_RED,
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  child: Button(
                    bgColor: bgColor,
                    text: Label(
                      "Send",
                      color: COLOR_WHITE,
                    ),
                    onPress: () => {_btnSend_Click()},
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _testSendSqlite() async {
    try {
      await databaseHelper.insertSqlite('WINDING_SHEET', {
        'BatchNo': batchNoController.text.trim(),
        'Element': elementQtyController.text.trim(),
        'BatchEndDate': batchNoController.text.trim(),
        'start_end': 'E',
        'checkComplete': '0',
        'value': 'WD'
      });
    } catch (e) {
      print(e);
    }
  }
}
