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

class ZincThickNessHold extends StatefulWidget {
  const ZincThickNessHold({super.key});

  @override
  State<ZincThickNessHold> createState() => _ZincThickNessHoldState();
}

class _ZincThickNessHoldState extends State<ZincThickNessHold> {
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
  String? dateTime;
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

  void _queryData() async {
    var sql = await databaseHelper.queryAllRows('ZINCTHICKNESS_SHEET');
  }

  void _callApi() {
    BlocProvider.of<ZincThicknessBloc>(context).add(
      ZincThickNessSendEvent(ZincThicknessOutputModel(
// OPERATORNAME:int.tryParse(_)
          BATCHNO: _batchController.text.trim(),
          THICKNESS1: _thickness1Controller.text.trim(),
          THICKNESS2: _thickness2Controller.text.trim(),
          THICKNESS3: _thickness3Controller.text.trim(),
          THICKNESS4: _thickness4Controller.text.trim(),
          THICKNESS6: _thickness6Controller.text.trim(),
          THICKNESS7: _thickness7Controller.text.trim(),
          THICKNESS8: _thickness8Controller.text.trim(),
          THICKNESS9: _thickness9Controller.text.trim(),
          STARTDATE: dateTime)),
    );
  }

  void _checkvalueController() async {
    if (_batchController.text.isNotEmpty) {
      _getZincthicknessInSqlite();
    } else {
      EasyLoading.showError("Please Input Info");
    }
  }

  void _getZincthicknessInSqlite() async {
    if (_batchController.text.trim().isNotEmpty) {
      var sql = await databaseHelper.queryAllRows('ZINCTHICKNESS_SHEET');
      bool found = false;
      var items;
      for (items in sql) {
        if (_batchController.text.trim() == items['Batch'].trim()) {
          found = true;
          setState(() {
            _thickness1Controller.text = items['Thickness1'];
            _thickness2Controller.text = items['Thickness2'];
            _thickness3Controller.text = items['Thickness3'];
            _thickness4Controller.text = items['Thickness4'];
            _thickness6Controller.text = items['Thickness6'];
            _thickness7Controller.text = items['Thickness7'];
            _thickness8Controller.text = items['Thickness8'];
            _thickness9Controller.text = items['Thickness9'];
            dateTime = items['DateData'];
          });
          break;
        }
      }
      if (found) {
        setState(() {
          int? countValue1 =
              int.tryParse(_thickness1Controller.text.trim().toString());
          int? countValue2 =
              int.tryParse(_thickness2Controller.text.trim().toString());
          int? countValue3 =
              int.tryParse(_thickness3Controller.text.trim().toString());
          int? countValue4 =
              int.tryParse(_thickness4Controller.text.trim().toString());
          int? countValue6 =
              int.tryParse(_thickness6Controller.text.trim().toString());
          int? countValue7 =
              int.tryParse(_thickness7Controller.text.trim().toString());
          int? countValue8 =
              int.tryParse(_thickness8Controller.text.trim().toString());
          int? countValue9 =
              int.tryParse(_thickness9Controller.text.trim().toString());
          if (countValue1! < 20 || countValue1 > 45) {
            t1 = COLOR_RED;
          } else {
            t1 = COLOR_BLACK;
          }
          if (countValue2! < 20 || countValue2 > 45) {
            t2 = COLOR_RED;
          } else {
            t2 = COLOR_BLACK;
          }
          if (countValue3! < 20 || countValue3 > 45) {
            t3 = COLOR_RED;
          } else {
            t3 = COLOR_BLACK;
          }
          if (countValue4! < 20 || countValue4 > 45) {
            t4 = COLOR_RED;
          } else {
            t4 = COLOR_BLACK;
          }

          if (countValue6! < 45 || countValue6 > 70) {
            t6 = COLOR_RED;
          } else {
            t6 = COLOR_BLACK;
          }
          if (countValue7! < 45 || countValue7 > 70) {
            t7 = COLOR_RED;
          } else {
            t7 = COLOR_BLACK;
          }
          if (countValue8! < 45 || countValue8 > 70) {
            t8 = COLOR_RED;
          } else {
            t8 = COLOR_BLACK;
          }
          if (countValue9! < 45 || countValue9 > 70) {
            t9 = COLOR_RED;
          } else {
            t9 = COLOR_BLACK;
          }
          bgButton = COLOR_SUCESS;
        });
        _callApi();
        // ทำอย่างไรก็ตามเมื่อพบค่าที่ตรงกัน
      } else {
        EasyLoading.showError("Data not Found");
        setState(() {
          _thickness1Controller.text = '';
          _thickness2Controller.text = '';
          _thickness3Controller.text = '';
          _thickness4Controller.text = '';
          _thickness6Controller.text = '';
          _thickness7Controller.text = '';
          _thickness8Controller.text = '';
          _thickness9Controller.text = '';
          bgButton = Colors.grey;
        });
      }
    } else {
      EasyLoading.showError("Please Input Batch No");
    }
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
                EasyLoading.showSuccess("Send complete ",
                    duration: Duration(seconds: 3));
              } else if (state.item.RESULT == false) {
                EasyLoading.showError("Data not found ");
              }
            }
            if (state is ZincThicknessErrorState) {
              EasyLoading.dismiss();
              EasyLoading.showError("Check connection ");
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
                    onEditingComplete: () {
                      _getZincthicknessInSqlite();
                    },
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
                          enabled: false,
                          labelText: "1 = ",
                          controller: _thickness1Controller,
                          textColor: t1,
                          focusNode: f1,
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: RowBoxInputField(
                          enabled: false,
                          labelText: "6 = ",
                          controller: _thickness6Controller,
                          textColor: t6,
                          focusNode: f6,
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
                          enabled: false,
                          labelText: "2 = ",
                          controller: _thickness2Controller,
                          textColor: t2,
                          focusNode: f2,
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: RowBoxInputField(
                          enabled: false,
                          labelText: "7 = ",
                          controller: _thickness7Controller,
                          textColor: t7,
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
                          enabled: false,
                          labelText: "3 = ",
                          controller: _thickness3Controller,
                          textColor: t3,
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: RowBoxInputField(
                          enabled: false,
                          labelText: "8 = ",
                          controller: _thickness8Controller,
                          textColor: t8,
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
                          enabled: false,
                          labelText: "4 = ",
                          controller: _thickness4Controller,
                          textColor: t4,
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: RowBoxInputField(
                          enabled: false,
                          labelText: "9 = ",
                          controller: _thickness9Controller,
                          textColor: t9,
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
