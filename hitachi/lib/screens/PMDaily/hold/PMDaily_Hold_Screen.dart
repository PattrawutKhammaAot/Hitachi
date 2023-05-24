import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:hitachi/blocs/pmDaily/pm_daily_bloc.dart';
import 'package:hitachi/blocs/pmDaily/pm_daily_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/dataSheetModel.dart';
import 'package:hitachi/models-Sqlite/pmdailyModel.dart';
import 'package:hitachi/models/filmReceiveModel/filmreceiveOutputModel.dart';
import 'package:hitachi/models/pmdailyModel/PMDailyOutputModel.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../services/databaseHelper.dart';

class PMdailyHold_Screen extends StatefulWidget {
  const PMdailyHold_Screen({super.key});

  @override
  State<PMdailyHold_Screen> createState() => _PMdailyHold_ScreenState();
}

class _PMdailyHold_ScreenState extends State<PMdailyHold_Screen> {
  final TextEditingController password = TextEditingController();
  PMDailyDataSource? PMDataSource;
  List<PMDailyModel>? PMSqliteModel;
  List<PMDailyModel> PMList = [];
  int? selectedRowIndex;
  DataGridRow? datagridRow;
  bool isClick = false;
  Color _colorSend = COLOR_GREY;
  Color _colorDelete = COLOR_GREY;
  bool isHidewidget = false;

  int? index;
  int? allRowIndex;
  List<PMDailyModel> selectAll = [];

  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  void initState() {
    super.initState();

    _getPMDaily().then((result) {
      setState(() {
        PMList = result;
        PMDataSource = PMDailyDataSource(process: PMList);
        print(PMList);
      });
    });
  }

  Future<List<PMDailyModel>> _getPMDaily() async {
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
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PmDailyBloc, PmDailyState>(
          listener: (context, state) {
            if (state is PMDailyLoadingState) {
              EasyLoading.show();
            }
            if (state is PMDailyLoadedState) {
              if (state.item.RESULT == true) {
                deletedInfo();
                Navigator.pop(context);
                EasyLoading.showSuccess("Send complete",
                    duration: Duration(seconds: 3));
              } else {
                EasyLoading.showError("Please Check Data");
              }
            }
            if (state is PMDailyErrorState) {
              EasyLoading.showError("Can not send");
            }
          },
        )
      ],
      child: BgWhite(
        isHideAppBar: true,
        textTitle: "Winding job Start(Hold)",
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              PMDataSource != null
                  ? Expanded(
                      child: Container(
                        child: SfDataGrid(
                          source: PMDataSource!,
                          // columnWidthMode: ColumnWidthMode.fill,
                          showCheckboxColumn: true,
                          selectionMode: SelectionMode.multiple,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          gridLinesVisibility: GridLinesVisibility.both,
                          allowPullToRefresh: true,
                          onSelectionChanged:
                              (selectRow, deselectedRows) async {
                            if (selectRow.isNotEmpty) {
                              if (selectRow.length ==
                                  PMDataSource!.effectiveRows.length) {
                                print("all");
                                setState(() {
                                  selectRow.forEach((row) {
                                    allRowIndex = PMDataSource!.effectiveRows
                                        .indexOf(row);

                                    _colorSend = COLOR_SUCESS;
                                    _colorDelete = COLOR_RED;
                                  });
                                });
                              } else if (selectRow.length !=
                                  PMDataSource!.effectiveRows.length) {
                                setState(() {
                                  index = selectRow.isNotEmpty
                                      ? PMDataSource!.effectiveRows
                                          .indexOf(selectRow.first)
                                      : null;
                                  datagridRow = PMDataSource!.effectiveRows
                                      .elementAt(index!);
                                  PMSqliteModel = datagridRow!
                                      .getCells()
                                      .map(
                                        (e) => PMDailyModel(
                                          OPERATOR_NAME: e.value.toString(),
                                        ),
                                      )
                                      .toList();
                                  // selectAll.add(wdsList[index!]);
                                  if (!selectAll.contains(PMList[index!])) {
                                    selectAll.add(PMList[index!]);
                                    print(selectAll.length);
                                  }
                                  _colorSend = COLOR_SUCESS;
                                  _colorDelete = COLOR_RED;
                                });
                              }
                            } else {
                              setState(() {
                                if (selectAll.contains(PMList[index!])) {
                                  selectAll.remove(PMList[index!]);
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
                          // onCellTap: (details) async {
                          //   if (details.rowColumnIndex.rowIndex != 0) {
                          //     setState(() {
                          //       selectedRowIndex =
                          //           details.rowColumnIndex.rowIndex - 1;
                          //       datagridRow = PMDataSource!.effectiveRows
                          //           .elementAt(selectedRowIndex!);
                          //       PMSqliteModel = datagridRow!
                          //           .getCells()
                          //           .map(
                          //             (e) => PMDailyModel(ID: e.value),
                          //           )
                          //           .toList();
                          //       _colorSend = COLOR_SUCESS;
                          //       _colorDelete = COLOR_RED;
                          //     });
                          //   }
                          // },
                          columns: <GridColumn>[
                            GridColumn(
                                columnName: 'Operatorname',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Operator Name.',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                  // color: COLOR_BLUE_DARK,
                                )),
                            GridColumn(
                              columnName: 'CHECKPOINT',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                    child: Label(
                                  'Checkpoint',
                                  textAlign: TextAlign.center,
                                  fontSize: 14,
                                  color: COLOR_WHITE,
                                )),
                              ),
                            ),
                            GridColumn(
                                columnName: 'STATUS',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Status',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                ),
                                width: 100),
                            GridColumn(
                                columnName: 'STARTDATE',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Start Date',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                ),
                                width: 100),
                          ],
                        ),
                      ),
                    )
                  : CircularProgressIndicator(),
              PMSqliteModel != null && PMList != null
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
                                  DataCell(
                                      Center(child: Label("Operator Name."))),
                                  DataCell(
                                      Label("${PMList[index!].OPERATOR_NAME}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Checkpoint"))),
                                  DataCell(
                                      Label("${PMList[index!].CHECKPOINT}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Status"))),
                                  DataCell(Label("${PMList[index!].STATUS}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Start Date"))),
                                  DataCell(Label("${PMList[index!].DATEPM}"))
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
                      if (PMList != null) {
                        _AlertDialog();
                      } else {
                        _selectData();
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
                      if (PMList != null) {
                        _sendDataServer();
                      } else {
                        EasyLoading.showInfo("Please Select Data");
                      }
                    },
                  )),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _checkValueController() async {
    if (password.text.isNotEmpty) {
      Navigator.pop(context);
      Navigator.pop(context);
      EasyLoading.showSuccess("Delete Success");
    }
  }

  // void deletedInfo() async {
  //   await databaseHelper.deletedRowSqlite(
  //       tableName: 'PM_SHEET',
  //       columnName: 'ID',
  //       columnValue: PMList[selectedRowIndex!].ID);
  // }

  void deletedInfo() async {
    if (index != null) {
      for (var row in selectAll) {
        await databaseHelper.deletedRowSqlite(
            tableName: 'PM_SHEET', columnName: 'ID', columnValue: row.ID);
      }
    } else if (allRowIndex != null) {
      for (var row in PMList) {
        await databaseHelper.deletedRowSqlite(
          tableName: 'PM_SHEET',
          columnName: 'ID',
          columnValue: row.ID,
        );
      }
    } else {}
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
          controller: password,
        ),

        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _checkValueController(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // void _sendDataServer() async {
  //   BlocProvider.of<PmDailyBloc>(context).add(
  //     PMDailySendEvent(
  //       PMDailyOutputModel(
  //         OPERATORNAME:
  //             int.tryParse(PMList![selectedRowIndex!].OPERATOR_NAME.toString()),
  //         CHECKPOINT: PMList![selectedRowIndex!].CHECKPOINT,
  //         STATUS: PMList![selectedRowIndex!].STATUS,
  //         STARTDATE: PMList![selectedRowIndex!].STARTDATE,
  //       ),
  //     ),
  //   );
  // }

  void _sendDataServer() async {
    if (index != null) {
      for (var row in selectAll) {
        BlocProvider.of<PmDailyBloc>(context).add(
          PMDailySendEvent(
            PMDailyOutputModel(
              OPERATORNAME: int.tryParse(row.OPERATOR_NAME.toString()),
              CHECKPOINT: row.CHECKPOINT,
              STATUS: row.STATUS,
              STARTDATE: row.DATEPM,
            ),
          ),
        );
      }
    } else if (allRowIndex != null) {
      for (var row in PMList) {
        BlocProvider.of<PmDailyBloc>(context).add(
          PMDailySendEvent(
            PMDailyOutputModel(
              OPERATORNAME: int.tryParse(row.OPERATOR_NAME.toString()),
              CHECKPOINT: row.CHECKPOINT,
              STATUS: row.STATUS,
              STARTDATE: row.DATEPM,
            ),
          ),
        );
      }
    }
  }
  // void _sendDataServer() async {
  //   if (index != null) {
  //     for (var row in selectAll) {
  //       BlocProvider.of<PmDailyBloc>(context).add(
  //         PMDailySendEvent(
  //           PMDailyOutputModel(
  //               OPERATORNAME: int.tryParse(row.OPERATOR_NAME.toString()),
  //               CHECKPOINT: row.CHECKPOINT,
  //               STATUS: row.STATUS,
  //               STARTDATE: row.STARTDATE,
  //
  //         ),
  //       );
  //     }
  //   } else if (allRowIndex != null) {
  //     for (var row in PMList) {
  //       BlocProvider.of<PmDailyBloc>(context).add(
  //         PMDailySendEvent(
  //           PMDailyOutputModel(
  //             OPERATORNAME: int.tryParse(row.OPERATOR_NAME.toString()),
  //             CHECKPOINT: row.CHECKPOINT,
  //             STATUS: row.STATUS,
  //             STARTDATE: row.STARTDATE,
  //         ),
  //       );
  //     }
  //   }
  // }

  void _selectData() {
    EasyLoading.showInfo("Please Select Data", duration: Duration(seconds: 2));
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
                  columnName: 'StartDate', value: _item.DATEPM.toString()),
            ],
          ),
        );
      }
    } else {
      EasyLoading.showError("Can not Call API");
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
