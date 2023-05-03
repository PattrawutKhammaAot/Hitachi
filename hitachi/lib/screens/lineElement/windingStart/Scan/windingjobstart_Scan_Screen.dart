import 'dart:ffi';

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
import 'package:hitachi/models-Sqlite/dataSheetModel.dart';
import 'package:hitachi/models-Sqlite/windingSheetModel.dart';
import 'package:hitachi/models/SendWds/SendWdsModel_Output.dart';
import 'package:hitachi/models/SendWds/sendWdsModel_input.dart';
import 'package:hitachi/models/sendWdsReturnWeight/sendWdsReturnWeight_Input_Model.dart';
import 'package:hitachi/models/sendWdsReturnWeight/sendWdsReturnWeight_Output_Model.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class WindingJobStartScanScreen extends StatefulWidget {
  const WindingJobStartScanScreen({super.key});

  @override
  State<WindingJobStartScanScreen> createState() =>
      _WindingJobStartScanScreenState();
}

class _WindingJobStartScanScreenState extends State<WindingJobStartScanScreen> {
  final TextEditingController machineNo = TextEditingController();
  final TextEditingController operatorName = TextEditingController();
  final TextEditingController batchNo = TextEditingController();
  final TextEditingController product = TextEditingController();
  final TextEditingController filmPackNo = TextEditingController();
  final TextEditingController paperCodeLot = TextEditingController();
  final TextEditingController ppFilmLot = TextEditingController();
  final TextEditingController foilLot = TextEditingController();
  final TextEditingController weight1 = TextEditingController();
  final TextEditingController weight2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  sendWdsReturnWeightInputModel? items;

  num target = 0.0;
  num weight = 0.0;
  DateTime startDate = DateTime.now();
//HelperDatabase
  DatabaseHelper databaseHelper = DatabaseHelper();
  final bool isSave = false;
  String text = "";

  bool callApi() {
    try {
      BlocProvider.of<LineElementBloc>(context).add(
        PostSendWindingStartReturnWeightEvent(
          sendWdsReturnWeightOutputModel(
              BATCH_NO: int.tryParse(
                batchNo.text.trim(),
              ),
              FILM_PACK_NO: int.tryParse(
                filmPackNo.text.trim(),
              ),
              MACHINE_NO: machineNo.text.trim(),
              OPERATOR_NAME: int.tryParse(
                operatorName.text.trim(),
              ),
              PRODUCT: int.tryParse(
                product.text.trim(),
              ),
              PAPER_CODE_LOT: paperCodeLot.text.trim(),
              PP_FILM_LOT: ppFilmLot.text.trim(),
              FOIL_LOT: foilLot.text.trim(),
              WEIGHT: weight,
              START_DATE: startDate.toString()),
        ),
      );
      return true;
    } catch (e) {
      print("Error ${e}");
      return false;
    }
  }

  void _checkValueController() async {
    if (machineNo.text.isNotEmpty ||
        operatorName.text.isNotEmpty ||
        batchNo.text.isNotEmpty ||
        product.text.isNotEmpty ||
        filmPackNo.text.isNotEmpty ||
        paperCodeLot.text.isNotEmpty ||
        ppFilmLot.text.isNotEmpty ||
        foilLot.text.isNotEmpty) {
      bool isCallApi = callApi();

      if (isCallApi == true) {
        bool isSaveLocal = await _saveDataLocalSqlite();
        if (isSaveLocal) {
          print(isSaveLocal);
          sendComplete();
        } else {
          EasyLoading.showError("Error [01]", duration: Duration(seconds: 5));
        }
      } else {
        EasyLoading.showError("Error[02]", duration: Duration(seconds: 5));
      }
    } else {
      EasyLoading.showError("Error[03]", duration: Duration(seconds: 5));
    }
  }

  void okBtnWeight() async {
    if (weight1.text.trim() == null ||
        weight1.text.trim().isEmpty ||
        weight2.text.trim() == null ||
        weight2.text.trim().isEmpty) {
      bool isSave = await _SaveWindingStartWithWeight();
      if (isSave) {
        EasyLoading.showSuccess('Save complete');
      } else {
        EasyLoading.showError('error[04]');
      }
    }
  }

  Future<bool> _SaveWindingStartWithWeight() async {
    var sm, s1, s2, bomp;
    try {
      var sql = await databaseHelper.queryDataSelect(
          select1: 'BatchNo',
          select2: 'MachineNo',
          formTable: 'WINDING_SHEET',
          where: 'BatchNo',
          keyAnd: 'start_end',
          value: 'S',
          intValue: int.tryParse(batchNo.text.trim()));

      var packNo = sql[0];
      //notsure
      if (packNo['PackNo'] == null ||
          packNo['PackNo']) // If ds.Tables("PACK_NO").Rows.Count <= 0 Then
      {
        var sqlInsertWINDING_SHEET =
            await databaseHelper.insertDataSheet('WINDING_SHEET', {
          'MachineNo': machineNo.text.trim(),
          'OperatorName': int.tryParse(
            operatorName.text.trim(),
          ),
          'BatchNo': int.tryParse(
            batchNo.text.trim(),
          ),
          'Product': int.tryParse(
            product.text.trim(),
          ),
          'PackNo': int.tryParse(
            filmPackNo.text.trim(),
          ),
          'PaperCore': paperCodeLot.text.trim(),
          'PPCore': ppFilmLot.text.trim(),
          'FoilCore': foilLot.text.trim(),
          'BatchStartDate': startDate.toString(),
          'Status': 'P',
          'start_end': 'S',
          'checkComplete': '0'
        });
      }
      //Weight
      var sqlWeight = await databaseHelper.queryDataSelect(
          select1: 'BatchNo',
          select2: 'MachineNo',
          formTable: 'WINDING_WEIGHT_SHEET',
          where: 'MachineNo',
          intValue: int.tryParse(machineNo.text.trim()));
      var MachineNo = sqlWeight[0];
      //Not Sure
      if (MachineNo['MachineNo'] == 0 || MachineNo['MachineNo'] == null) {
        var sql_specification = await databaseHelper.queryDataSelect(
            select1: 'SM',
            select2: 'S1',
            select3: 'S2',
            select4: 'BomP',
            formTable: 'SPECIFICATION_SHEET',
            where: 'IPE',
            stringValue: product.text.trim());
        if (sql_specification.length > 0) {
          var spec = sql_specification[0];

          if (spec['SM'] != null && spec['SM'].isNotEmpty) {
            sm = double.parse(spec['SM'].toString());
            sm = double.parse(sm.toStringAsFixed(2));
          }

          if (spec['S1'] != null && spec['S1'].isNotEmpty) {
            s1 = double.parse(spec['S1'].toString());
            s1 = double.parse(s1.toStringAsFixed(2));
          }

          if (spec['S2'] != null && spec['S2'].isNotEmpty) {
            s2 = double.parse(spec['S2'].toString());
            s2 = double.parse(s2.toStringAsFixed(2));
          }

          if (spec['BomP'] != null && spec['BomP'].isNotEmpty) {
            bomp = double.parse(spec['BomP'].toString());
            bomp = double.parse(bomp.toStringAsFixed(2));
          }
          target =
              double.parse(((weight - sm - s1 - s2) / bomp).toStringAsFixed(2));
        } else {
          target = weight;
        }
        await databaseHelper.insertDataSheet('WINDING_WEIGHT_SHEET', {
          'MachineNo': machineNo.text.trim(),
          'BatchNo': int.tryParse(batchNo.text.trim()),
          'Target': target
        });
      } else {
        var sql_specification = await databaseHelper.queryDataSelect(
            select1: 'SM',
            select2: 'S1',
            select3: 'S2',
            select4: 'BomP',
            formTable: 'SPECIFICATION_SHEET',
            where: 'IPE',
            stringValue: product.text.trim());
        if (sql_specification.length > 0) {
          var spec = sql_specification[0];

          if (spec['SM'] != null && spec['SM'].isNotEmpty) {
            sm = double.parse(spec['SM'].toString());
            sm = double.parse(sm.toStringAsFixed(2));
          }

          if (spec['S1'] != null && spec['S1'].isNotEmpty) {
            s1 = double.parse(spec['S1'].toString());
            s1 = double.parse(s1.toStringAsFixed(2));
          }

          if (spec['S2'] != null && spec['S2'].isNotEmpty) {
            s2 = double.parse(spec['S2'].toString());
            s2 = double.parse(s2.toStringAsFixed(2));
          }

          if (spec['BomP'] != null && spec['BomP'].isNotEmpty) {
            bomp = double.parse(spec['BomP'].toString());
            bomp = double.parse(bomp.toStringAsFixed(2));
          }
          target =
              double.parse(((weight - sm - s1 - s2) / bomp).toStringAsFixed(2));
        } else {
          target = weight;
        }
        await databaseHelper.updateWindingWeight(
            table: 'WIND_WEIGHT_SHEET',
            key1: 'BatchNo',
            yieldKey1: int.tryParse(
              batchNo.text.trim(),
            ),
            key2: 'Target',
            yieldKey2: target,
            whereKey: 'MachineNo',
            value: int.tryParse(machineNo.text.trim()));
      }

      return true;
    } catch (e) {
      EasyLoading.showError("error[04]", duration: Duration(seconds: 5));
      return false;
    }
  }

  Future<bool> _saveDataLocalSqlite() async {
    var sm, s1, s2, bomp;
    try {
      //Query
      var sql = await databaseHelper.queryDataSelect(
          select1: 'BatchNo',
          select2: 'MachineNo',
          formTable: 'WINDING_WEIGHT_SHEET',
          where: 'MachineNo',
          intValue: int.tryParse(machineNo.text.trim()));
      //CheckValueRow

      if (sql.length <= 0) {
        var sql_specification = await databaseHelper.queryDataSelect(
            select1: 'SM',
            select2: 'S1',
            select3: 'S2',
            select4: 'BomP',
            formTable: 'SPECIFICATION_SHEET',
            where: 'IPE',
            stringValue: product.text.trim());

        ///Spec

        if (sql_specification.length > 0) {
          var spec = sql_specification[0];

          if (spec['SM'] != null && spec['SM'].isNotEmpty) {
            sm = double.parse(spec['SM'].toString());
            sm = double.parse(sm.toStringAsFixed(2));
          }

          if (spec['S1'] != null && spec['S1'].isNotEmpty) {
            s1 = double.parse(spec['S1'].toString());
            s1 = double.parse(s1.toStringAsFixed(2));
          }

          if (spec['S2'] != null && spec['S2'].isNotEmpty) {
            s2 = double.parse(spec['S2'].toString());
            s2 = double.parse(s2.toStringAsFixed(2));
          }

          if (spec['BomP'] != null && spec['BomP'].isNotEmpty) {
            bomp = double.parse(spec['BomP'].toString());
            bomp = double.parse(bomp.toStringAsFixed(2));
          }
          target =
              double.parse(((weight - sm - s1 - s2) / bomp).toStringAsFixed(2));
        } else {
          target = weight;
        }

        ///WriteDataTolocalTable WindingWeightSheet
        await databaseHelper.writeTableWindingWeightSheet_ToSqlite(
            machineNo: int.parse(
              machineNo.text.trim(),
            ),
            batchNo: int.tryParse(batchNo.text.trim()),
            target: target);
      } else {
        var sql_specification = await databaseHelper.queryDataSelect(
            select1: 'SM',
            select2: 'S1',
            select3: 'S2',
            select4: 'BomP',
            formTable: 'SPECIFICATION_SHEET',
            where: 'IPE',
            stringValue: product.text.trim());
        if (sql_specification.length > 0) {
          var spec = sql_specification[0];

          if (spec['SM'] != null && spec['SM'].isNotEmpty) {
            sm = double.parse(spec['SM'].toString());
            sm = double.parse(sm.toStringAsFixed(2));
          }

          if (spec['S1'] != null && spec['S1'].isNotEmpty) {
            s1 = double.parse(spec['S1'].toString());
            s1 = double.parse(s1.toStringAsFixed(2));
          }

          if (spec['S2'] != null && spec['S2'].isNotEmpty) {
            s2 = double.parse(spec['S2'].toString());
            s2 = double.parse(s2.toStringAsFixed(2));
          }

          if (spec['BomP'] != null && spec['BomP'].isNotEmpty) {
            bomp = double.parse(spec['BomP'].toString());
            bomp = double.parse(bomp.toStringAsFixed(2));
          }
          target =
              double.parse(((weight - sm - s1 - s2) / bomp).toStringAsFixed(2));
        } else {
          target = weight;
        }
        await databaseHelper.updateWindingWeight(
            table: 'WIND_WEIGHT_SHEET',
            key1: 'BatchNo',
            yieldKey1: int.tryParse(
              batchNo.text.trim(),
            ),
            key2: 'Target',
            yieldKey2: target,
            whereKey: 'MachineNo',
            value: int.tryParse(machineNo.text.trim()));
      }
      await databaseHelper.deleteDataFromSQLite(
          tableName: 'WINDING_SHEET',
          where: 'BatchNo',
          id: int.tryParse(batchNo.text.trim()));

      return true;
    } catch (e) {
      print("Error SaveData ${e}");
      return false;
    }
  }

  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: BgWhite(
        textTitle: "Winding Job Start",
        body: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: MultiBlocListener(
              listeners: [
                BlocListener<LineElementBloc, LineElementState>(
                    listener: (context, state) {
                  if (state is PostSendWindingStartReturnWeightLoadingState) {
                    EasyLoading.show();
                  }
                  if (state is PostSendWindingStartReturnWeightLoadedState) {
                    EasyLoading.dismiss();
                    items = state.item;
                  }
                  if (state is PostSendWindingStartReturnWeightErrorState) {
                    EasyLoading.showError("error[05]");
                  }
                })
              ],
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
                              maxLength: 3,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            BoxInputField(
                              labelText: "Operator Name :",
                              controller: operatorName,
                              textInputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^[a-zA-Z0-9]+$')),
                                LengthLimitingTextInputFormatter(12),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            BoxInputField(
                              labelText: "Batch No :",
                              controller: batchNo,
                              type: TextInputType.number,
                              maxLength: 12,
                              textInputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            BoxInputField(
                              labelText: "Product",
                              controller: product,
                              maxLength: 5,
                              type: TextInputType.number,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            BoxInputField(
                              labelText: "Film Pack No :",
                              controller: filmPackNo,
                              type: TextInputType.number,
                              maxLength: 8,
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
                      bgColor: _formKey.currentState == null
                          ? COLOR_BLUE_DARK
                          : COLOR_RED,
                      text: Label(
                        "Send",
                        color: COLOR_WHITE,
                      ),
                      onPress: () => _checkValueController(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendComplete() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(child: Label("Batch No. : ${batchNo.text}")),
                Center(child: Label("Target. : ${items!.WEIGHT}")),
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
                          bgColor: COLOR_BLUE_DARK,
                          text: Label(
                            "OK",
                            color: COLOR_WHITE,
                          ),
                          onPress: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget _popupWeight() {
    return items?.RESULT == true
        ? AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(child: Label("Send complete.")),
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
                          bgColor: COLOR_BLUE_DARK,
                          text: Label(
                            "OK",
                            color: COLOR_WHITE,
                          ),
                          onPress: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : AlertDialog(
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
                            controller: weight1,
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
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
                            controller: weight2,
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
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
                          onPress: () => okBtnWeight(),
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
