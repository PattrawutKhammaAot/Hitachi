import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/models-Sqlite/treatmentModel.dart';
import 'package:hitachi/models/processCheck/processCheckModel.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../blocs/treatment/treatment_bloc.dart';
import '../../../../helper/colors/colors.dart';
import '../../../../helper/text/label.dart';
import '../../../../models/treatmentModel/treatmentOutputModel.dart';

class TreatmentFinishHoldScreen extends StatefulWidget {
  TreatmentFinishHoldScreen({super.key, this.onChange});
  ValueChanged<List<Map<String, dynamic>>>? onChange;

  @override
  State<TreatmentFinishHoldScreen> createState() =>
      _TreatmentFinishHoldScreenState();
}

class _TreatmentFinishHoldScreenState extends State<TreatmentFinishHoldScreen> {
  final TextEditingController _ipeController = TextEditingController();
  List<int> _index = [];

  TreatMentStartDataSource? tmsDatasource;
  DataGridRow? datagridRow;
  List<TreatmentModel>? tmSqliteModel;
  List<TreatmentModel> tmList = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<TreatmentModel> selectAll = [];

  Color _colorSend = COLOR_GREY;
  Color _colorDelete = COLOR_GREY;
  void initState() {
    _getTreatMentSheet().then((result) {
      setState(() {
        tmList = result;
        tmsDatasource = TreatMentStartDataSource(process: tmList);
      });
    });

    super.initState();
  }

  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('TREATMENT_SHEET');

    setState(() {
      widget.onChange
          ?.call(sql.where((element) => element['StartEnd'] == 'F').toList());
    });
  }

  Map<String, double> columnWidths = {
    'id': double.nan,
    'mac': double.nan,
    'operator': double.nan,
    'b1': double.nan,
    'b2': double.nan,
    'b3': double.nan,
    'b4': double.nan,
    'b5': double.nan,
    'b6': double.nan,
    'b7': double.nan,
    'findate': double.nan,
    'temp': double.nan,
    'treatmentTime': double.nan,
  };

  Future<List<TreatmentModel>> _getTreatMentSheet() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllRows('TREATMENT_SHEET');
      List<TreatmentModel> result = rows
          .where((element) => element['StartEnd'] == 'F')
          .map((row) => TreatmentModel.fromMap(row))
          .toList();
      print(rows);
      return result;
    } catch (e) {
      print(e);
      return [];
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TreatmentBloc, TreatmentState>(
          listener: (context, state) async {
            if (state is TreatmentFinishSendLoadingState) {
              EasyLoading.show();
            } else if (state is TreatmentFinishSendLoadedState) {
              EasyLoading.dismiss();
              if (state.item.RESULT == true) {
                await deletedInfo();
                await _getHold();
                await _refreshPage();
                EasyLoading.showSuccess("SendComplete");
              } else {
                _errorDialog(
                    isHideCancle: false,
                    text: Label("${state.item.MESSAGE ?? "Check Connection"}"),
                    onpressOk: () {
                      Navigator.pop(context);
                    });
              }
            } else if (state is TreatmentFinishSendErrorState) {
              EasyLoading.dismiss();
              _errorDialog(
                  isHideCancle: false,
                  text: Label("Check Connection"),
                  onpressOk: () {
                    Navigator.pop(context);
                  });
            }
          },
        ),
        BlocListener<LineElementBloc, LineElementState>(
            listener: (context, state) {
          if (state is ProcessCheckLoadingState) {
            // 1
          } else if (state is ProcessCheckLoadedState) {
            // if (state.item.RESULT == true) {
            //   _machineNoController.clear();
            //   _operatorNameController.clear();
            //   _batch1Controller.clear();
            //   _batch2Controller.clear();
            //   _batch3Controller.clear();
            //   _batch4Controller.clear();
            //   _batch5Controller.clear();
            //   _batch6Controller.clear();
            //   _batch7Controller.clear();
            //   f1.requestFocus();
            // } else {
            //   EasyLoading.showError(state.item.MESSAGE ?? "Exception");
            // }
          } else if (state is ProcessCheckErrorState) {
            // EasyLoading.dismiss();
            // _errorDialog(
            //     text: Label("CheckConnection\n Do you want to Save"),
            //     onpressOk: () async {
            //       await _saveDataToSqlite();
            //       await _getHold();
            //       _machineNoController.clear();
            //       _operatorNameController.clear();
            //       _batch1Controller.clear();
            //       _batch2Controller.clear();
            //       _batch3Controller.clear();
            //       _batch4Controller.clear();
            //       _batch5Controller.clear();
            //       _batch6Controller.clear();
            //       _batch7Controller.clear();
            //       f1.requestFocus();
            //       Navigator.pop(context);
            //     });
          }
          if (state is GetIPEProdSpecByBatchLoadedState) {
            if (state.item.IPE_NO != null) {
              _ipeController.text = state.item.IPE_NO!;
            }
            setState(() {});
          }
        })
      ],
      child: BgWhite(
          isHideAppBar: true,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                tmsDatasource != null
                    ? Expanded(
                        child: Container(
                          child: SfDataGrid(
                            showCheckboxColumn: true,
                            source: tmsDatasource!,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            gridLinesVisibility: GridLinesVisibility.both,
                            selectionMode: SelectionMode.multiple,
                            allowPullToRefresh: true,
                            allowColumnsResizing: true,
                            onColumnResizeUpdate:
                                (ColumnResizeUpdateDetails details) {
                              setState(() {
                                columnWidths[details.column.columnName] =
                                    details.width;
                                print(details.width);
                              });
                              return true;
                            },
                            columnResizeMode: ColumnResizeMode.onResizeEnd,
                            onSelectionChanged:
                                (selectRow, deselectedRows) async {
                              if (selectRow.isNotEmpty) {
                                if (selectRow.length ==
                                        tmsDatasource!.effectiveRows.length &&
                                    selectRow.length > 1) {
                                  setState(() {
                                    selectRow.forEach((row) {
                                      _index.add(int.tryParse(
                                          row.getCells()[0].value.toString())!);

                                      _colorSend = COLOR_BLUE_DARK;
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
                                    tmSqliteModel = datagridRow!
                                        .getCells()
                                        .map(
                                          (e) => TreatmentModel(),
                                        )
                                        .toList();
                                    print(_index);
                                    _colorSend = COLOR_BLUE_DARK;
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
                                });
                              }
                            },
                            columns: <GridColumn>[
                              GridColumn(
                                  visible: false,
                                  columnName: 'id',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label('ID', color: COLOR_WHITE),
                                    ),
                                  ),
                                  width: 100),
                              GridColumn(
                                width: columnWidths['mac']!,
                                columnName: 'mac',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('Machine No', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'operator',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('Operator', color: COLOR_WHITE),
                                  ),
                                ),
                                width: columnWidths['operator']!,
                              ),
                              GridColumn(
                                columnName: 'b1',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Batch1', color: COLOR_WHITE),
                                  ),
                                ),
                                width: columnWidths['b1']!,
                              ),
                              GridColumn(
                                width: columnWidths['b2']!,
                                columnName: 'b2',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Batch2', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['b3']!,
                                columnName: 'b3',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Batch3', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['b4']!,
                                columnName: 'b4',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Batch4', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['b5']!,
                                columnName: 'b5',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Batch5', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['b6']!,
                                columnName: 'b6',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Batch6', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['b7']!,
                                columnName: 'b7',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Batch7', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'temp',
                                width: columnWidths['temp']!,
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('Temp Curve', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['treatmentTime']!,
                                columnName: 'treatmentTime',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Treatment Time',
                                        color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'findate',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('FinishDate', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                const SizedBox(height: 20),
                _index.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: _index.length,
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
                                  DataCell(Center(child: Label("Machine No"))),
                                  DataCell(Label(
                                      "${tmList.where((element) => element.ID == _index.first).first.MACHINE_NO ?? ""}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("OperatorName"))),
                                  DataCell(Label(
                                      "${tmList.where((element) => element.ID == _index.first).first.OPERATOR_NAME}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Batch 1"))),
                                  DataCell(Label(
                                      "${tmList.where((element) => element.ID == _index.first).first.BATCH1}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Batch 2"))),
                                  DataCell(Label(
                                      "${tmList.where((element) => element.ID == _index.first).first.BATCH2}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Batch 3"))),
                                  DataCell(Label(
                                      "${tmList.where((element) => element.ID == _index.first).first.BATCH3}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Batch 4"))),
                                  DataCell(Label(
                                      "${tmList.where((element) => element.ID == _index.first).first.BATCH4}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Batch 5"))),
                                  DataCell(Label(
                                      "${tmList.where((element) => element.ID == _index.first).first.BATCH5}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Batch 6"))),
                                  DataCell(Label(
                                      "${tmList.where((element) => element.ID == _index.first).first.BATCH6}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Batch 7"))),
                                  DataCell(Label(
                                      "${tmList.where((element) => element.ID == _index.first).first.BATCH7}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Finish Date"))),
                                  DataCell(Label(
                                      "${tmList.where((element) => element.ID == _index.first).first.FINDATE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Temp Curve"))),
                                  DataCell(Label(
                                      "${tmList.where((element) => element.ID == _index.first).first.TEMP_CURVE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("Treatment Time"))),
                                  DataCell(Label(
                                      "${tmList.where((element) => element.ID == _index.first).first.TREATMENT_TIME}"))
                                ])
                              ],
                            );
                          }),
                        ),
                      )
                    : Container(),
                const SizedBox(height: 20),
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
          )),
    );
  }

  _sendDataServer() {
    _index.forEach((element) async {
      var row = tmList.where((value) => value.ID == element).first;
      BlocProvider.of<TreatmentBloc>(context).add(
        TreatmentFinishSendEvent(TreatMentOutputModel(
          MACHINE_NO: row.MACHINE_NO,
          OPERATOR_NAME: int.tryParse(row.OPERATOR_NAME.toString()),
          BATCH_NO_1: row.BATCH1,
          BATCH_NO_2: row.BATCH2,
          BATCH_NO_3: row.BATCH3,
          BATCH_NO_4: row.BATCH4,
          BATCH_NO_5: row.BATCH5,
          BATCH_NO_6: row.BATCH6,
          BATCH_NO_7: row.BATCH7,
          FINISH_DATE: row.FINDATE,
        )),
      );
      if (row.MACHINE_NO?.substring(0, 2).toUpperCase() == "TM") {
        if (row.BATCH1 != null && row.BATCH1 != '') {
          BlocProvider.of<LineElementBloc>(context).add(
            GetIPEProdSpecByBatchEvent(row.BATCH1!.trim().toString()),
          );
          await Future.delayed(Duration(milliseconds: 300));
          BlocProvider.of<LineElementBloc>(context).add(
            ProcessCheckEvent(ProcessCheckModel(
              BATCH_NO: row.BATCH1,
              IPE_NO: int.tryParse(_ipeController.text),
              // MC_NO: row.MACHINE_NO,
              TM_Curve: row.TEMP_CURVE,
              TM_Time: row.TREATMENT_TIME,
            )),
          );
        }
        if (row.BATCH2 != null && row.BATCH2 != '') {
          BlocProvider.of<LineElementBloc>(context).add(
            GetIPEProdSpecByBatchEvent(row.BATCH2!.trim().toString()),
          );
          await Future.delayed(Duration(milliseconds: 300));
          BlocProvider.of<LineElementBloc>(context).add(
            ProcessCheckEvent(ProcessCheckModel(
              BATCH_NO: row.BATCH2,
              IPE_NO: int.tryParse(_ipeController.text),
              // MC_NO: row.MACHINE_NO,
              TM_Curve: row.TEMP_CURVE,
              TM_Time: row.TREATMENT_TIME,
            )),
          );
        }
        if (row.BATCH3 != null && row.BATCH3 != '') {
          BlocProvider.of<LineElementBloc>(context).add(
            GetIPEProdSpecByBatchEvent(row.BATCH3!.trim().toString()),
          );
          await Future.delayed(Duration(milliseconds: 300));
          BlocProvider.of<LineElementBloc>(context).add(
            ProcessCheckEvent(ProcessCheckModel(
              BATCH_NO: row.BATCH3,
              IPE_NO: int.tryParse(_ipeController.text),
              // MC_NO: row.MACHINE_NO,
              TM_Curve: row.TEMP_CURVE,
              TM_Time: row.TREATMENT_TIME,
            )),
          );
        }
        if (row.BATCH4 != null && row.BATCH4 != '') {
          BlocProvider.of<LineElementBloc>(context).add(
            GetIPEProdSpecByBatchEvent(row.BATCH4!.trim().toString()),
          );
          await Future.delayed(Duration(milliseconds: 300));
          BlocProvider.of<LineElementBloc>(context).add(
            ProcessCheckEvent(ProcessCheckModel(
              BATCH_NO: row.BATCH4,
              IPE_NO: int.tryParse(_ipeController.text),
              // MC_NO: row.MACHINE_NO,
              TM_Curve: row.TEMP_CURVE,
              TM_Time: row.TREATMENT_TIME,
            )),
          );
        }
        if (row.BATCH5 != null && row.BATCH5 != '') {
          BlocProvider.of<LineElementBloc>(context).add(
            GetIPEProdSpecByBatchEvent(row.BATCH5!.trim().toString()),
          );
          await Future.delayed(Duration(milliseconds: 300));
          BlocProvider.of<LineElementBloc>(context).add(
            ProcessCheckEvent(ProcessCheckModel(
              BATCH_NO: row.BATCH5,
              IPE_NO: int.tryParse(_ipeController.text),
              // MC_NO: row.MACHINE_NO,
              TM_Curve: row.TEMP_CURVE,
              TM_Time: row.TREATMENT_TIME,
            )),
          );
        }
        if (row.BATCH6 != null && row.BATCH6 != '') {
          BlocProvider.of<LineElementBloc>(context).add(
            GetIPEProdSpecByBatchEvent(row.BATCH6!.trim().toString()),
          );
          await Future.delayed(Duration(milliseconds: 300));
          BlocProvider.of<LineElementBloc>(context).add(
            ProcessCheckEvent(ProcessCheckModel(
              BATCH_NO: row.BATCH6,
              IPE_NO: int.tryParse(_ipeController.text),
              // MC_NO: row.MACHINE_NO,
              TM_Curve: row.TEMP_CURVE,
              TM_Time: row.TREATMENT_TIME,
            )),
          );
        }
        if (row.BATCH7 != null && row.BATCH7 != '') {
          BlocProvider.of<LineElementBloc>(context).add(
            GetIPEProdSpecByBatchEvent(row.BATCH7!.trim().toString()),
          );
          await Future.delayed(Duration(milliseconds: 300));
          BlocProvider.of<LineElementBloc>(context).add(
            ProcessCheckEvent(ProcessCheckModel(
              BATCH_NO: row.BATCH7,
              IPE_NO: int.tryParse(_ipeController.text),
              // MC_NO: row.MACHINE_NO,
              TM_Curve: row.TEMP_CURVE,
              TM_Time: row.TREATMENT_TIME,
            )),
          );
        }
      }
    });
  }

  void _AlertDialog() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
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
              await _getHold();
              await _refreshPage();

              EasyLoading.showSuccess("Delete Success");
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future _refreshPage() async {
    await Future.delayed(Duration(seconds: 1), () {
      _getTreatMentSheet().then((result) {
        setState(() {
          tmList = result;
          tmsDatasource = TreatMentStartDataSource(process: tmList);
        });
      });
    });
  }

  Future deletedInfo() async {
    setState(() {
      _index.forEach((element) async {
        await databaseHelper.deletedRowSqlite(
            tableName: 'TREATMENT_SHEET',
            columnName: 'ID',
            columnValue: element);
        _index.clear();
      });
    });
  }
}

class TreatMentStartDataSource extends DataGridSource {
  TreatMentStartDataSource({List<TreatmentModel>? process}) {
    if (process != null) {
      for (var _item in process) {
        print(_item.TREATMENT_TIME);
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<int>(columnName: 'id', value: _item.ID),
              DataGridCell<String>(columnName: 'mac', value: _item.MACHINE_NO),
              DataGridCell<String>(
                  columnName: 'operator', value: _item.OPERATOR_NAME),
              DataGridCell<String>(columnName: 'b1', value: _item.BATCH1),
              DataGridCell<String>(columnName: 'b2', value: _item.BATCH2),
              DataGridCell<String>(columnName: 'b3', value: _item.BATCH3),
              DataGridCell<String>(columnName: 'b4', value: _item.BATCH4),
              DataGridCell<String>(columnName: 'b5', value: _item.BATCH5),
              DataGridCell<String>(columnName: 'b6', value: _item.BATCH6),
              DataGridCell<String>(columnName: 'b7', value: _item.BATCH7),
              DataGridCell<String>(columnName: 'temp', value: _item.TEMP_CURVE),
              DataGridCell<String>(
                  columnName: 'treatmentTime', value: _item.TREATMENT_TIME),
              DataGridCell<String>(columnName: 'findate', value: _item.FINDATE),
            ],
          ),
        );
      }
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
