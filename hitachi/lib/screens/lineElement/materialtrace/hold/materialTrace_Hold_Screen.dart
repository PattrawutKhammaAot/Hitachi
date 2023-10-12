import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/bloc/update_material_trace_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/materialTraces/materialTraceUpdateModel.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MaterialTraceHoldScreen extends StatefulWidget {
  const MaterialTraceHoldScreen({super.key, this.onChange});
  final ValueChanged<List<Map<String, dynamic>>>? onChange;

  @override
  State<MaterialTraceHoldScreen> createState() =>
      _MaterialTraceHoldScreenState();
}

class _MaterialTraceHoldScreenState extends State<MaterialTraceHoldScreen> {
  List<int> _index = [];

  TreatMentStartDataSource? tmsDatasource;
  DataGridRow? datagridRow;
  List<MaterialTraceUpdateModel>? tmSqliteModel;
  List<MaterialTraceUpdateModel> tmList = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<MaterialTraceUpdateModel> selectAll = [];

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
        await databaseHelper.queryAllRows('MATUPDATE');

    setState(() {
      widget.onChange?.call(sql);
    });
  }

  Map<String, double> columnWidths = {
    'id': double.nan,
    'mat': double.nan,
    'op': double.nan,
    'bn': double.nan,
    'pro': double.nan,
    'lot': double.nan,
    'date': double.nan,
  };

  Future<List<MaterialTraceUpdateModel>> _getTreatMentSheet() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllRows('MATUPDATE');
      List<MaterialTraceUpdateModel> result =
          rows.map((row) => MaterialTraceUpdateModel.fromMap(row)).toList();
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
        BlocListener<UpdateMaterialTraceBloc, UpdateMaterialTraceState>(
            listener: (context, state) async {
          if (state is UpdateMaterialTraceLoadingState) {
            EasyLoading.show(status: "Loading ...");
          } else if (state is UpdateMaterialTraceLoadedState) {
            if (state.item.MESSAGE == "Success") {
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
            EasyLoading.dismiss();
          } else if (state is UpdateMaterialTraceErrorState) {
            EasyLoading.dismiss();
            _errorDialog(
                isHideCancle: false,
                text: Label("Check Connection"),
                onpressOk: () {
                  Navigator.pop(context);
                });
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
                                          (e) => MaterialTraceUpdateModel(),
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
                                width: columnWidths['mat']!,
                                columnName: 'mat',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('Material', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['op']!,
                                columnName: 'op',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('Operator', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'bn',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child:
                                        Label('Batch No', color: COLOR_WHITE),
                                  ),
                                ),
                                width: columnWidths['bn']!,
                              ),
                              GridColumn(
                                width: columnWidths['pro']!,
                                columnName: 'pro',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Process', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['lot']!,
                                columnName: 'lot',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Lot No', color: COLOR_WHITE),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: columnWidths['date']!,
                                columnName: 'date',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('Date', color: COLOR_WHITE),
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
                                  DataCell(Center(child: Label("Material"))),
                                  DataCell(Label(
                                      "${tmList.where((element) => element.ID == _index.first).first.MATERIAL ?? ""}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("OperatorName"))),
                                  DataCell(Label(
                                      "${tmList.where((element) => element.ID == _index.first).first.OPERATOR}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Batch No"))),
                                  DataCell(Label(
                                      "${tmList.where((element) => element.ID == _index.first).first.BATCH_NO}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Process"))),
                                  DataCell(Label(
                                      "${tmList.where((element) => element.ID == _index.first).first.PROCESS}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("LOT NO"))),
                                  DataCell(Label(
                                      "${tmList.where((element) => element.ID == _index.first).first.LOT}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("DATE"))),
                                  DataCell(Label(
                                    "${tmList.where((element) => element.ID == _index.first).first.DATE}",
                                    fontSize: 14,
                                  ))
                                ]),
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
      BlocProvider.of<UpdateMaterialTraceBloc>(context).add(
          PostUpdateMaterialTraceEvent(MaterialTraceUpdateModel(
              DATE: row.DATE,
              MATERIAL: row.MATERIAL,
              LOT: row.LOT,
              PROCESS: row.PROCESS,
              OPERATOR: row.OPERATOR,
              BATCH_NO: row.BATCH_NO)));
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
            tableName: 'MATUPDATE', columnName: 'ID', columnValue: element);
        _index.clear();
      });
    });
  }
}

class TreatMentStartDataSource extends DataGridSource {
  TreatMentStartDataSource({List<MaterialTraceUpdateModel>? process}) {
    if (process != null) {
      for (var _item in process) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<int>(columnName: 'id', value: _item.ID),
              DataGridCell<String>(columnName: 'mat', value: _item.MATERIAL),
              DataGridCell<String>(columnName: 'op', value: _item.OPERATOR),
              DataGridCell<String>(columnName: 'bn', value: _item.BATCH_NO),
              DataGridCell<String>(columnName: 'pro', value: _item.PROCESS),
              DataGridCell<String>(columnName: 'lot', value: _item.LOT),
              DataGridCell<String>(columnName: 'date', value: _item.DATE),
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
