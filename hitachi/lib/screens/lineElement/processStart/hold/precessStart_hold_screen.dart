import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/blocs/materialTrace/update_material_trace_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/materialtraceModel.dart';
import 'package:hitachi/models-Sqlite/processModel.dart';
import 'package:hitachi/models/materialInput/materialOutputModel.dart';
import 'package:hitachi/models/materialTraces/materialTraceUpdateModel.dart';
import 'package:hitachi/models/processCheck/processCheckModel.dart';
import 'package:hitachi/models/processStart/processOutputModel.dart';

import 'package:hitachi/services/databaseHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ProcessStartHoldScreen extends StatefulWidget {
  ProcessStartHoldScreen({super.key, this.onChange});
  ValueChanged<List<Map<String, dynamic>>>? onChange;

  @override
  State<ProcessStartHoldScreen> createState() => _ProcessStartHoldScreenState();
}

class _ProcessStartHoldScreenState extends State<ProcessStartHoldScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  ProcessStartDataSource? matTracDs;
  List<int> _index = [];
  DataGridRow? datagridRow;

  List<ProcessModel>? processModelSqlite;
  List<ProcessModel> processList = [];
  final TextEditingController _ipeController = TextEditingController();

  Color _colorSend = COLOR_GREY;
  Color _colorDelete = COLOR_GREY;

  int? index;
  int? allRowIndex;
  List<ProcessModel> selectAll = [];

  late Map<String, double> columnWidths = {
    'ID': double.nan,
    'Machine': double.nan,
    'Operatorname': double.nan,
    'Operatorname1': double.nan,
    'Operatorname2': double.nan,
    'Operatorname3': double.nan,
    'BatchNO': double.nan,
    'StartDate': double.nan,
    'peak': double.nan,
    'high': double.nan,
    'zinc': double.nan,
    'visual': double.nan,
    'clearing': double.nan,
    'clearing_v': double.nan,
    'missing': double.nan,
    'filing': double.nan,
  };

  Future<List<ProcessModel>> _getProcessStart() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllProcessStartRows('PROCESS_SHEET', 'S');
      // await databaseHelper.queryAllRows('PROCESS_SHEET');
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
    _getHold();
    _getProcessStart().then((result) {
      setState(() {
        processList = result;
        matTracDs = ProcessStartDataSource(process: processList);
      });
    });
    super.initState();
  }

  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('PROCESS_SHEET');
    setState(() {
      widget.onChange
          ?.call(sql.where((element) => element['StartEnd'] == 'S').toList());
    });
  }

  Future _refreshPage() async {
    await Future.delayed(Duration(seconds: 1), () {
      _getProcessStart().then((result) {
        setState(() {
          processList = result;
          matTracDs = ProcessStartDataSource(process: processList);
        });
      });
    });
  }

  Future deletedInfo() async {
    setState(() {
      _index.forEach((element) async {
        await databaseHelper.deletedRowSqlite(
            tableName: 'PROCESS_SHEET', columnName: 'ID', columnValue: element);
        _index.clear();
      });
    });
  }

  Future _refresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      _getProcessStart().then((result) {
        setState(() {
          processList = result;
          matTracDs = ProcessStartDataSource(process: processList);
        });
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return BgWhite(
        isHideAppBar: true,
        body: MultiBlocListener(
          listeners: [
            BlocListener<LineElementBloc, LineElementState>(
              listener: (context, state) async {
                if (state is ProcessStartLoadingState) {
                  EasyLoading.show(status: "Loading...");
                } else if (state is ProcessStartLoadedState) {
                  EasyLoading.dismiss();
                  if (state.item.RESULT == true) {
                    await deletedInfo();
                    await _refresh();
                    await _getHold();
                    EasyLoading.showSuccess("Send Complete",
                        duration: Duration(seconds: 3));
                  } else {
                    _errorDialog(
                        text: Label(
                            "${state.item.MESSAGE ?? "Check Connection"}"),
                        isHideCancle: false,
                        onpressOk: () {
                          Navigator.pop(context);
                        });
                  }
                } else if (state is ProcessStartErrorState) {
                  EasyLoading.dismiss();

                  _errorDialog(
                      text: Label("Check Connection"),
                      isHideCancle: false,
                      onpressOk: () async {
                        Navigator.pop(context);
                      });
                }
                if (state is GetIPEProdSpecByBatchLoadedState) {
                  if (state.item.IPE_NO != null) {
                    _ipeController.text = state.item.IPE_NO!;
                  }

                  setState(() {});
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
                            allowColumnsResizing: true,
                            columnResizeMode: ColumnResizeMode.onResizeEnd,
                            onColumnResizeUpdate:
                                (ColumnResizeUpdateDetails details) {
                              setState(() {
                                columnWidths[details.column.columnName] =
                                    details.width;
                                print(details.width);
                              });
                              return true;
                            },
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
                                    processModelSqlite = datagridRow!
                                        .getCells()
                                        .map(
                                          (e) => ProcessModel(),
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
                                  // _colorSend = Colors.grey;
                                  // _colorDelete = Colors.grey;
                                });

                                print('No Rows Selected');
                              }
                            },
                            columns: <GridColumn>[
                              GridColumn(
                                visible: false,
                                width: columnWidths['ID']!,
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
                                width: columnWidths['Machine']!,
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
                                width: columnWidths['Operatorname']!,
                                columnName: 'Operatorname',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Operatorname',
                                        color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['Operatorname1']!,
                                columnName: 'Operatorname1',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Operatorname1',
                                        color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['Operatorname2']!,
                                columnName: 'Operatorname2',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Operatorname2',
                                        color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['Operatorname3']!,
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
                                width: columnWidths['BatchNO']!,
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
                                width: columnWidths['peak']!,
                                columnName: 'peak',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Peak Current Withstands',
                                        color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['high']!,
                                columnName: 'high',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('High-Voltage Test',
                                        color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['StartDate']!,
                                columnName: 'StartDate',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('StartDate', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              // GridColumn(
                              //   width: columnWidths['zinc']!,
                              //   columnName: 'zinc',
                              //   label: Container(
                              //     color: COLOR_BLUE_DARK,
                              //     child: Center(
                              //       child: Label('Zinc Thickness',
                              //           color: COLOR_WHITE),
                              //     ),
                              //   ),
                              // ),
                              // GridColumn(
                              //   width: columnWidths['visual']!,
                              //   columnName: 'visual',
                              //   label: Container(
                              //     color: COLOR_BLUE_DARK,
                              //     child: Center(
                              //       child: Label('Visual Control',
                              //           color: COLOR_WHITE),
                              //     ),
                              //   ),
                              // ),
                              // GridColumn(
                              //   width: columnWidths['clearing_v']!,
                              //   columnName: 'clearing_v',
                              //   label: Container(
                              //     color: COLOR_BLUE_DARK,
                              //     child: Center(
                              //       child: Label('Clearing Visual Control',
                              //           color: COLOR_WHITE),
                              //     ),
                              //   ),
                              // ),
                              // GridColumn(
                              //   width: columnWidths['clearing']!,
                              //   columnName: 'clearing',
                              //   label: Container(
                              //     color: COLOR_BLUE_DARK,
                              //     child: Center(
                              //       child:
                              //           Label('Clearing', color: COLOR_WHITE),
                              //     ),
                              //   ),
                              // ),
                              // GridColumn(
                              //   width: columnWidths['missing']!,
                              //   columnName: 'missing',
                              //   label: Container(
                              //     color: COLOR_BLUE_DARK,
                              //     child: Center(
                              //       child: Label('Missing  Ratio',
                              //           color: COLOR_WHITE),
                              //     ),
                              //   ),
                              // ),
                              // GridColumn(
                              //   width: columnWidths['filing']!,
                              //   columnName: 'filing',
                              //   label: Container(
                              //     color: COLOR_BLUE_DARK,
                              //     child: Center(
                              //       child: Label('Filing Level',
                              //           color: COLOR_WHITE),
                              //     ),
                              //   ),
                              // ),
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
                                      "${processList.where((element) => element.ID == _index.first).first.MACHINE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("Operator Name"))),
                                  DataCell(Label(
                                      "${processList.where((element) => element.ID == _index.first).first.OPERATOR_NAME}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("Operator Name1"))),
                                  DataCell(Label(
                                      "${processList.where((element) => element.ID == _index.first).first.OPERATOR_NAME1}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("Operator Name2"))),
                                  DataCell(Label(
                                      "${processList.where((element) => element.ID == _index.first).first.OPERATOR_NAME2}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("Operator Name3"))),
                                  DataCell(Label(
                                      "${processList.where((element) => element.ID == _index.first).first.OPERATOR_NAME3}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("Batch/Serial No."))),
                                  DataCell(Label(
                                      "${processList.where((element) => element.ID == _index.first).first.BATCH_NO}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(
                                      child: Label("Peak Current Withstands"))),
                                  DataCell(Label(
                                      "${processList.where((element) => element.ID == _index.first).first.PCW}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(
                                      child: Label("High-Voltage Test"))),
                                  DataCell(Label(
                                      "${processList.where((element) => element.ID == _index.first).first.HVT}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Start Date"))),
                                  DataCell(Label(
                                      "${processList.where((element) => element.ID == _index.first).first.STARTDATE}"))
                                ]),
                                //
                                // DataRow(cells: [
                                //   DataCell(
                                //       Center(child: Label("Zinc Thickness"))),
                                //   DataCell(Label(
                                //       "${processList.where((element) => element.ID == _index.first).first.ZINCK_THICKNESS}"))
                                // ]),
                                // DataRow(cells: [
                                //   DataCell(
                                //       Center(child: Label("Visual Control"))),
                                //   DataCell(Label(
                                //       "${processList.where((element) => element.ID == _index.first).first.VISUAL_CONTROL}"))
                                // ]),
                                // DataRow(cells: [
                                //   DataCell(Center(
                                //       child: Label("Clearing_VisualControl"))),
                                //   DataCell(Label(
                                //       "${processList.where((element) => element.ID == _index.first).first.VISUAL_CONTROL_CLEAR}"))
                                // ]),
                                // DataRow(cells: [
                                //   DataCell(Center(child: Label("Clearing"))),
                                //   DataCell(Label(
                                //       "${processList.where((element) => element.ID == _index.first).first.CLEARING_VOLTAGE}"))
                                // ]),
                                // DataRow(cells: [
                                //   DataCell(
                                //       Center(child: Label("Missing  Ratio"))),
                                //   DataCell(Label(
                                //       "${processList.where((element) => element.ID == _index.first).first.MISSING_RATIO}"))
                                // ]),
                                // DataRow(cells: [
                                //   DataCell(
                                //       Center(child: Label("Filing Level"))),
                                //   DataCell(Label(
                                //       "${processList.where((element) => element.ID == _index.first).first.FILING_LEVEL}"))
                                // ]),
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
                          _sendDataServer();
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

  void _sendDataServer() async {
    _index.forEach((element) async {
      var row = processList.where((value) => value.ID == element).first;
      var sql = await DatabaseHelper()
          .queryMasterlotProcess(row.MACHINE!.toUpperCase().toString());
      BlocProvider.of<LineElementBloc>(context).add(
        GetIPEProdSpecByBatchEvent(row.BATCH_NO!.trim().toString()),
      );
      await Future.delayed(Duration(milliseconds: 300));
      if (sql.isNotEmpty) {
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

        for (var itemMasterLot in sql) {
          BlocProvider.of<UpdateMaterialTraceBloc>(context).add(
              PostUpdateMaterialTraceEvent(
                  MaterialTraceUpdateModel(
                      DATE: row.STARTDATE,
                      IPE_NO: _ipeController.text,
                      MATERIAL: itemMasterLot['Material'].toString(),
                      LOT: itemMasterLot['Lot'].toString(),
                      PROCESS: itemMasterLot['PROCESS'].toString(),
                      I_PEAK: row.PCW == null
                          ? null
                          : int.tryParse(row.PCW.toString()),
                      HIGH_VOLT: row.HVT == null
                          ? null
                          : int.tryParse(row.HVT.toString()),
                      OPERATOR: row.OPERATOR_NAME,
                      BATCH_NO: row.BATCH_NO),
                  "Process"));
        }
      } else {
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
    });
  }

  void _AlertDialog() async {
    // EasyLoading.showError("Error[03]", duration: Duration(seconds: 5));//if password
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('AlertDialog Title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Label("Do you want Delete"),
            ),
          ],
        ),

        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await deletedInfo();
              await _refreshPage();
              await _getHold();
              EasyLoading.showSuccess("Delete Success");
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class ProcessStartDataSource extends DataGridSource {
  ProcessStartDataSource({List<ProcessModel>? process, String? test}) {
    if (process != null) {
      for (var _item in process) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<int>(columnName: 'ID', value: _item.ID),
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
              DataGridCell<String>(columnName: 'peak', value: _item.PCW),
              DataGridCell<String>(columnName: 'high', value: _item.HVT),
              DataGridCell<String>(
                  columnName: 'StartDate', value: _item.STARTDATE),
              // DataGridCell<String>(
              //     columnName: 'zinc', value: _item.ZINCK_THICKNESS.toString()),
              // DataGridCell<String>(
              //     columnName: 'visual', value: _item.VISUAL_CONTROL.toString()),
              // DataGridCell<String>(
              //     columnName: 'clearing_v',
              //     value: _item.VISUAL_CONTROL_CLEAR.toString()),
              // DataGridCell<String>(
              //     columnName: 'clearing',
              //     value: _item.CLEARING_VOLTAGE.toString()),
              // DataGridCell<String>(
              //     columnName: 'missing', value: _item.MISSING_RATIO.toString()),
              // DataGridCell<String>(
              //     columnName: 'filing', value: _item.FILING_LEVEL.toString()),
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
