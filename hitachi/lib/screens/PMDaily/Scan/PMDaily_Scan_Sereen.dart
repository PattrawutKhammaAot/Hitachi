// ignore_for_file: unrelated_type_equality_checks

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/blocs/pmDaily/pm_daily_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/pmdailyModel.dart';
import 'package:hitachi/models-Sqlite/processModel.dart';
import 'package:hitachi/models/ResponeDefault.dart';
import 'package:hitachi/models/pmdailyModel/PMDailyOutputModel.dart';
import 'package:hitachi/models/processStart/processInputModel.dart';
import 'package:hitachi/models/processStart/processOutputModel.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PMDaily_Screen extends StatefulWidget {
  const PMDaily_Screen({super.key});

  @override
  State<PMDaily_Screen> createState() => _PMDaily_ScreenState();
}

class _PMDaily_ScreenState extends State<PMDaily_Screen> {
  final TextEditingController checkpointController = TextEditingController();
  final TextEditingController operatorNameController = TextEditingController();

  DatabaseHelper databaseHelper = DatabaseHelper();

  //ResponeDefault
  ResponeDefault? items;
  PMDailyDataSource? PMDDs;
  List<PMDailyModel>? processList;
  bool _checkSendSqlite = false;
  String Focustxt = "";
  String valuetxtinput = "";
  Color? bgChange;

  final f1 = FocusNode();
  final f2 = FocusNode();

  // 'CheckPointPM': checkpointController.text.trim(),
  // 'Status': checkpointController.text.trim(),
  // 'StartDate

  // Future<bool> _getProcessStart() async {
  //   try {
  //     var sql_pmDailySheet = await databaseHelper.queryDataSelectProcess(
  //       select1: 'OperatorName'.trim(),
  //       select2: 'CheckPointPM'.trim(),
  //       select3: 'Status'.trim(),
  //       select4: 'StartDate'.trim(),
  //       formTable: 'PM_SHEET'.trim(),
  //       where: 'Machine'.trim(),
  //       stringValue: operatorNameController.text.trim(),
  //     );
  //     print(sql_pmDailySheet.length);
  //
  //     // if (sql_pmDailySheet[0]['Machine'] != MachineController.text.trim()) {
  //     if (sql_pmDailySheet.isEmpty) {
  //       print(operatorNameController.text.trim());
  //       print(sql_pmDailySheet.length);
  //       _saveSendSqlite();
  //     }
  //     return true;
  //   } catch (e) {
  //     print("Catch : ${e}");
  //     return false;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    f1.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PmDailyBloc, PmDailyState>(
          listener: (context, state) {
            if (state is PMDailyLoadingState) {
              EasyLoading.show();
              print("loading");
            }
            if (state is PMDailyLoadedState) {
              print("Loaded");

              EasyLoading.show(status: "Loaded");

              if (state.item.RESULT == true) {
                EasyLoading.showSuccess("SendComplete");
                _clearAllData();
              } else if (state.item.RESULT == false) {
                EasyLoading.showError("Can not send & save Data");
                items = state.item;
                // _getProcessStart();
                _saveSendSqlite();
                _clearAllData();
              } else {
                EasyLoading.showError("Can not Call API");
                // _getProcessStart();
                _saveSendSqlite();
                _clearAllData();
              }
            }
            if (state is PMDailyErrorState) {
              print("ERROR");
              EasyLoading.dismiss();
              // _getProcessStart();
              _saveSendSqlite();
              _clearAllData();
              EasyLoading.showError("Please Check Connection Internet");
            }
          },
        )
      ],
      child: BgWhite(
          isHideAppBar: true,
          textTitle: "Process Start",
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  RowBoxInputField(
                    labelText: "Operator Name : ",
                    height: 35,
                    controller: operatorNameController,
                    maxLength: 12,
                    focusNode: f1,
                    onEditingComplete: () {
                      if (operatorNameController.text.isNotEmpty) {
                        setState(() {
                          f2.requestFocus();
                        });
                      } else {
                        setState(() {
                          valuetxtinput = "User INVALID";
                        });
                      }
                    },
                    // enabled: _enabledCheckMachine,
                    // onChanged: (value) {
                    //   setState(() {
                    //     _enabledOperator = true;
                    //   });
                    // },
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    labelText: "Check Point : ",
                    height: 35,
                    maxLength: 12,
                    controller: checkpointController,
                    focusNode: f2,
                    onChanged: (value) {
                      if (operatorNameController.text.isNotEmpty &&
                          checkpointController.text.isNotEmpty) {
                        setState(() {
                          bgChange = COLOR_RED;
                        });
                      } else {
                        setState(() {
                          bgChange = Colors.grey;
                        });
                      }
                    },
                    // onEditingComplete: () => f4.requestFocus(),
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                  PMDDs != null
                      ? Expanded(
                          flex: 5,
                          child: Container(
                            child: SfDataGrid(
                              footerHeight: 10,
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              source: PMDDs!,
                              columnWidthMode: ColumnWidthMode.fill,
                              columns: [
                                GridColumn(
                                  width: 120,
                                  columnName: 'data',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label(
                                        'Data',
                                        color: COLOR_WHITE,
                                      ),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'no',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label(
                                        'No.',
                                        color: COLOR_WHITE,
                                      ),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  width: 120,
                                  columnName: 'order',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label(
                                        'Order',
                                        color: COLOR_WHITE,
                                      ),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  width: 120,
                                  columnName: 'b',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label(
                                        'B',
                                        color: COLOR_WHITE,
                                      ),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  width: 120,
                                  columnName: 'ipe',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label(
                                        'IPE',
                                        color: COLOR_WHITE,
                                      ),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  width: 120,
                                  columnName: 'qty',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label(
                                        'QTY',
                                        color: COLOR_WHITE,
                                      ),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  width: 120,
                                  columnName: 'remark',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label(
                                        'Remark',
                                        color: COLOR_WHITE,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            Visibility(
                              visible: true,
                              child: Container(
                                  child: Label(
                                valuetxtinput,
                                color: COLOR_RED,
                              )),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Button(
                          onPress: () => _btnLoad(),
                          text: Label(
                            "Load Status",
                            color: COLOR_WHITE,
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 3,
                        child: Button(
                          onPress: () => _btnSend(),
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

  void _saveSendSqlite() async {
    try {
      if (operatorNameController.text.isNotEmpty) {
        await databaseHelper.insertSqlite('PROCESS_SHEET', {
          'OperatorName': operatorNameController.text.trim(),
          'CheckPointPM': checkpointController.text.trim(),
          'Status': checkpointController.text.trim(),
          'StartDate': DateTime.now().toString(),
        });
        print("ok");
      }
    } catch (e) {
      print(e);
    }
  }

  void _btnLoad() {
    BlocProvider.of<PmDailyBloc>(context).add(
      PMDailySendEvent(batchNoController.text.trim()),
    );
    // widget.onChange!(operatorNameController.text.trim());
  }

  void _btnSend() async {
    if (checkpointController.text.isNotEmpty &&
        operatorNameController.text.isNotEmpty) {
      _callAPI();
      // _checkSendSqlite();
      // _saveDataToSqlite();
    } else {
      EasyLoading.showInfo("กรุณาใส่ข้อมูลให้ครบ");
    }
  }

  void _callAPI() {
    BlocProvider.of<PmDailyBloc>(context).add(
      PMDailySendEvent(PMDailyOutputModel(
        OPERATORNAME: int.tryParse(operatorNameController.text.trim()),
        CHECKPOINT: checkpointController.text.trim(),
        STATUS: checkpointController.text.trim(),
        STARTDATE: DateTime.now().toString(),
      )),
    );
  }

  void _clearAllData() async {
    try {
      operatorNameController.text = "";
      checkpointController.text = "";
    } catch (e) {
      print(e);
    }
  }
}

class PMDailyDataSource extends DataGridSource {
  PMDailyDataSource({List<PMDailyModel>? process}) {
    if (process != null) {
      for (var _item in process) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<String>(
                  columnName: 'Operatorname', value: _item.OPERATOR_NAME),
              DataGridCell<String>(
                  columnName: 'Checkpoint', value: _item.CHECKPOINT),
              DataGridCell<String>(columnName: 'Status', value: _item.STATUS),
              DataGridCell<String>(
                  columnName: 'StartDate', value: _item.STARTDATE),
            ],
          ),
        );
      }
    } else {
      EasyLoading.showError("Can not request Data");
    }
  }

  List<DataGridRow> _employees = [];

  @override
  List<DataGridRow> get rows => _employees;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (dataGridCell) {
          return Container(
            alignment: (dataGridCell.columnName == 'id' ||
                    dataGridCell.columnName == 'qty')
                ? Alignment.center
                : Alignment.center,
            child: Text(dataGridCell.value.toString()),
          );
        },
      ).toList(),
    );
  }
}
