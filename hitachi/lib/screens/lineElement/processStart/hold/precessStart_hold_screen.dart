import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/materialtraceModel.dart';
import 'package:hitachi/models-Sqlite/processModel.dart';
import 'package:hitachi/models/materialInput/materialOutputModel.dart';
import 'package:hitachi/models/processStart/processOutputModel.dart';

import 'package:hitachi/services/databaseHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ProcessStartHoldScreen extends StatefulWidget {
  const ProcessStartHoldScreen({super.key});

  @override
  State<ProcessStartHoldScreen> createState() => _ProcessStartHoldScreenState();
}

class _ProcessStartHoldScreenState extends State<ProcessStartHoldScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  ProcessStartDataSource? matTracDs;
  int? selectedRowIndex;
  DataGridRow? datagridRow;

  List<ProcessModel>? processModelSqlite;
  List<ProcessModel> processList = [];
  final TextEditingController _passwordController = TextEditingController();

  Color _colorSend = COLOR_GREY;
  Color _colorDelete = COLOR_GREY;

  int? index;
  int? allRowIndex;
  List<ProcessModel> selectAll = [];
  ////
  Future<List<ProcessModel>> _getProcessStart() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllRows('PROCESS_SHEET');
      List<ProcessModel> result =
          rows.map((row) => ProcessModel.fromMap(row)).toList();
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
        processList = result;
        matTracDs = ProcessStartDataSource(process: processList);
      });
    });
    super.initState();
  }

  // void deletedInfo() async {
  //   await databaseHelper.deletedRowSqlite(
  //       tableName: 'PROCESS_SHEET',
  //       columnName: 'ID',
  //       columnValue: processList![selectedRowIndex!].ID);
  // }

  void deletedInfo() async {
    if (index != null) {
      for (var row in selectAll) {
        await databaseHelper.deletedRowSqlite(
            tableName: 'PROCESS_SHEET', columnName: 'ID', columnValue: row.ID);
      }
    } else if (allRowIndex != null) {
      for (var row in processList!) {
        await databaseHelper.deletedRowSqlite(
          tableName: 'PROCESS_SHEET',
          columnName: 'ID',
          columnValue: row.ID,
        );
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return BgWhite(
        isHideAppBar: true,
        textTitle: "Material Input",
        body: MultiBlocListener(
          listeners: [
            BlocListener<LineElementBloc, LineElementState>(
              listener: (context, state) {
                if (state is MaterialInputLoadingState) {
                  EasyLoading.show();
                } else if (state is MaterialInputLoadedState) {
                  if (state.item.RESULT == true) {
                    deletedInfo();
                    Navigator.canPop(context);
                    EasyLoading.dismiss();
                    EasyLoading.showSuccess("Send complete",
                        duration: Duration(seconds: 3));
                  } else {
                    EasyLoading.showError("Please Check Data");
                  }
                } else {
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
                                    matTracDs!.effectiveRows.length) {
                                  print("all");
                                  setState(() {
                                    selectRow.forEach((row) {
                                      allRowIndex =
                                          matTracDs!.effectiveRows.indexOf(row);

                                      _colorSend = COLOR_SUCESS;
                                      _colorDelete = COLOR_RED;
                                    });
                                  });
                                } else if (selectRow.length !=
                                    matTracDs!.effectiveRows.length) {
                                  setState(() {
                                    index = selectRow.isNotEmpty
                                        ? matTracDs!.effectiveRows
                                            .indexOf(selectRow.first)
                                        : null;
                                    datagridRow = matTracDs!.effectiveRows
                                        .elementAt(index!);
                                    processModelSqlite = datagridRow!
                                        .getCells()
                                        .map(
                                          (e) => ProcessModel(
                                            MACHINE: e.value.toString(),
                                          ),
                                        )
                                        .toList();
                                    // selectAll.add(wdsList[index!]);
                                    if (!selectAll
                                        .contains(processList[index!])) {
                                      selectAll.add(processList[index!]);
                                      print(selectAll.length);
                                    }
                                    _colorSend = COLOR_SUCESS;
                                    _colorDelete = COLOR_RED;
                                  });
                                }
                              } else {
                                setState(() {
                                  if (selectAll.contains(processList[index!])) {
                                    selectAll.remove(processList[index!]);
                                    print("check ${selectAll.length}");
                                  }
                                  if (selectAll.isEmpty) {
                                    _colorSend = Colors.grey;
                                    _colorDelete = Colors.grey;
                                  }
                                });

                                print('No Rows Selected');
                              }
                            },
                            columns: <GridColumn>[
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
                              GridColumn(
                                columnName: 'Operatorname3',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Operatorname3',
                                        color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'BatchNO',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Batch/Serial',
                                        color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'StartDate',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('Start Date', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : CircularProgressIndicator(),
                const SizedBox(height: 20),
                processModelSqlite != null
                    ? Expanded(
                        child: Container(
                            child: ListView(
                          children: [
                            DataTable(
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
                                    DataCell(Center(child: Label("Machine"))),
                                    DataCell(
                                        Label("${processList[index!].MACHINE}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Center(child: Label("Operator Name"))),
                                    DataCell(Label(
                                        "${processList[index!].OPERATOR_NAME}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Center(child: Label("Operator Name1"))),
                                    DataCell(Label(
                                        "${processList[index!].OPERATOR_NAME1}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Center(child: Label("Operator Name2"))),
                                    DataCell(Label(
                                        "${processList[index!].OPERATOR_NAME2}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Center(child: Label("Operator Name3"))),
                                    DataCell(Label(
                                        "${processList[index!].OPERATOR_NAME3}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Center(
                                        child: Label("Batch/Serial No."))),
                                    DataCell(Label(
                                        "${processList[index!].BATCH_NO}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Center(child: Label("Start Date."))),
                                    DataCell(Label(
                                        "${processList[index!].STARTDATE}"))
                                  ]),
                                ])
                          ],
                        )),
                      )
                    : Expanded(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Label(
                                "No data",
                                color: COLOR_RED,
                                fontSize: 30,
                              ),
                              CircularProgressIndicator()
                            ],
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: Button(
                      onPress: () {
                        if (processModelSqlite != null) {
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
                        _sendDataServer();
                        // if (processModelSqlite != null) {
                        //   BlocProvider.of<LineElementBloc>(context).add(
                        //     ProcessStartEvent(
                        //       ProcessOutputModel(
                        //         MACHINE:
                        //             processList![selectedRowIndex!].MACHINE,
                        //         OPERATORNAME: int.tryParse(
                        //             processList![selectedRowIndex!]
                        //                 .OPERATOR_NAME
                        //                 .toString()),
                        //         OPERATORNAME1: int.tryParse(
                        //             processList![selectedRowIndex!]
                        //                 .OPERATOR_NAME1
                        //                 .toString()),
                        //         OPERATORNAME2: int.tryParse(
                        //             processList![selectedRowIndex!]
                        //                 .OPERATOR_NAME2
                        //                 .toString()),
                        //         OPERATORNAME3: int.tryParse(
                        //             processList![selectedRowIndex!]
                        //                 .OPERATOR_NAME3
                        //                 .toString()),
                        //         BATCHNO:
                        //             processList![selectedRowIndex!].BATCH_NO,
                        //         STARTDATE:
                        //             processList![selectedRowIndex!].STARTDATE,
                        //       ),
                        //     ),
                        //   );
                        // } else {
                        //   EasyLoading.showInfo("Please Select Data");
                        // }
                      },
                    )),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  void _sendDataServer() async {
    if (index != null) {
      for (var row in selectAll) {
        BlocProvider.of<LineElementBloc>(context).add(
          ProcessStartEvent(
            ProcessOutputModel(
              MACHINE: row.MACHINE,
              OPERATORNAME: int.tryParse(row.OPERATOR_NAME.toString()),
              OPERATORNAME1: int.tryParse(
                row.OPERATOR_NAME1.toString(),
              ),
              OPERATORNAME2: int.tryParse(
                row.OPERATOR_NAME2.toString(),
              ),
              OPERATORNAME3: int.tryParse(
                row.OPERATOR_NAME3.toString(),
              ),
              BATCHNO: row.BATCH_NO.toString(),
              STARTDATE: row.STARTDATE.toString(),
            ),
          ),
        );
      }
    } else if (allRowIndex != null) {
      for (var row in processList) {
        BlocProvider.of<LineElementBloc>(context).add(
          ProcessStartEvent(
            ProcessOutputModel(
              MACHINE: row.MACHINE,
              OPERATORNAME: int.tryParse(row.OPERATOR_NAME.toString()),
              OPERATORNAME1: int.tryParse(
                row.OPERATOR_NAME1.toString(),
              ),
              OPERATORNAME2: int.tryParse(
                row.OPERATOR_NAME2.toString(),
              ),
              OPERATORNAME3: int.tryParse(
                row.OPERATOR_NAME3.toString(),
              ),
              BATCHNO: row.BATCH_NO.toString(),
              STARTDATE: row.STARTDATE.toString(),
            ),
          ),
        );
      }
    }
  }

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
  ProcessStartDataSource({List<ProcessModel>? process}) {
    if (process != null) {
      for (var _item in process) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'Machine', value: _item.MACHINE),
              DataGridCell<String>(
                  columnName: 'Operatorname', value: _item.OPERATOR_NAME),
              DataGridCell<String>(
                  columnName: 'Operatorname1', value: _item.OPERATOR_NAME1),
              DataGridCell<String>(
                  columnName: 'Operatorname2', value: _item.OPERATOR_NAME2),
              DataGridCell<String>(
                  columnName: 'Operatorname3', value: _item.OPERATOR_NAME3),
              DataGridCell<int>(
                  columnName: 'BatchNO',
                  value: int.tryParse(_item.BATCH_NO.toString())),
              DataGridCell<String>(
                  columnName: 'StartDate', value: _item.STARTEND.toString()),
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
