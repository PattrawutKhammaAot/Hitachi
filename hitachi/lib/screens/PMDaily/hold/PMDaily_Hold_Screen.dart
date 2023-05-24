import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/blocs/pmDaily/pm_daily_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/materialtraceModel.dart';
import 'package:hitachi/models-Sqlite/pmdailyModel.dart';
import 'package:hitachi/models-Sqlite/processModel.dart';
import 'package:hitachi/models/materialInput/materialOutputModel.dart';
import 'package:hitachi/models/processStart/processOutputModel.dart';

import 'package:hitachi/services/databaseHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PMdailyHold_Screen extends StatefulWidget {
  const PMdailyHold_Screen({super.key});

  @override
  State<PMdailyHold_Screen> createState() => _PMdailyHold_ScreenState();
}

class _PMdailyHold_ScreenState extends State<PMdailyHold_Screen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  ProcessStartDataSource? matTracDs;
  List<int> _index = [];
  DataGridRow? datagridRow;

  List<PMDailyModel>? PMDailySqlite;
  List<PMDailyModel> PMDailyList = [];
  final TextEditingController _passwordController = TextEditingController();

  Color _colorSend = COLOR_GREY;
  Color _colorDelete = COLOR_GREY;

  int? index;
  int? allRowIndex;
  List<PMDailyModel> selectAll = [];
  ////
  Future<List<PMDailyModel>> _getProcessStart() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllRows('PM_SHEET');
      // await databaseHelper.queryAllRows('PROCESS_SHEET');
      List<PMDailyModel> result =
          rows.map((row) => PMDailyModel.fromMap(row)).toList();
      return result;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  void initState() {
    _getProcessStart().then((result) {
      setState(() {
        PMDailyList = result;
        matTracDs = ProcessStartDataSource(process: PMDailyList);
      });
    });
    super.initState();
  }

  Future _refreshPage() async {
    await Future.delayed(Duration(seconds: 1), () {
      _getProcessStart().then((result) {
        setState(() {
          PMDailyList = result;
          matTracDs = ProcessStartDataSource(process: PMDailyList);
        });
      });
    });
  }

  void deletedInfo() async {
    setState(() {
      _index.forEach((element) async {
        await databaseHelper.deletedRowSqlite(
            tableName: 'PM_SHEET', columnName: 'ID', columnValue: element);
        _index.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BgWhite(
        isHideAppBar: true,
        textTitle: "Material Input",
        body: MultiBlocListener(
          listeners: [
            BlocListener<PmDailyBloc, PmDailyState>(
              listener: (context, state) {
                if (state is PMDailyLoadingState) {
                  EasyLoading.show();
                } else if (state is PMDailyLoadedState) {
                  if (state.item.RESULT == true) {
                    deletedInfo();
                    Navigator.canPop(context);
                    EasyLoading.dismiss();
                    EasyLoading.showSuccess("Send complete",
                        duration: Duration(seconds: 3));
                  } else {
                    EasyLoading.showError("Please Check Data");
                  }
                } else if (state is PMDailyErrorState) {
                  EasyLoading.dismiss();
                  EasyLoading.showError("Please Check Connection Internet");
                }
              },
            )
          ],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                matTracDs != null
                    ? Expanded(
                        child: Container(
                          child: SfDataGrid(
                            source: matTracDs!,
                            showCheckboxColumn: true,
                            selectionMode: SelectionMode.multiple,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            gridLinesVisibility: GridLinesVisibility.both,
                            allowPullToRefresh: true,
                            onSelectionChanged:
                                (selectRow, deselectedRows) async {
                              if (selectRow.isNotEmpty) {
                                if (selectRow.length ==
                                        matTracDs!.effectiveRows.length &&
                                    selectRow.length > 1) {
                                  setState(() {
                                    selectRow.forEach((row) {
                                      _index.add(int.tryParse(
                                          row.getCells()[0].value.toString())!);

                                      _colorSend = COLOR_SUCESS;
                                      _colorDelete = COLOR_RED;
                                    });
                                  });
                                } else {
                                  setState(() {
                                    _index.add(int.tryParse(selectRow.first
                                        .getCells()[0]
                                        .value
                                        .toString())!);
                                    datagridRow = selectRow.first;
                                    PMDailySqlite = datagridRow!
                                        .getCells()
                                        .map(
                                          (e) => PMDailyModel(),
                                        )
                                        .toList();
                                    print(_index);
                                    _colorSend = COLOR_SUCESS;
                                    _colorDelete = COLOR_RED;
                                  });
                                }
                              } else {
                                setState(() {
                                  if (deselectedRows.length > 1) {
                                    _index.clear();
                                  } else {
                                    _index.remove(int.tryParse(deselectedRows
                                        .first
                                        .getCells()[0]
                                        .value
                                        .toString())!);
                                  }
                                  _colorSend = Colors.grey;
                                  _colorDelete = Colors.grey;
                                });

                                print('No Rows Selected');
                              }
                            },
                            columns: <GridColumn>[
                              GridColumn(
                                visible: false,
                                columnName: 'ID',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label(
                                      'ID',
                                      color: COLOR_WHITE,
                                    ),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Machine',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label(
                                      'Machine',
                                      color: COLOR_WHITE,
                                    ),
                                  ),
                                ),
                              ),
                              GridColumn(
                                  columnName: 'Operatorname',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label('Operatorname',
                                          color: COLOR_WHITE),
                                    ),
                                  ),
                                  width: 100),
                              GridColumn(
                                  columnName: 'Operatorname1',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label('Operatorname1',
                                          color: COLOR_WHITE),
                                    ),
                                  ),
                                  width: 100),
                              GridColumn(
                                  columnName: 'Operatorname2',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label('Operatorname2',
                                          color: COLOR_WHITE),
                                    ),
                                  ),
                                  width: 100),
                            ],
                          ),
                        ),
                      )
                    : CircularProgressIndicator(),
                const SizedBox(height: 20),
                _index.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: 1,
                          itemBuilder: ((context, index) {
                            return DataTable(
                              horizontalMargin: 20,
                              headingRowHeight: 30,
                              dataRowHeight: 30,
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => COLOR_BLUE_DARK),
                              border: TableBorder.all(
                                width: 1.0,
                                color: COLOR_BLACK,
                              ),
                              columns: [
                                DataColumn(
                                  numeric: true,
                                  label: Label(
                                    "",
                                    color: COLOR_BLUE_DARK,
                                  ),
                                ),
                                DataColumn(label: Label(""))
                              ],
                              rows: [
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Machine No."))),
                                  DataCell(Label(
                                      "${PMDailyList.where((element) => element.ID == _index.first).first.OPERATOR_NAME}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("Operator Name"))),
                                  DataCell(Label(
                                      "${PMDailyList.where((element) => element.ID == _index.first).first.CHECKPOINT}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("Operator Name1"))),
                                  DataCell(Label(
                                      "${PMDailyList.where((element) => element.ID == _index.first).first.STATUS}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("Operator Name2"))),
                                  DataCell(Label(
                                      "${PMDailyList.where((element) => element.ID == _index.first).first.DATEPM}"))
                                ]),
                              ],
                            );
                          }),
                        ),
                      )
                    :
                    // CircularProgressIndicator(),
                    SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: Button(
                      onPress: () {
                        if (_index.isNotEmpty) {
                          _AlertDialog();
                        } else {
                          EasyLoading.showInfo("Please Select Data");
                        }
                      },
                      text: Label(
                        "Delete",
                        color: COLOR_WHITE,
                      ),
                      bgColor: _colorDelete,
                    )),
                    Expanded(child: Container()),
                    Expanded(
                        child: Button(
                      text: Label("Send", color: COLOR_WHITE),
                      bgColor: _colorSend,
                      onPress: () {
                        if (_index.isNotEmpty) {
                          // _sendDataServer();
                        } else {
                          EasyLoading.showInfo("Please Select Data");
                        }
                      },
                    )),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  // void _sendDataServer() async {
  //   _index.forEach((element) async {
  //     var row = processList.where((value) => value.ID == element).first;
  //     BlocProvider.of<LineElementBloc>(context).add(
  //       ProcessStartEvent(
  //         ProcessOutputModel(
  //           MACHINE: row.MACHINE,
  //           OPERATORNAME: int.tryParse(row.OPERATOR_NAME.toString()),
  //           OPERATORNAME1: int.tryParse(
  //             row.OPERATOR_NAME1.toString(),
  //           ),
  //           OPERATORNAME2: int.tryParse(
  //             row.OPERATOR_NAME2.toString(),
  //           ),
  //           OPERATORNAME3: int.tryParse(
  //             row.OPERATOR_NAME3.toString(),
  //           ),
  //           BATCHNO: row.BATCH_NO.toString(),
  //           STARTDATE: row.STARTDATE.toString(),
  //         ),
  //       ),
  //     );
  //   });
  // }

  void _AlertDialog() async {
    // EasyLoading.showError("Error[03]", duration: Duration(seconds: 5));//if password
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('AlertDialog Title'),
        content: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Please Input Password',
          ),
          controller: _passwordController,
        ),

        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_passwordController.text.trim().length > 6) {
                deletedInfo();

                Navigator.pop(context);
                Navigator.pop(context);
                EasyLoading.showSuccess("Delete Success");
              } else {
                EasyLoading.showError("Please Input Password");
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class ProcessStartDataSource extends DataGridSource {
  ProcessStartDataSource({List<PMDailyModel>? process}) {
    if (process != null) {
      for (var _item in process) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<int>(columnName: 'ID', value: _item.ID),
              DataGridCell<String>(
                  columnName: 'Machine', value: _item.OPERATOR_NAME),
              DataGridCell<String>(
                  columnName: 'Operatorname', value: _item.CHECKPOINT),
              DataGridCell<String>(
                  columnName: 'Operatorname1', value: _item.STATUS),
              DataGridCell<String>(
                  columnName: 'Operatorname2', value: _item.DATEPM),
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
