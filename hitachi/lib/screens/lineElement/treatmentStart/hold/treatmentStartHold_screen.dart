import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/treatment/treatment_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/treatmentModel.dart';
import 'package:hitachi/models/treatmentStartModel/treatmentStartOutputModel.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TreatmentStartHoldScreen extends StatefulWidget {
  const TreatmentStartHoldScreen({super.key});

  @override
  State<TreatmentStartHoldScreen> createState() =>
      _TreatmentStartHoldScreenState();
}

class _TreatmentStartHoldScreenState extends State<TreatmentStartHoldScreen> {
  final TextEditingController _passwordController = TextEditingController();
  int? selectedRowIndex;
  TreatMentStartDataSource? tmsDatasource;
  DataGridRow? datagridRow;
  List<TreatmentModel>? tmSqliteModel;
  List<TreatmentModel>? tmList;
  DatabaseHelper databaseHelper = DatabaseHelper();

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

  Future<List<TreatmentModel>> _getTreatMentSheet() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllRows('TREATMENT_SHEET');
      List<TreatmentModel> result =
          rows.map((row) => TreatmentModel.fromMap(row)).toList();
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
        BlocListener<TreatmentBloc, TreatmentState>(
          listener: (context, state) {
            if (state is TreatmentStartSendLoadingState) {
              EasyLoading.show();
            } else if (state is TreatmentStartSendLoadedState) {
              if (state.item.RESULT == true) {
                EasyLoading.showSuccess("SendComplete");
                deletedInfo();
              }
            } else {
              EasyLoading.dismiss();

              EasyLoading.showError("Please Check Connection Internet");
            }
          },
        )
      ],
      child: BgWhite(
          isHideAppBar: true,
          textTitle: "Material Input",
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
                            selectionMode: SelectionMode.single,
                            onCellTap: (details) async {
                              if (details.rowColumnIndex.rowIndex != 0) {
                                setState(() {
                                  selectedRowIndex =
                                      details.rowColumnIndex.rowIndex - 1;
                                  datagridRow = tmsDatasource!.effectiveRows
                                      .elementAt(selectedRowIndex!);
                                  tmSqliteModel = datagridRow!
                                      .getCells()
                                      .map(
                                        (e) => TreatmentModel(),
                                      )
                                      .toList();
                                  _colorDelete = COLOR_RED;
                                  _colorSend = COLOR_SUCESS;
                                });
                              }
                            },
                            columns: <GridColumn>[
                              GridColumn(
                                  columnName: 'mac',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label('Machine No',
                                          color: COLOR_WHITE),
                                    ),
                                  ),
                                  width: 100),
                              GridColumn(
                                  columnName: 'operator',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child:
                                          Label('Operator', color: COLOR_WHITE),
                                    ),
                                  ),
                                  width: 100),
                              GridColumn(
                                  columnName: 'b1',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child:
                                          Label('Batch1', color: COLOR_WHITE),
                                    ),
                                  ),
                                  width: 100),
                              GridColumn(
                                columnName: 'b2',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Batch2', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'b3',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Batch3', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'b4',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Batch4', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'b5',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Batch5', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'b6',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Batch6', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'b7',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Batch7', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'std',
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
                tmSqliteModel != null
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
                                        Center(child: Label("Machine No"))),
                                    DataCell(Label(
                                        "${tmList![selectedRowIndex!].MACHINE_NO}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Center(child: Label("OperatorName"))),
                                    DataCell(Label(
                                        "${tmList![selectedRowIndex!].OPERATOR_NAME}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Center(child: Label("Batch 1"))),
                                    DataCell(Label(
                                        "${tmList![selectedRowIndex!].BATCH1}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Center(child: Label("Batch 2"))),
                                    DataCell(Label(
                                        "${tmList![selectedRowIndex!].BATCH2}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Center(child: Label("Batch 3"))),
                                    DataCell(Label(
                                        "${tmList![selectedRowIndex!].BATCH3}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Center(child: Label("Batch 4"))),
                                    DataCell(Label(
                                        "${tmList![selectedRowIndex!].BATCH4}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Center(child: Label("Batch 5"))),
                                    DataCell(Label(
                                        "${tmList![selectedRowIndex!].BATCH5}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Center(child: Label("Batch 6"))),
                                    DataCell(Label(
                                        "${tmList![selectedRowIndex!].BATCH6}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Center(child: Label("Batch 7"))),
                                    DataCell(Label(
                                        "${tmList![selectedRowIndex!].BATCH7}"))
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Center(child: Label("Start Date"))),
                                    DataCell(Label(
                                        "${tmList![selectedRowIndex!].STARTDATE}"))
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
                        if (tmSqliteModel != null) {
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
                        if (tmSqliteModel != null) {
                          BlocProvider.of<TreatmentBloc>(context).add(
                            TreatmentStartSendEvent(TreatMentStartOutputModel(
                              MACHINE_NO: tmList![selectedRowIndex!].MACHINE_NO,
                              OPERATOR_NAME: int.tryParse(
                                  tmList![selectedRowIndex!]
                                      .OPERATOR_NAME
                                      .toString()),
                              BATCH_NO_1: tmList![selectedRowIndex!].BATCH1,
                              BATCH_NO_2: tmList![selectedRowIndex!].BATCH2,
                              BATCH_NO_3: tmList![selectedRowIndex!].BATCH3,
                              BATCH_NO_4: tmList![selectedRowIndex!].BATCH4,
                              BATCH_NO_5: tmList![selectedRowIndex!].BATCH5,
                              BATCH_NO_6: tmList![selectedRowIndex!].BATCH6,
                              BATCH_NO_7: tmList![selectedRowIndex!].BATCH7,
                              START_DATE: tmList![selectedRowIndex!].STARTDATE,
                            )),
                          );
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

  void deletedInfo() async {
    await databaseHelper.deletedRowSqlite(
        tableName: 'TREATMENT_SHEET',
        columnName: 'ID',
        columnValue: tmList![selectedRowIndex!].ID);
  }
}

class TreatMentStartDataSource extends DataGridSource {
  TreatMentStartDataSource({List<TreatmentModel>? process}) {
    if (process != null) {
      for (var _item in process) {
       if(_item.CHECK_COMPLETE == 'S'){
         _employees.add(
           DataGridRow(
             cells: [
               DataGridCell<String>(columnName: 'mac', value: _item.MACHINE_NO),
               DataGridCell<String>(
                   columnName: 'operator', value: _item.OPERATOR_NAME),
               DataGridCell<String>(columnName: 'b1', value: _item.BATCH1),
               DataGridCell<String>(
                   columnName: 'b2',
                   value: _item.BATCH2 == null ? '' : _item.BATCH2),
               DataGridCell<String>(
                   columnName: 'b3',
                   value: _item.BATCH3 == null ? '' : _item.BATCH3),
               DataGridCell<String>(
                   columnName: 'b4',
                   value: _item.BATCH4 == null ? '' : _item.BATCH4),
               DataGridCell<String>(
                   columnName: 'b5',
                   value: _item.BATCH5 == null ? '' : _item.BATCH5),
               DataGridCell<String>(
                   columnName: 'b6',
                   value: _item.BATCH6 == null ? '' : _item.BATCH6),
               DataGridCell<String>(
                   columnName: 'b7',
                   value: _item.BATCH7 == null ? '' : _item.BATCH7),
               DataGridCell<String>(columnName: 'std', value: _item.STARTDATE),
             ],
           ),
         );
       }
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
