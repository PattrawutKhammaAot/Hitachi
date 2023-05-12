import 'dart:ffi';

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
import 'package:hitachi/services/databaseHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ProcessFinishHoldScreen extends StatefulWidget {
  const ProcessFinishHoldScreen({super.key});

  @override
  State<ProcessFinishHoldScreen> createState() =>
      _ProcessFinishHoldScreenState();
}

class _ProcessFinishHoldScreenState extends State<ProcessFinishHoldScreen> {
  List<ProcessModel>? Process;
  DatabaseHelper databaseHelper = DatabaseHelper();
  ProcessStartDataSource? matTracDs;
  int? selectedRowIndex;
  DataGridRow? datagridRow;
  List<ProcessModel>? mtModel;
  final TextEditingController _passwordController = TextEditingController();

  ////
  Future<List<ProcessModel>> _getWindingSheet() async {
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
    _getWindingSheet().then((result) {
      setState(() {
        Process = result;
        matTracDs = ProcessStartDataSource(process: Process);
        getshow();
      });
    });
    super.initState();
  }

  void deletedInfo() async {
    await databaseHelper.deletedRowSqlite(
        tableName: 'PROCESS_SHEET',
        columnName: 'Machine',
        columnValue: Process![selectedRowIndex!].MATERIAL);
  }

  getshow() async {
    await databaseHelper.insertSqlite('PROCESS_SHEET', {
      'Machine': 1,
      'OperatorName': '2',
      'OperatorName1': '3',
      'OperatorName2': '3',
      'OperatorName3': '3',
      'BatchNo': 3,
      'StartDate': '4',
      'Garbage': '4',
      'FinDate': '5',
      'StartEnd': '5',
      'CheckComplete': '6',
    });
    print("---getshow---");
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
                  EasyLoading.dismiss();
                  EasyLoading.showSuccess("Send complete",
                      duration: Duration(seconds: 3));
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
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            gridLinesVisibility: GridLinesVisibility.both,
                            selectionMode: SelectionMode.multiple,
                            showCheckboxColumn: true,
                            onCellTap: (details) async {
                              if (details.rowColumnIndex.rowIndex != 0) {
                                setState(() {
                                  selectedRowIndex =
                                      details.rowColumnIndex.rowIndex - 1;
                                  datagridRow = matTracDs!.effectiveRows
                                      .elementAt(selectedRowIndex!);
                                  mtModel = datagridRow!
                                      .getCells()
                                      .map(
                                        (e) => ProcessModel(
                                          MATERIAL: e.value,
                                          OPERATOR_NAME: e.value.toString(),
                                          OPERATOR_NAME1: e.value.toString(),
                                          OPERATOR_NAME2: e.value.toString(),
                                          OPERATOR_NAME3: e.value.toString(),
                                          BATCH_NO: e.value,
                                          STARTDATE: e.value.toString(),
                                          GARBAGE: e.value.toString(),
                                          FINDATE: e.value.toString(),
                                          STARTEND: e.value.toString(),
                                        ),
                                      )
                                      .toList();
                                });
                                print(Process![selectedRowIndex!].MATERIAL);
                              }
                            },
                            columns: <GridColumn>[
                              GridColumn(
                                columnName: 'Material=',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label(
                                      'Material',
                                      color: COLOR_WHITE,
                                    ),
                                  ),
                                ),
                              ),
                              GridColumn(
                                  columnName: 'OperatorName',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label('OperatorName',
                                          color: COLOR_WHITE),
                                    ),
                                  ),
                                  width: 100),
                              GridColumn(
                                  columnName: 'OperatorName1',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label('OperatorName1',
                                          color: COLOR_WHITE),
                                    ),
                                  ),
                                  width: 100),
                              GridColumn(
                                  columnName: 'OperatorName2',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label('OperatorName2',
                                          color: COLOR_WHITE),
                                    ),
                                  ),
                                  width: 100),
                              GridColumn(
                                columnName: 'OperatorName3',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('OperatorName3',
                                        color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'BatchNo',
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
                                        Label('StartDate', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Garbage',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Garbage', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'FinDate',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('FinDate', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'StartEnd',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('StartEnd', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : CircularProgressIndicator(),
                const SizedBox(height: 20),
                mtModel != null
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
                                    DataCell(Center(child: Label("Material"))),
                                    DataCell(Label(
                                        "${Process![selectedRowIndex!].MATERIAL}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Center(child: Label("Operator Name"))),
                                    DataCell(Label(
                                        "${Process![selectedRowIndex!].OPERATOR_NAME}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Center(child: Label("Operator Name1"))),
                                    DataCell(Label(
                                        "${Process![selectedRowIndex!].OPERATOR_NAME1}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Center(child: Label("Operator Name2"))),
                                    DataCell(Label(
                                        "${Process![selectedRowIndex!].OPERATOR_NAME2}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Center(child: Label("Operator Name3"))),
                                    DataCell(Label(
                                        "${Process![selectedRowIndex!].OPERATOR_NAME3}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Center(
                                        child: Label("Batch/Serial No."))),
                                    DataCell(Label(
                                        "${Process![selectedRowIndex!].BATCH_NO}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Center(child: Label("StartDate"))),
                                    DataCell(Label(
                                        "${Process![selectedRowIndex!].STARTDATE}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Center(child: Label("Garbage"))),
                                    DataCell(Label(
                                        "${Process![selectedRowIndex!].GARBAGE}"))
                                  ])
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
                        if (mtModel != null) {
                          _AlertDialog();
                        }
                      },
                      text: Label(
                        "Delete",
                        color: COLOR_WHITE,
                      ),
                      bgColor: COLOR_RED,
                    )),
                    Expanded(
                        child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Label(
                            "Scan",
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 15,
                            child: VerticalDivider(
                              color: COLOR_BLACK,
                              thickness: 2,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => print("object"),
                            // Navigator.pushNamed(context,
                            // RouterList.WindingJobStart_Hold_Screen),
                            child: Label(
                              "Hold",
                              color: COLOR_BLACK,
                            ),
                          ),
                        ],
                      ),
                    )),
                    Expanded(
                        child: Button(
                      text: Label("Send", color: COLOR_WHITE),
                      bgColor: COLOR_SUCESS,
                      onPress: () {
                        BlocProvider.of<LineElementBloc>(context).add(
                          MaterialInputEvent(
                            MaterialOutputModel(
                              MATERIAL:
                                  Process![selectedRowIndex!].OPERATOR_NAME,
                              // MACHINENO:
                              // Process![selectedRowIndex!].MACHINE_NO,
                              OPERATORNAME: int.tryParse(
                                  Process![selectedRowIndex!]
                                      .OPERATOR_NAME
                                      .toString()),
                              BATCHNO: int.tryParse(Process![selectedRowIndex!]
                                  .BATCH_NO
                                  .toString()),
                              // LOT: Process![selectedRowIndex!].LOTNO_1,
                              STARTDATE: Process![selectedRowIndex!].STARTDATE,
                            ),
                          ),
                        );
                      },
                    )),
                  ],
                )
              ],
            ),
          ),
        ));
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
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_passwordController.text.trim().length > 6) {
                deletedInfo();
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
          // 'Machine': '1',
          // 'OperatorName': '2',
          // 'OperatorName1': '3',
          // 'OperatorName2': '3',
          // 'OperatorName3': '3',
          // 'BatchNo': '3',
          // 'StartDate': '4',
          // 'Garbage': '4',
          // 'FinDate': '5',
          // 'StartEnd': '5',
          // 'CheckComplete': '6',
          //

          DataGridRow(
            cells: [
              DataGridCell<int>(columnName: 'ID', value: _item.ID),
              DataGridCell<String>(
                  columnName: 'Machine', value: _item.MATERIAL),
              DataGridCell<String>(
                  columnName: 'OperatorName', value: _item.OPERATOR_NAME),
              DataGridCell<String>(
                  columnName: 'OperatorName1', value: _item.OPERATOR_NAME1),
              DataGridCell<String>(
                  columnName: 'OperatorName2', value: _item.OPERATOR_NAME2),
              DataGridCell<String>(
                  columnName: 'OperatorName3', value: _item.OPERATOR_NAME3),
              DataGridCell<int>(columnName: 'BatchNo', value: _item.BATCH_NO),
              DataGridCell<String>(
                  columnName: 'StartDate', value: _item.STARTDATE),
              DataGridCell<String>(columnName: 'Garbage', value: _item.GARBAGE),
              DataGridCell<String>(columnName: 'FinDate', value: _item.FINDATE),
              DataGridCell<String>(
                  columnName: 'StartEnd', value: _item.STARTEND),
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
