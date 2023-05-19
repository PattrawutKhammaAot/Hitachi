import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/dataSheetModel.dart';
import 'package:hitachi/models-Sqlite/windingSheetModel.dart';
import 'package:hitachi/models/SendWds/SendWdsModel_Output.dart';
import 'package:hitachi/models/SendWds/sendWdsModel_input.dart';
import 'package:hitachi/models/checkPackNo_Model.dart';
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
  final TextEditingController machineNoController = TextEditingController();
  final TextEditingController operatorNameController = TextEditingController();
  final TextEditingController batchNoController = TextEditingController();
  final TextEditingController productController = TextEditingController();
  final TextEditingController filmPackNoController = TextEditingController();
  final TextEditingController paperCodeLotController = TextEditingController();
  final TextEditingController ppFilmLotController = TextEditingController();
  final TextEditingController foilLotController = TextEditingController();
  final TextEditingController weight1Controller = TextEditingController();
  final TextEditingController weight2Controller = TextEditingController();
//FOCUS
  final f1 = FocusNode();
  final f2 = FocusNode();
  final f3 = FocusNode();
  final f4 = FocusNode();
  final f5 = FocusNode();
  final f6 = FocusNode();
  final f7 = FocusNode();
  final f8 = FocusNode();
  final f9 = FocusNode();
  final f10 = FocusNode();
//
  ///
  final _formKey = GlobalKey<FormState>();

  sendWdsReturnWeightInputModel? items;
  CheckPackNoModel? packNoModel;

  //ModelSqltie

  num target = 0.0;
  num weight = 0.0;
  DateTime startDate = DateTime.now();
//HelperDatabase
  DatabaseHelper databaseHelper = DatabaseHelper();
  final bool isSave = false;
  String text = "";

  Color bgColor = Colors.grey;
//
  @override
  void initState() {
    f1.requestFocus();
    super.initState();
  }

  void _btnSendClick() async {
    if (machineNoController.text.isNotEmpty &&
        operatorNameController.text.isNotEmpty &&
        batchNoController.text.isNotEmpty &&
        productController.text.isNotEmpty &&
        filmPackNoController.text.isNotEmpty &&
        paperCodeLotController.text.isNotEmpty &&
        ppFilmLotController.text.isNotEmpty &&
        foilLotController.text.isNotEmpty) {
      callWindingStartReturnWeight();
    } else {
      EasyLoading.showError("Please Input Info",
          duration: Duration(seconds: 5));
    }
  }

  bool callWindingStartReturnWeight() {
    try {
      BlocProvider.of<LineElementBloc>(context).add(
        PostSendWindingStartReturnWeightEvent(
          sendWdsReturnWeightOutputModel(
              BATCH_NO: int.tryParse(
                batchNoController.text.trim(),
              ),
              FILM_PACK_NO: int.tryParse(
                filmPackNoController.text.trim(),
              ),
              MACHINE_NO: machineNoController.text.trim(),
              OPERATOR_NAME: int.tryParse(
                operatorNameController.text.trim(),
              ),
              PRODUCT: int.tryParse(
                productController.text.trim(),
              ),
              PAPER_CODE_LOT: paperCodeLotController.text.trim(),
              PP_FILM_LOT: ppFilmLotController.text.trim(),
              FOIL_LOT: foilLotController.text.trim(),
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

  Future<bool> _saveWindingStartOnlyWeight({num? weightValue}) async {
    var sm, s1, s2, bomp;
    setState(() {
      target = 0.0;
    });
    try {
      //Query
      var sql_windingSheet = await databaseHelper.queryDataSelect(
          select1: 'BatchNo',
          select2: 'MachineNo',
          formTable: 'WINDING_WEIGHT_SHEET',
          where: 'MachineNo',
          stringValue: machineNoController.text.trim());

      //CheckValueRow
      // var sql_machine = sql_windingSheet[0];
      if (sql_windingSheet.length == 0) {
        var sql_specification = await databaseHelper.queryDataSelect(
            select1: 'SM',
            select2: 'S1',
            select3: 'S2',
            select4: 'BomP',
            formTable: 'SPECIFICATION_SHEET',
            where: 'IPE',
            stringValue: productController.text.trim());

        ///Spec
        // var checkValueSpec = sql_specification[0];

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
          target = weightValue!;
        }

        ///WriteDataTolocalTable WindingWeightSheet
        await databaseHelper.writeTableWindingWeightSheet_ToSqlite(
            machineNo: machineNoController.text.trim(),
            batchNo: int.tryParse(batchNoController.text.trim()),
            target: target);
      } else {
        var sql_specification = await databaseHelper.queryDataSelect(
            select1: 'SM',
            select2: 'S1',
            select3: 'S2',
            select4: 'BomP',
            formTable: 'SPECIFICATION_SHEET',
            where: 'IPE',
            stringValue: productController.text.trim());
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
            table: 'WINDING_WEIGHT_SHEET',
            key1: 'BatchNo',
            yieldKey1: batchNoController.text.trim(),
            key2: 'Target',
            yieldKey2: target,
            whereKey: 'MachineNo',
            value: machineNoController.text.trim());
      }
      await databaseHelper.deleteDataFromSQLite(
          tableName: 'WINDING_SHEET',
          where: 'BatchNo',
          id: batchNoController.text.trim());

      return true;
    } catch (e) {
      print("Catch${e}");
      EasyLoading.showInfo("can not save and weight pass");
      return false;
    }
  }

  void okBtnWeight() async {
    if (weight1Controller.text.trim() != null ||
        weight1Controller.text.trim().isNotEmpty ||
        weight2Controller.text.trim() != null ||
        weight2Controller.text.trim().isNotEmpty) {
      ///

      num totalWeight = num.parse(weight1Controller.text.trim()) +
          num.parse(weight2Controller.text.trim());
      totalWeight = num.parse(totalWeight.toStringAsFixed(2));

      ///
      bool isSave = await _SaveWindingStartWithWeight(
          MACHINE_NO: machineNoController.text.trim(),
          OPERATOR_NAME: operatorNameController.text.trim(),
          BATCH_NO: batchNoController.text.trim(),
          PRODUCT: productController.text.trim(),
          PACK_NO: filmPackNoController.text.trim(),
          PAPER_CORE: paperCodeLotController.text.trim(),
          PP_CORE: ppFilmLotController.text.trim(),
          FOIL_CORE: foilLotController.text.trim(),
          BATCH_START_DATE: DateTime.now().toString(),
          weight: totalWeight);

      if (isSave) {
        EasyLoading.showSuccess('Save complete');
      } else {
        EasyLoading.showError('error[04]');
      }
    }
  }

  Future<bool> _SaveWindingStartWithWeight({
    String? MACHINE_NO,
    String? OPERATOR_NAME,
    String? BATCH_NO,
    String? PRODUCT,
    String? PACK_NO,
    String? PAPER_CORE,
    String? PP_CORE,
    String? FOIL_CORE,
    String? BATCH_START_DATE,
    num? weight,
  }) async {
    var sm, s1, s2, bomp;
    try {
      var sql_packNo = await databaseHelper.queryDataSelect(
          select1: 'BatchNo',
          select2: 'MachineNo',
          formTable: 'WINDING_SHEET',
          where: 'BatchNo',
          keyAnd: 'start_end',
          value: 'S',
          stringValue: BATCH_NO);

      //notsure
      if (sql_packNo.length <=
          0) // If ds.Tables("PACK_NO").Rows.Count <= 0 Then
      {
        var sqlInsertWINDING_SHEET =
            await databaseHelper.insertSqlite('WINDING_SHEET', {
          'MachineNo': MACHINE_NO,
          'OperatorName': OPERATOR_NAME,
          'BatchNo': BATCH_NO,
          'Product': PRODUCT,
          'PackNo': PACK_NO,
          'PaperCore': PAPER_CORE,
          'PPCore': PP_CORE,
          'FoilCore': FOIL_CORE,
          'BatchStartDate': BATCH_START_DATE,
          'Status': 'P',
          'start_end': 'S',
          'checkComplete': '0'
        });
      }
      //Weight
      var sql_machine = await databaseHelper.queryDataSelect(
          select1: 'BatchNo',
          select2: 'MachineNo',
          formTable: 'WINDING_WEIGHT_SHEET',
          where: 'MachineNo',
          stringValue: MACHINE_NO);

      //Not Sure
      if (sql_machine.length <= 0) {
        var sql_specification = await databaseHelper.queryDataSelect(
            select1: 'SM',
            select2: 'S1',
            select3: 'S2',
            select4: 'BomP',
            formTable: 'SPECIFICATION_SHEET',
            where: 'IPE',
            stringValue: PRODUCT.toString());
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
          target = double.parse(
              ((weight! - sm - s1 - s2) / bomp).toStringAsFixed(2));
        } else {
          target = weight!;
        }
        await databaseHelper.insertSqlite('WINDING_WEIGHT_SHEET',
            {'MachineNo': MACHINE_NO, 'BatchNo': BATCH_NO, 'Target': target});
      } else {
        var sql_specification = await databaseHelper.queryDataSelect(
            select1: 'SM',
            select2: 'S1',
            select3: 'S2',
            select4: 'BomP',
            formTable: 'SPECIFICATION_SHEET',
            where: 'IPE',
            stringValue: PRODUCT.toString());
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
          target = double.parse(
              ((weight! - sm - s1 - s2) / bomp).toStringAsFixed(2));
        } else {
          target = weight!;
        }
        await databaseHelper.updateWindingWeight(
            table: 'WINDING_WEIGHT_SHEET',
            key1: 'BatchNo',
            yieldKey1: BATCH_NO,
            key2: 'Target',
            yieldKey2: target,
            whereKey: 'MachineNo',
            value: MACHINE_NO);
      }

      ///ASDASD
      return true;
    } catch (e, s) {
      EasyLoading.showError("Can not save", duration: Duration(seconds: 5));
      print("Error ${e} Stack ${s}");
      return false;
    }
  }

  void checkFilmPackNo() {
    int? result = int.tryParse(filmPackNoController.text.trim());
    final text = filmPackNoController.text.trim();

    if (result != null) {
      BlocProvider.of<LineElementBloc>(context).add(
        GetCheckPackNoEvent(result),
      );
      f6.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: BgWhite(
        isHideAppBar: true,
        textTitle: "Winding Job Start",
        body: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 5, left: 30, right: 30),
            child: MultiBlocListener(
                listeners: [
                  BlocListener<LineElementBloc, LineElementState>(
                      listener: (context, state) {
                    if (state is PostSendWindingStartReturnWeightLoadingState) {
                      EasyLoading.show();
                    } else if (state
                        is PostSendWindingStartReturnWeightLoadedState) {
                      EasyLoading.dismiss();
                      setState(() {
                        items = state.item;
                        print(items!.WEIGHT);
                      });
                      if (items!.RESULT == true) {
                        _saveWindingStartOnlyWeight(weightValue: items!.WEIGHT);
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  backgroundColor: COLOR_WHITE,
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Label(
                                          "Batch No. :${batchNoController.text.trim()}"),
                                      Label("Target :${items!.WEIGHT}")
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Label('OK'),
                                    ),
                                  ],
                                ));
                      } else {
                        EasyLoading.showInfo(" Please Input Weight",
                            duration: Duration(seconds: 1));
                        _showpopUpWeight();
                      }
                    }
                    if (state is PostSendWindingStartReturnWeightErrorState) {
                      cannotSend();

                      _showpopUpWeight();
                    }
                    if (state is GetCheckPackLoadingState) {
                      EasyLoading.show();
                    } else if (state is GetCheckPackLoadedState) {
                      setState(() {
                        packNoModel = state.item;
                      });
                      if (packNoModel!.RESULT == true) {
                        EasyLoading.dismiss();
                        EasyLoading.showSuccess("Success");
                        setState(() {
                          bgColor = COLOR_SUCESS;
                        });
                      } else {
                        print("object");
                        EasyLoading.showError("Film Pack No not Found");
                        setState(() {
                          bgColor = COLOR_SUCESS;
                        });
                      }
                    }
                    if (state is GetCheckPackErrorState) {
                      EasyLoading.showError("Check Connection");
                    }
                  })
                ],
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BoxInputField(
                        focusNode: f1,
                        labelText: "Machine No :",
                        controller: machineNoController,
                        maxLength: 3,
                        onEditingComplete: () => f2.requestFocus(),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      BoxInputField(
                        focusNode: f2,
                        labelText: "Operator Name :",
                        controller: operatorNameController,
                        textInputFormatter: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^(?!.*\d{12})[a-zA-Z0-9]+$'),
                          ),
                        ],
                        onEditingComplete: () => f3.requestFocus(),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: BoxInputField(
                              focusNode: f3,
                              onEditingComplete: () => f4.requestFocus(),
                              labelText: "Batch No :",
                              controller: batchNoController,
                              type: TextInputType.number,
                              maxLength: 12,
                              textInputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 5,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: BoxInputField(
                              focusNode: f4,
                              onEditingComplete: () => f5.requestFocus(),
                              labelText: "Product",
                              controller: productController,
                              maxLength: 5,
                              type: TextInputType.number,
                              textInputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
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
                            flex: 5,
                            child: BoxInputField(
                              focusNode: f5,
                              onEditingComplete: () {
                                checkFilmPackNo();
                              },
                              labelText: "Film Pack No :",
                              controller: filmPackNoController,
                              type: TextInputType.number,
                              maxLength: 8,
                              maxLines: 2,
                              textInputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 5,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: BoxInputField(
                              focusNode: f6,
                              onEditingComplete: () => f7.requestFocus(),
                              labelText: "Paper Core Lot :",
                              controller: paperCodeLotController,
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
                            flex: 5,
                            child: BoxInputField(
                              focusNode: f7,
                              onEditingComplete: () => f8.requestFocus(),
                              labelText: "PP Film Lot :",
                              controller: ppFilmLotController,
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 5,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: BoxInputField(
                              focusNode: f8,
                              onEditingComplete: () {
                                _btnSendClick();
                              },
                              labelText: "Foil Lot:",
                              controller: foilLotController,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Button(
                          bgColor: bgColor,
                          text: Label(
                            "Send",
                            color: COLOR_WHITE,
                          ),
                          onPress: () {
                            _btnSendClick();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                )),
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
                Center(child: Label("Batch No. : ${batchNoController.text}")),
                Center(child: Label("Target. : 02")),
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

  void cannotSend() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(child: Label("CANNOT SEND")),
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

  void _showpopUpWeight() {
    showDialog(
        context: context,
        builder: (BuildContext builder) {
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
                            focusNode: f9,
                            controller: weight1Controller,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            onEditingComplete: () {
                              f10.requestFocus();
                            },
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
                            focusNode: f10,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            onEditingComplete: () {
                              okBtnWeight();
                            },
                            controller: weight2Controller,
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
                          onPress: () {
                            okBtnWeight();
                            Navigator.pop(context);
                          },
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
}
