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
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sqflite/sqflite.dart';

class WindingJobStartScanScreen extends StatefulWidget {
  WindingJobStartScanScreen(
      {super.key, this.onChange, required this.isCheckBarcode});
  ValueChanged<List<Map<String, dynamic>>>? onChange;
  bool isCheckBarcode;

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
  final TextEditingController filmSerialNoNoController =
      TextEditingController();
  final TextEditingController paperCodeLotController = TextEditingController();
  final TextEditingController ppFilmLotController = TextEditingController();
  final TextEditingController foilLotController = TextEditingController();
  final TextEditingController weight1Controller = TextEditingController();
  final TextEditingController weight2Controller = TextEditingController();
//FOCUS เขียนเหี้ยไรเนี้ยยย
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
  final filmSerialNoFocus = FocusNode();

  sendWdsReturnWeightInputModel? items;
  CheckPackNoModel? packNoModel;
  //ModelSqltie

  num target = 0.0;
  num _weight = 0.0;
  DateTime startDate = DateTime.now();
//HelperDatabase
  DatabaseHelper databaseHelper = DatabaseHelper();

  Color bgColor = Colors.grey;
//
  @override
  void initState() {
    f1.requestFocus();
    _getHold();
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
        foilLotController.text.isNotEmpty &&
        filmSerialNoNoController.text.isNotEmpty) {
      callWindingStartReturnWeight();
    } else {
      EasyLoading.showError("Please Input Info",
          duration: Duration(seconds: 5));
    }
  }

  void callWindingStartReturnWeight() {
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
              MACHINE_NO: machineNoController.text.trim().toUpperCase(),
              OPERATOR_NAME: int.tryParse(
                operatorNameController.text.trim(),
              ),
              PRODUCT: int.tryParse(
                productController.text.trim(),
              ),
              PAPER_CODE_LOT: paperCodeLotController.text.trim(),
              PP_FILM_LOT: ppFilmLotController.text.trim(),
              FOIL_LOT: foilLotController.text.trim(),
              FILM_SERIAL_NO: filmSerialNoNoController.text.trim(),
              WEIGHT: _weight,
              START_DATE:
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())),
        ),
      );
      print(filmPackNoController.text.trim());
    } catch (e) {
      print("Error ${e}");
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
      print("check1");
      if (sql_windingSheet.length <= 0) {
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
          print("Check2");
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
              ((_weight - sm - s1 - s2) / bomp).toStringAsFixed(2));
        } else {
          target = weightValue!;
        }

        ///WriteDataTolocalTable WindingWeightSheet
        await databaseHelper.writeTableWindingWeightSheet_ToSqlite(
            machineNo: machineNoController.text.trim(),
            batchNo: batchNoController.text.toUpperCase(),
            target: target);
      } else {
        print("check3");
        var sql_specification = await databaseHelper.queryDataSelect(
            select1: 'SM',
            select2: 'S1',
            select3: 'S2',
            select4: 'BomP',
            formTable: 'SPECIFICATION_SHEET',
            where: 'IPE',
            stringValue: productController.text.trim());
        if (sql_specification.length > 0) {
          print("check4");
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
              ((_weight - sm - s1 - s2) / bomp).toStringAsFixed(2));
        } else {
          target = _weight;
        }
        print("check5");
        await databaseHelper.updateWindingWeight(
            table: 'WINDING_WEIGHT_SHEET',
            key1: 'BatchNo',
            yieldKey1: batchNoController.text.trim(),
            key2: 'Target',
            yieldKey2: target,
            whereKey: 'MachineNo',
            value: machineNoController.text.trim());
      }
      print("check6");
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

  Future okBtnWeight() async {
    if (weight1Controller.text.trim().isNotEmpty &&
        weight2Controller.text.trim().isNotEmpty) {
      ///
      setState(() {
        _weight = num.parse(weight1Controller.text.trim()) +
            num.parse(weight2Controller.text.trim());
        _weight = num.parse(_weight.toStringAsFixed(2));
      });

      ///
      await _SaveWindingStartWithWeight(
          MACHINE_NO: machineNoController.text.trim(),
          OPERATOR_NAME: operatorNameController.text.trim(),
          BATCH_NO: batchNoController.text.trim(),
          PRODUCT: productController.text.trim(),
          PACK_NO: filmPackNoController.text.trim(),
          PAPER_CORE: paperCodeLotController.text.trim(),
          PP_CORE: ppFilmLotController.text.trim(),
          FOIL_CORE: foilLotController.text.trim(),
          FILM_SERIAL_NO: filmSerialNoNoController.text.trim(),
          BATCH_START_DATE: DateTime.now().toString(),
          weight: _weight);

      EasyLoading.showSuccess("Save Weight Complete\n Weight = ${_weight}",
          duration: Duration(seconds: 5));
      await _getHold();
      f5.requestFocus();
      Navigator.pop(context);
    } else {
      EasyLoading.showError("Please Input  Info");
    }
  }

  // Future _saveTarget() async {

  // }

  Future<bool> _SaveWindingStartWithWeight({
    String? MACHINE_NO,
    String? OPERATOR_NAME,
    String? BATCH_NO,
    String? PRODUCT,
    String? PACK_NO,
    String? PAPER_CORE,
    String? PP_CORE,
    String? FILM_SERIAL_NO,
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
          'FilmSerialNo': FILM_SERIAL_NO,
          'FoilCore': FOIL_CORE,
          'BatchStartDate':
              DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          'Status': 'P',
          'start_end': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          'checkComplete': '0'
        });
      }
      //Weight
      var sql_machine = await databaseHelper.queryDataSelect(
          select1: 'BatchNo',
          select2: 'MachineNo',
          formTable: 'WINDING_WEIGHT_SHEET',
          where: 'MachineNo',
          stringValue: machineNoController.text.trim());

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
        await databaseHelper.insertSqlite('WINDING_WEIGHT_SHEET', {
          'MachineNo': machineNoController.text.trim(),
          'BatchNo': batchNoController.text.trim(),
          'Target': items!.TARGET ?? "0"
        });
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
            yieldKey1: batchNoController.text.trim(),
            key2: 'Target',
            yieldKey2: items!.TARGET ?? 0,
            whereKey: 'MachineNo',
            value: machineNoController.text.trim());
      }

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
    }
  }

  Future _checkPackFilmOnSqlite() async {
    var sql = await databaseHelper.queryAllRows('WINDING_SHEET');
    bool isFound = false;
    if (sql.isNotEmpty) {
      for (var items in sql) {
        if (filmPackNoController.text.trim() == items['PackNo'].trim()) {
          isFound = true;
          break;
        }
      }
    }
    if (isFound == true) {
      _errorDialog(
          isHideCancle: false,
          text: Label("Pack No Duplicate"),
          onpressOk: () {
            filmPackNoController.clear();
            f5.requestFocus();
            Navigator.pop(context);
          });
    } else {
      print("No Duplicate");
      f6.requestFocus();
    }
  }

  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('WINDING_SHEET');
    setState(() {
      widget.onChange
          ?.call(sql.where((element) => element['Status'] == 'P').toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: BgWhite(
        isHideAppBar: true,
        body: Form(
          autovalidateMode: AutovalidateMode.always,
          child: Padding(
            padding: const EdgeInsets.only(top: 5, left: 30, right: 30),
            child: MultiBlocListener(
                listeners: [
                  BlocListener<LineElementBloc, LineElementState>(
                      listener: (context, state) async {
                    if (state is PostSendWindingStartReturnWeightLoadingState) {
                      EasyLoading.show(status: "Loading...");
                    } else if (state
                        is PostSendWindingStartReturnWeightLoadedState) {
                      EasyLoading.dismiss();
                      setState(() {
                        items = state.item;
                      });
                      if (items!.RESULT == true) {
                        // await _saveTarget();
                        await _saveWindingStartOnlyWeight(
                            weightValue: items!.TARGET);
                        Alert(
                          context: context,
                          type: AlertType.success,
                          title: "Send Complete",
                          desc: "Target: ${items!.TARGET!.toStringAsFixed(0)}",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "OK",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                            )
                          ],
                        ).show();

                        machineNoController.clear();
                        operatorNameController.clear();
                        batchNoController.clear();
                        productController.clear();
                        filmPackNoController.clear();
                        paperCodeLotController.clear();
                        ppFilmLotController.clear();
                        foilLotController.clear();
                        filmSerialNoNoController.clear();
                        f1.requestFocus();
                        setState(() {
                          bgColor = Colors.grey;
                        });
                      } else {
                        _errorDialog(
                            text: Label(
                                "${state.item.MESSAGE ?? "Check Connection\n Do you want to save data "}"),
                            onpressOk: () {
                              Navigator.pop(context);
                              _showpopUpWeight();
                            });
                      }
                    }
                    if (state is PostSendWindingStartReturnWeightErrorState) {
                      _showpopUpWeight();
                    }
                    if (state is GetCheckPackLoadingState) {
                      EasyLoading.show();
                    } else if (state is GetCheckPackLoadedState) {
                      EasyLoading.dismiss();
                      setState(() {
                        packNoModel = state.item;
                      });
                      if (packNoModel!.RESULT == true) {
                        EasyLoading.dismiss();
                        f6.requestFocus();
                      } else {
                        _errorDialog(
                            text: Label("${packNoModel?.MESSAGE}"),
                            onpressOk: () {
                              filmPackNoController.clear();
                              Navigator.pop(context);
                            });

                        setState(() {
                          bgColor = COLOR_BLUE_DARK;
                        });
                      }
                    }
                    if (state is GetCheckPackErrorState) {
                      await _checkPackFilmOnSqlite();
                      EasyLoading.dismiss();
                    }
                  }),
                ],
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: BoxInputField(
                              focusNode: f1,
                              labelText: "Machine No :",
                              controller: machineNoController,
                              maxLength: 3,
                              // onChanged: (value) {
                              //   print(widget.isCheckBarcode);
                              // },
                              onEditingComplete: () {
                                if (machineNoController.text.length == 3) {
                                  f2.requestFocus();
                                }
                              },
                            ),
                          ),
                          const Expanded(
                            child: SizedBox(
                              height: 5,
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: BoxInputField(
                              focusNode: f2,
                              labelText: "Operator :",
                              controller: operatorNameController,
                              type: TextInputType.number,
                              textInputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              onEditingComplete: () => f3.requestFocus(),
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
                            flex: 8,
                            child: BoxInputField(
                              focusNode: f3,
                              onEditingComplete: () {
                                if (batchNoController.text.length == 12) {
                                  f4.requestFocus();
                                }
                              },
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
                              maxLength: 5,
                              onEditingComplete: () {
                                if (productController.text.length == 5 &&
                                    productController.text !=
                                        batchNoController.text
                                            .substring(0, 5)) {
                                  f5.requestFocus();
                                } else {
                                  _errorDialog(
                                      onpressOk: () {
                                        productController.clear();
                                        Navigator.pop(context);
                                      },
                                      isHideCancle: false,
                                      text: Label(
                                        "Product Invalid format",
                                      ));
                                }
                              },
                              labelText: "Product",
                              controller: productController,
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
                                if (filmPackNoController.text.length == 8) {
                                  checkFilmPackNo();
                                }
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
                              onEditingComplete: () {
                                if (widget.isCheckBarcode) {
                                  var result = extractValueBetweenPI_DR(
                                      paperCodeLotController.text.trim());
                                  if (result != null) {
                                    if (result == "2GSB080025A0012") {
                                      // paperCodeLotController.text = result;
                                      filmSerialNoFocus.requestFocus();
                                    } else {
                                      _errorDialog(
                                          isHideCancle: false,
                                          text: Label(
                                              "Paper Core Lot Invalid format"),
                                          onpressOk: () {
                                            paperCodeLotController.clear();
                                            Navigator.pop(context);
                                          });
                                    }
                                  } else {
                                    _errorDialog(
                                        isHideCancle: false,
                                        text: Label(
                                            "Paper Core Lot Invalid format"),
                                        onpressOk: () {
                                          paperCodeLotController.clear();
                                          Navigator.pop(context);
                                        });
                                  }
                                } else {
                                  filmSerialNoFocus.requestFocus();
                                }
                              },
                              labelText: "Paper Core Lot :",
                              controller: paperCodeLotController,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      BoxInputField(
                        focusNode: filmSerialNoFocus,
                        onEditingComplete: () {
                          if (widget.isCheckBarcode) {
                            var result = extractValueBetweenPI_DR(
                                filmSerialNoNoController.text.trim());
                            if (result != null) {
                              if (result == "2GCA280337A0010" ||
                                  result == "2GCA280335A0010" ||
                                  result == "2GCA280341A0010" ||
                                  result == "2GCA280339A0010" ||
                                  result == "2GCA280333A0010") {
                                // filmSerialNoNoController.text = result;
                                f7.requestFocus();
                              } else {
                                _errorDialog(
                                    isHideCancle: false,
                                    text:
                                        Label("Film Serial No Invalid format"),
                                    onpressOk: () {
                                      filmSerialNoNoController.clear();
                                      Navigator.pop(context);
                                    });
                              }
                            } else {
                              _errorDialog(
                                  isHideCancle: false,
                                  text: Label("Film Serial No Invalid format"),
                                  onpressOk: () {
                                    filmSerialNoNoController.clear();
                                    Navigator.pop(context);
                                  });
                            }
                          } else {
                            f7.requestFocus();
                          }
                        },
                        labelText: "Film Serial No :",
                        controller: filmSerialNoNoController,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      BoxInputField(
                        focusNode: f7,
                        onEditingComplete: () {
                          if (widget.isCheckBarcode) {
                            var result = extractValueBetweenPI_DR(
                                ppFilmLotController.text.trim());
                            if (result != null) {
                              if (result == "2GCA100016A0110") {
                                // ppFilmLotController.text = result;
                                f8.requestFocus();
                              } else {
                                _errorDialog(
                                    isHideCancle: false,
                                    text: Label("PP Film Lot Invalid format"),
                                    onpressOk: () {
                                      ppFilmLotController.clear();
                                      Navigator.pop(context);
                                    });
                              }
                            } else {
                              _errorDialog(
                                  isHideCancle: false,
                                  text: Label("PP Film Lot Invalid format"),
                                  onpressOk: () {
                                    ppFilmLotController.clear();
                                    Navigator.pop(context);
                                  });
                            }
                          } else {
                            f8.requestFocus();
                          }
                        },
                        labelText: "PP Film Lot :",
                        controller: ppFilmLotController,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      BoxInputField(
                        focusNode: f8,
                        onEditingComplete: () {
                          if (widget.isCheckBarcode) {
                            var result = extractValueBetweenPI_DR(
                                foilLotController.text.trim());
                            if (result != null) {
                              if (result == "2GCA106819A0120") {
                                _btnSendClick();
                              } else {
                                _errorDialog(
                                    isHideCancle: false,
                                    text: Label("Foil Lot Invalid format"),
                                    onpressOk: () {
                                      foilLotController.clear();
                                      Navigator.pop(context);
                                    });
                              }
                            } else {
                              _errorDialog(
                                  isHideCancle: false,
                                  text: Label("Foil Lot Invalid format"),
                                  onpressOk: () {
                                    foilLotController.clear();
                                    Navigator.pop(context);
                                  });
                            }
                          } else {
                            _btnSendClick();
                          }
                        },
                        labelText: "Foil Lot:",
                        controller: foilLotController,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              bgColor = COLOR_BLUE_DARK;
                            });
                          } else {
                            setState(() {
                              bgColor = Colors.grey;
                            });
                          }
                        },
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
                                  RegExp(r'^\d*\.?\d*$')),
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
                                  RegExp(r'^\d*\.?\d*$')),
                            ],
                            onEditingComplete: () async {
                              await okBtnWeight();
                              await _getHold();
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
                          onPress: () async {
                            await okBtnWeight();
                            machineNoController.clear();
                            operatorNameController.clear();
                            batchNoController.clear();
                            productController.clear();
                            filmPackNoController.clear();
                            paperCodeLotController.clear();
                            ppFilmLotController.clear();
                            foilLotController.clear();
                            filmSerialNoNoController.clear();
                            f1.requestFocus();
                            setState(() {
                              bgColor = Colors.grey;
                            });
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

  String? extractValueBetweenPI_DR(String input) {
    try {
      int piIndex = input.indexOf('<PI>');
      int drIndex = input.indexOf('<DR>');

      if (piIndex != -1 && drIndex != -1 && drIndex > piIndex) {
        return input.toUpperCase().substring(piIndex + 4, drIndex);
      }
      return null;
    } catch (e) {
      print("Error extracting value: $e");
      return null;
    }
  }

  void _errorDialog(
      {Label? text,
      Function? onpressOk,
      Function? onpressCancel,
      bool isHideCancle = true}) async {
    // EasyLoading.showError("Error[03]", duration: Duration(seconds: 5));//if password
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('AlertDialog Title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: text,
            ),
          ],
        ),

        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: isHideCancle,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(COLOR_BLUE_DARK)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              Visibility(
                visible: isHideCancle,
                child: SizedBox(
                  width: 15,
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(COLOR_BLUE_DARK)),
                onPressed: () => onpressOk?.call(),
                child: const Text('OK'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
