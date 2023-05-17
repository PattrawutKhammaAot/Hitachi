import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/zincthickness/zinc_thickness_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/zincthickness/zincOutputModel.dart';
import 'package:hitachi/services/databaseHelper.dart';

class ZincThickNessScanScreen extends StatefulWidget {
  const ZincThickNessScanScreen({super.key});

  @override
  State<ZincThickNessScanScreen> createState() =>
      _ZincThickNessScanScreenState();
}

class _ZincThickNessScanScreenState extends State<ZincThickNessScanScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _thickness1Controller = TextEditingController();
  final TextEditingController _thickness2Controller = TextEditingController();
  final TextEditingController _thickness3Controller = TextEditingController();
  final TextEditingController _thickness4Controller = TextEditingController();
  final TextEditingController _thickness6Controller = TextEditingController();
  final TextEditingController _thickness7Controller = TextEditingController();
  final TextEditingController _thickness8Controller = TextEditingController();
  final TextEditingController _thickness9Controller = TextEditingController();
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

  Color t1 = Colors.black;
  Color t2 = Colors.black;
  Color t3 = Colors.black;
  Color t4 = Colors.black;
  Color t6 = Colors.black;
  Color t7 = Colors.black;
  Color t8 = Colors.black;
  Color t9 = Colors.black;

  Color bgButton = Colors.grey;

  // void _getDataZincThickness({String? batch}) async {
  //   try {
  //     var sql = databaseHelper.fetchZincThickness(batch: batch);
  //   } catch (e, s) {
  //     EasyLoading.showError("Can not Save");
  //   }
  // }

  void _txtBatch() async {
    var sql = await databaseHelper.fetchZincThickness(
        batch: _batchController.text.trim());
    if (sql.length > 0) {
      setState(() {
        _thickness1Controller.text = sql[0]['Thickness1'].toString();
        _thickness2Controller.text = sql[0]['Thickness2'].toString();
        _thickness3Controller.text = sql[0]['Thickness3'].toString();
        _thickness4Controller.text = sql[0]['Thickness4'].toString();
        _thickness6Controller.text = sql[0]['Thickness6'].toString();
        _thickness7Controller.text = sql[0]['Thickness7'].toString();
        _thickness8Controller.text = sql[0]['Thickness8'].toString();
        _thickness9Controller.text = sql[0]['Thickness9'].toString();
      });
    }
  }

  void _callApi() {
    String? th1;
    String? th2;
    String? th3;
    String? th4;
    String? th6;
    String? th7;
    String? th8;
    String? th9;
    setState(() {
      th1 = convertToDecimal(_thickness1Controller.text.trim()).toString();
      th2 = convertToDecimal(_thickness2Controller.text.trim()).toString();
      th3 = convertToDecimal(_thickness3Controller.text.trim()).toString();
      th4 = convertToDecimal(_thickness4Controller.text.trim()).toString();
      th6 = convertToDecimal(_thickness6Controller.text.trim()).toString();
      th7 = convertToDecimal(_thickness7Controller.text.trim()).toString();
      th8 = convertToDecimal(_thickness8Controller.text.trim()).toString();
      th9 = convertToDecimal(_thickness9Controller.text.trim()).toString();
    });
    BlocProvider.of<ZincThicknessBloc>(context).add(
      ZincThickNessSendEvent(ZincThicknessOutputModel(
// OPERATORNAME:int.tryParse(_)
          BATCHNO: _batchController.text.trim(),
          THICKNESS1: th1,
          THICKNESS2: th2,
          THICKNESS3: th3,
          THICKNESS4: th4,
          THICKNESS6: th6,
          THICKNESS7: th7,
          THICKNESS8: th8,
          THICKNESS9: th9,
          STARTDATE: DateTime.now().toString())),
    );
  }

  void _checkvalueController() async {
    if (_batchController.text.isNotEmpty &&
        _thickness1Controller.text.isNotEmpty &&
        _thickness2Controller.text.isNotEmpty &&
        _thickness3Controller.text.isNotEmpty &&
        _thickness4Controller.text.isNotEmpty &&
        _thickness6Controller.text.isNotEmpty &&
        _thickness7Controller.text.isNotEmpty &&
        _thickness8Controller.text.isNotEmpty &&
        _thickness9Controller.text.isNotEmpty) {
      convertValuesToDecimal();
    } else {
      EasyLoading.showError("Please Input Info");
    }
  }

  void _insertSqlite() async {
    await databaseHelper.insertSqlite('ZINCTHICKNESS_SHEET', {
      'Batch': _batchController.text.trim(),
      'Thickness1': _thickness1Controller.text.trim(),
      'Thickness2': _thickness2Controller.text.trim(),
      'Thickness3': _thickness3Controller.text.trim(),
      'Thickness4': _thickness4Controller.text.trim(),
      'Thickness6': _thickness6Controller.text.trim(),
      'Thickness7': _thickness7Controller.text.trim(),
      'Thickness8': _thickness8Controller.text.trim(),
      'Thickness9': _thickness9Controller.text.trim(),
      'DateData': DateTime.now().toString(),
    });
  }

  double convertToDecimal(String value) {
    double numericValue = double.parse(value);
    return numericValue / 10;
  }

  void convertValuesToDecimal() {
    setState(() {});
    _callApi();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ZincThicknessBloc, ZincThicknessState>(
          listener: (context, state) {
            if (state is ZincThicknessLoadingState) {
              EasyLoading.show(status: "Loading...");
            } else if (state is ZincThicknessLoadedState) {
              EasyLoading.dismiss();

              if (state.item.RESULT == true) {
                EasyLoading.showSuccess("Send complete & Save Complete",
                    duration: Duration(seconds: 3));
                _insertSqlite();
              } else if (state.item.RESULT == false) {
                EasyLoading.showError("Data not found & Save Complete");
                _insertSqlite();
              }
            }
            if (state is ZincThicknessErrorState) {
              EasyLoading.dismiss();
              EasyLoading.showError("Check connection & Save Complete");
              _insertSqlite();
            }
          },
        )
      ],
      child: BgWhite(
          isHideAppBar: true,
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  RowBoxInputField(
                    labelText: "Batch No. :",
                    controller: _batchController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: RowBoxInputField(
                          labelText: "1 = ",
                          controller: _thickness1Controller,
                          textColor: t1,
                          focusNode: f1,
                          onEditingComplete: () {
                            f2.requestFocus();
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                int countValue = 0;
                                countValue = int.parse(value);
                                if (countValue < 20 || countValue > 45) {
                                  t1 = COLOR_RED;
                                } else {
                                  t1 = COLOR_BLACK;
                                }
                              }
                            });
                          },
                          type: TextInputType.numberWithOptions(
                              decimal: true, signed: false),
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 2,
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: RowBoxInputField(
                          labelText: "6 = ",
                          controller: _thickness6Controller,
                          textColor: t6,
                          focusNode: f6,
                          onEditingComplete: () {
                            f7.requestFocus();
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                int countValue = 0;
                                countValue = int.parse(value);
                                if (countValue < 45 || countValue > 75) {
                                  t6 = COLOR_RED;
                                } else {
                                  t6 = COLOR_BLACK;
                                }
                              }
                            });
                          },
                          type: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 2,
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: RowBoxInputField(
                          labelText: "2 = ",
                          controller: _thickness2Controller,
                          textColor: t2,
                          focusNode: f2,
                          onEditingComplete: () {
                            f3.requestFocus();
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                int countValue = 0;
                                countValue = int.parse(value);
                                if (countValue < 20 || countValue > 45) {
                                  t2 = COLOR_RED;
                                } else {
                                  t2 = COLOR_BLACK;
                                }
                              }
                            });
                          },
                          type: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 2,
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: RowBoxInputField(
                          labelText: "7 = ",
                          controller: _thickness7Controller,
                          textColor: t7,
                          focusNode: f7,
                          onEditingComplete: () {
                            f8.requestFocus();
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                int countValue = 0;
                                countValue = int.parse(value);
                                if (countValue < 45 || countValue > 70) {
                                  t7 = COLOR_RED;
                                } else {
                                  t7 = COLOR_BLACK;
                                }
                              }
                            });
                          },
                          type: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 2,
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: RowBoxInputField(
                          labelText: "3 = ",
                          controller: _thickness3Controller,
                          textColor: t3,
                          focusNode: f3,
                          onEditingComplete: () {
                            f4.requestFocus();
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                int countValue = 0;
                                countValue = int.parse(value);
                                if (countValue < 20 || countValue > 45) {
                                  t3 = COLOR_RED;
                                } else {
                                  t3 = COLOR_BLACK;
                                }
                              }
                            });
                          },
                          type: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 2,
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: RowBoxInputField(
                          labelText: "8 = ",
                          controller: _thickness8Controller,
                          textColor: t8,
                          focusNode: f8,
                          onEditingComplete: () {
                            f9.requestFocus();
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                int countValue = 0;
                                countValue = int.parse(value);
                                if (countValue < 45 || countValue > 70) {
                                  t8 = COLOR_RED;
                                } else {
                                  t8 = COLOR_BLACK;
                                }
                              }
                            });
                          },
                          type: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 2,
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: RowBoxInputField(
                          labelText: "4 = ",
                          controller: _thickness4Controller,
                          textColor: t4,
                          focusNode: f4,
                          onEditingComplete: () {
                            f6.requestFocus();
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                int countValue = 0;
                                countValue = int.parse(value);
                                if (countValue < 20 || countValue > 45) {
                                  t4 = COLOR_RED;
                                } else {
                                  t4 = COLOR_BLACK;
                                }
                              }
                            });
                          },
                          type: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 2,
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: RowBoxInputField(
                          labelText: "9 = ",
                          controller: _thickness9Controller,
                          textColor: t9,
                          focusNode: f9,
                          onEditingComplete: () {
                            _checkvalueController();
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                int countValue = 0;
                                countValue = int.parse(value);
                                if (countValue < 45 || countValue > 70) {
                                  t9 = COLOR_RED;
                                } else {
                                  t9 = COLOR_BLACK;
                                }
                              }
                              if (_batchController.text.isNotEmpty &&
                                  _thickness1Controller.text.isNotEmpty &&
                                  _thickness2Controller.text.isNotEmpty &&
                                  _thickness3Controller.text.isNotEmpty &&
                                  _thickness4Controller.text.isNotEmpty &&
                                  _thickness6Controller.text.isNotEmpty &&
                                  _thickness7Controller.text.isNotEmpty &&
                                  _thickness8Controller.text.isNotEmpty &&
                                  _thickness9Controller.text.isNotEmpty) {
                                bgButton = COLOR_SUCESS;
                              } else {
                                bgButton = Colors.grey;
                              }
                            });
                          },
                          type: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 2,
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Button(
                          bgColor: COLOR_RED,
                          onPress: () {
                            setState(() {
                              _thickness1Controller.text = '';
                              _thickness2Controller.text = '';
                              _thickness3Controller.text = '';
                              _thickness4Controller.text = '';
                              _thickness6Controller.text = '';
                              _thickness7Controller.text = '';
                              _thickness8Controller.text = '';
                              _thickness9Controller.text = '';
                              f1.requestFocus();
                            });
                          },
                          text: Label(
                            "Clear",
                            color: COLOR_WHITE,
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 3,
                        child: Button(
                          bgColor: bgButton,
                          onPress: () => _checkvalueController(),
                          text: Label(
                            "Send",
                            color: COLOR_WHITE,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
