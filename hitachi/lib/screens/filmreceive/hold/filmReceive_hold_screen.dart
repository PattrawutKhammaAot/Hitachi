import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/filmReceive/film_receive_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/dataSheetModel.dart';
import 'package:hitachi/models/filmReceiveModel/filmreceiveOutputModel.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../services/databaseHelper.dart';

class FilmReceiveHoldScreen extends StatefulWidget {
  const FilmReceiveHoldScreen({super.key});

  @override
  State<FilmReceiveHoldScreen> createState() => _FilmReceiveHoldScreenState();
}

class _FilmReceiveHoldScreenState extends State<FilmReceiveHoldScreen> {
  final TextEditingController password = TextEditingController();
  FilmReceiveDataSource? filmDataSource;
  List<DataSheetTableModel>? dstSqliteModel;
  List<DataSheetTableModel> dstList = [];
  int? selectedRowIndex;
  DataGridRow? datagridRow;
  bool isClick = false;
  Color _colorSend = COLOR_GREY;
  Color _colorDelete = COLOR_GREY;
  bool isHidewidget = false;

  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  void initState() {
    super.initState();

    _getFilmReceive().then((result) {
      setState(() {
        dstList = result;
        filmDataSource = FilmReceiveDataSource(process: dstList);
        print(dstList);
      });
    });
  }

  Future<List<DataSheetTableModel>> _getFilmReceive() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllRows('DATA_SHEET');
      List<DataSheetTableModel> result = rows
          .map((row) => DataSheetTableModel.fromMap(
              row.map((key, value) => MapEntry(key, value.toString()))))
          .toList();

      return result;
    } catch (e, s) {
      print(e);
      print(s);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FilmReceiveBloc, FilmReceiveState>(
          listener: (context, state) {
            if (state is FilmReceiveLoadingState) {
              EasyLoading.show();
            }
            if (state is FilmReceiveLoadedState) {
              if (state.item.RESULT == true) {
                deletedInfo();
                Navigator.pop(context);
                EasyLoading.showSuccess("Send complete",
                    duration: Duration(seconds: 3));
              } else {
                EasyLoading.showError("Please Check Data");
              }
            }
            if (state is FilmReceiveErrorState) {
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
              filmDataSource != null
                  ? Expanded(
                      child: Container(
                        child: SfDataGrid(
                          source: filmDataSource!,
                          // columnWidthMode: ColumnWidthMode.fill,
                          showCheckboxColumn: true,
                          selectionMode: SelectionMode.single,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          gridLinesVisibility: GridLinesVisibility.both,
                          onCellTap: (details) async {
                            if (details.rowColumnIndex.rowIndex != 0) {
                              setState(() {
                                selectedRowIndex =
                                    details.rowColumnIndex.rowIndex - 1;
                                datagridRow = filmDataSource!.effectiveRows
                                    .elementAt(selectedRowIndex!);
                                dstSqliteModel = datagridRow!
                                    .getCells()
                                    .map(
                                      (e) => DataSheetTableModel(
                                          PO_NO: e.value.toString()),
                                    )
                                    .toList();
                                _colorSend = COLOR_SUCESS;
                                _colorDelete = COLOR_RED;
                              });
                            }
                          },
                          columns: <GridColumn>[
                            GridColumn(
                                columnName: 'pono',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'PO No.',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                  // color: COLOR_BLUE_DARK,
                                )),
                            GridColumn(
                              columnName: 'ivno',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                    child: Label(
                                  'Invoice No.',
                                  textAlign: TextAlign.center,
                                  fontSize: 14,
                                  color: COLOR_WHITE,
                                )),
                              ),
                            ),
                            GridColumn(
                                columnName: 'fi',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Freight',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                ),
                                width: 100),
                            GridColumn(
                                columnName: 'ic',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Incoing',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                ),
                                width: 100),
                            GridColumn(
                                columnName: 'sb',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'StoreBy',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'packno',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'PackNo.',
                                    textAlign: TextAlign.center,
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'sd',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Store Date',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'status',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Status',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'w1',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'w1',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'w2',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'w2',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'Weight',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Weight',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'md',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Mfg.Date',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'tn',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Thickness',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'wg',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Wrap Grade',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'rn',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Roll No.',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                          ],
                        ),
                      ),
                    )
                  : CircularProgressIndicator(),
              dstSqliteModel != null && dstList != null
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
                                  DataCell(Center(child: Label("PO no."))),
                                  DataCell(Label(
                                      "${dstList[selectedRowIndex!].PO_NO}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Invoice No."))),
                                  DataCell(Label(
                                      "${dstList[selectedRowIndex!].IN_VOICE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("Incoming Date"))),
                                  DataCell(Label(
                                      "${dstList[selectedRowIndex!].INCOMING_DATE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Store By"))),
                                  DataCell(Label(
                                      "${dstList[selectedRowIndex!].STORE_BY}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Pack No"))),
                                  DataCell(Label(
                                      "${dstList[selectedRowIndex!].PACK_NO}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Store Date"))),
                                  DataCell(Label(
                                      "${dstList[selectedRowIndex!].STORE_DATE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Status"))),
                                  DataCell(Label(
                                      "${dstList[selectedRowIndex!].STATUS}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Weight1"))),
                                  DataCell(
                                      Label("${dstList[selectedRowIndex!].W1}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Weight2"))),
                                  DataCell(
                                      Label("${dstList[selectedRowIndex!].W2}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Weight"))),
                                  DataCell(Label(
                                      "${dstList[selectedRowIndex!].WEIGHT}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Mfg.date"))),
                                  DataCell(Label(
                                      "${dstList[selectedRowIndex!].MFG_DATE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Thickness"))),
                                  DataCell(Label(
                                      "${dstList[selectedRowIndex!].THICKNESS}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Wrap Grade"))),
                                  DataCell(Label(
                                      "${dstList[selectedRowIndex!].WRAP_GRADE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Roll No."))),
                                  DataCell(Label(
                                      "${dstList[selectedRowIndex!].ROLL_NO}"))
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
                      if (dstSqliteModel != null) {
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
                      if (dstSqliteModel != null) {
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
      deletedInfo();

      Navigator.pop(context);
      Navigator.pop(context);
      EasyLoading.showSuccess("Delete Success");
    }
  }

  void deletedInfo() async {
    await databaseHelper.deletedRowSqlite(
        tableName: 'DATA_SHEET',
        columnName: 'ID',
        columnValue: dstList[selectedRowIndex!].ID);
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

  void _sendDataServer() async {
    BlocProvider.of<FilmReceiveBloc>(context).add(
      FilmReceiveSendEvent(
        FilmReceiveOutputModel(
          PONO: dstList[selectedRowIndex!].PO_NO,
          INVOICE: dstList[selectedRowIndex!].IN_VOICE,
          FRIEGHT: dstList[selectedRowIndex!].FRIEGHT,
          DATERECEIVE: dstList[selectedRowIndex!].INCOMING_DATE,
          OPERATORNAME:
              int.tryParse(dstList[selectedRowIndex!].STORE_BY.toString()),
          PACKNO: dstList[selectedRowIndex!].PACK_NO,
          STATUS: dstList[selectedRowIndex!].STATUS,
          WEIGHT1: num.tryParse(dstList[selectedRowIndex!].W1.toString()),
          WEIGHT2: num.tryParse(dstList[selectedRowIndex!].W2.toString()),
          MFGDATE: dstList[selectedRowIndex!].MFG_DATE,
          THICKNESS: dstList[selectedRowIndex!].THICKNESS,
          WRAPGRADE: dstList[selectedRowIndex!].WRAP_GRADE,
          ROLL_NO: dstList[selectedRowIndex!].ROLL_NO,
        ),
      ),
    );
  }

  void _selectData() {
    EasyLoading.showInfo("Please Select Data", duration: Duration(seconds: 2));
  }
}

class FilmReceiveDataSource extends DataGridSource {
  FilmReceiveDataSource({List<DataSheetTableModel>? process}) {
    if (process != null) {
      for (var _item in process) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'pono', value: _item.PO_NO),
              DataGridCell<String>(columnName: 'ivno', value: _item.IN_VOICE),
              DataGridCell<String>(columnName: 'fi', value: _item.FRIEGHT),
              DataGridCell<String>(
                  columnName: 'ic', value: _item.INCOMING_DATE),
              DataGridCell<String>(columnName: 'sb', value: _item.STORE_BY),
              DataGridCell<String>(columnName: 'packno', value: _item.PACK_NO),
              DataGridCell<String>(columnName: 'sd', value: _item.STORE_DATE),
              DataGridCell<String>(columnName: 'status', value: _item.STATUS),
              DataGridCell<String>(columnName: 'w1', value: _item.W1),
              DataGridCell<String>(columnName: 'w2', value: _item.W2),
              DataGridCell<String>(columnName: 'Weight', value: _item.WEIGHT),
              DataGridCell<String>(columnName: 'md', value: _item.MFG_DATE),
              DataGridCell<String>(
                  columnName: 'tn', value: _item.PACK_NO?.substring(0, 1)),
              DataGridCell<String>(columnName: 'wg', value: _item.WRAP_GRADE),
              DataGridCell<String>(columnName: 'rn', value: _item.ROLL_NO),
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
