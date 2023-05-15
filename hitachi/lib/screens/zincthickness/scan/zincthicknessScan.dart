import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
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

  @override
  Widget build(BuildContext context) {
    return BgWhite(
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
                        labelText: "6 = ",
                        controller: _thickness6Controller,
                        textColor: t6,
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
                      ),
                    ),
                    Expanded(child: Container()),
                    Expanded(
                      flex: 2,
                      child: RowBoxInputField(
                        labelText: "8 = ",
                        controller: _thickness8Controller,
                        textColor: t8,
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
                      ),
                    ),
                    Expanded(child: Container()),
                    Expanded(
                      flex: 2,
                      child: RowBoxInputField(
                        labelText: "9 = ",
                        controller: _thickness9Controller,
                        textColor: t9,
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
                          });
                        },
                        type: TextInputType.number,
                        textInputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
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
                        onPress: () {},
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
                        onPress: () {},
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
        ));
  }
}
