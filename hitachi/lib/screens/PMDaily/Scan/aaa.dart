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
  // final TextEditingController MachineController = TextEditingController();
  final TextEditingController operatorNameController = TextEditingController();
  final TextEditingController CheckPointController = TextEditingController();

  DatabaseHelper databaseHelper = DatabaseHelper();

  ResponeDefault? items;
  PMDailyDataSource? matTracDs;
  List<PMDailyModel>? processList;
  List<PMDailyModel>? processModelSqlite;
  String Focustxt = "";
  String valuetxtinput = "";
  Color? bgChange;
  int? selectedRowIndex;
  DataGridRow? datagridRow;

  final f1 = FocusNode();
  final f2 = FocusNode();

  Color _colorSend = COLOR_GREY;
  Color _colorDelete = COLOR_GREY;

  Future<bool> _getPMDailyStart() async {
    try {
      var sql_processSheet = await databaseHelper.queryDataSelectProcess(
          select1: 'Machine',
          select2: 'OperatorName',
          select3: 'OperatorName1',
          select4: 'OperatorName2',
          select5: 'OperatorName3',
          select6: 'BatchNo',
          formTable: 'PROCESS_SHEET',
          where: 'Machine',
          //stringValue: MachineController.text.trim(),
          stringValue: 'rwe');
      // );
      print(sql_processSheet.length);

      // if (sql_processSheet.length <= 0) {
      //   _saveSendSqlite();
      //   print("saveSendSqlite");
      // } else {
      //   print("ssssss");
      // }

      return true;
    } catch (e) {
      print("Catch : ${e}");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    f1.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LineElementBloc, LineElementState>(
          listener: (context, state) {
            if (state is ProcessStartLoadingState) {
              EasyLoading.show();
              print("loading");
            }
            if (state is ProcessStartLoadedState) {
              print("Loaded");

              EasyLoading.show(status: "Loaded");

              if (state.item.RESULT == true) {
                EasyLoading.showSuccess("SendComplete");
                _clearAllData();
              } else if (state.item.RESULT == false) {
                EasyLoading.showError("Can not send & save Data");
                // items = state.item;
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
            if (state is ProcessStartErrorState) {
              print("ERROR");
              EasyLoading.dismiss();
              //_saveSendSqlite();
              _getPMDailyStart();
              _clearAllData();
              EasyLoading.showError("Please Check Connection Internet");
            }
          },
        )
      ],
      child: BgWhite(
          isHideAppBar: true,
          textTitle: "PM Daily",
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  RowBoxInputField(
                    labelText: "Operator Name :",
                    height: 35,
                    controller: operatorNameController,
                    maxLength: 12,
                    focusNode: f1,
                    // enabled: _enabledCheckMachine,
                    onEditingComplete: () {
                      f2.requestFocus();
                    },
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    onChanged: (value) {
                      if (
                          //MachineController.text.isNotEmpty &&
                          CheckPointController.text.isNotEmpty) {
                        setState(() {
                          bgChange = COLOR_RED;
                        });
                      } else {
                        setState(() {
                          bgChange = Colors.grey;
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RowBoxInputField(
                    labelText: "Check Point :",
                    maxLength: 12,
                    height: 35,
                    controller: CheckPointController,
                    type: TextInputType.number,
                    focusNode: f2,
                    onChanged: (value) {
                      if (
                          //MachineController.text.isNotEmpty &&
                          operatorNameController.text.isNotEmpty) {
                        setState(() {
                          bgChange = COLOR_RED;
                        });
                      } else {
                        setState(() {
                          bgChange = Colors.grey;
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: SfDataGrid(
                      footerHeight: 10,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      source: matTracDs!,
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
                ],
              ),
            ),
          )),
    );
  }

  void _saveSendSqlite() async {
    try {
      if (operatorNameController.text.isNotEmpty) {
        await databaseHelper.insertSqlite('PM_SHEET', {
          'OperatorName': operatorNameController.text.trim(),
          'BatchNo': CheckPointController.text.trim(),
          'BatchNo': CheckPointController.text.trim(),
          'StartDate': DateTime.now().toString(),
        });
        print("ok");
      }
    } catch (e) {
      print(e);
    }
  }

  void _btnSend() async {
    if (operatorNameController.text.isNotEmpty &&
        CheckPointController.text.isNotEmpty) {
      // _callAPI();
      // _checkSendSqlite();
      // _saveDataToSqlite();
    } else {
      EasyLoading.showInfo("กรุณาใส่ข้อมูลให้ครบ");
    }
  }

  // void _callAPI() {
  //   BlocProvider.of<PMDailyBloc>(context).add(
  //     PMDailySendEvent(PMDailyOutputModel(
  //       OPERATORNAME: int.tryParse(operatorNameController.text.trim()),
  //       CHECKPOINT: CheckPointController.text.trim(),
  //       STATUS: CheckPointController.text.trim(),
  //       STARTDATE: DateTime.now().toString(),
  //     )),
  //   );
  // }

  void _clearAllData() async {
    try {
      operatorNameController.text = "";
      CheckPointController.text = "";
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
                  columnName: 'StartDate', value: _item.STARTDATE.toString()),
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
