import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/blocs/machineBreakDown/machine_break_down_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/breakdownSheetModel.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MachineBreakDownHoldScreen extends StatefulWidget {
  const MachineBreakDownHoldScreen({super.key});

  @override
  State<MachineBreakDownHoldScreen> createState() =>
      _MachineBreakDownHoldScreenState();
}

class _MachineBreakDownHoldScreenState
    extends State<MachineBreakDownHoldScreen> {
  final TextEditingController password = TextEditingController();
  BreakDownDataSource? BreakdownDataSource;
  List<BreakDownSheetModel>? bdsSqliteModel;
  List<BreakDownSheetModel> bdsList = [];
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

    _getWindingSheet().then((result) {
      setState(() {
        bdsList = result;
        BreakdownDataSource = BreakDownDataSource(process: bdsList);
      });
    });
  }

  Future<List<BreakDownSheetModel>> _getWindingSheet() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllRows('BREAKDOWN_SHEET');
      List<BreakDownSheetModel> result = rows
          .map((row) => BreakDownSheetModel.fromMap(
              row.map((key, value) => MapEntry(key, value.toString()))))
          .toList();

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
        BlocListener<MachineBreakDownBloc, MachineBreakDownState>(
          listener: (context, state) {
            if (state is PostMachineBreakdownLoadingState) {
              EasyLoading.show();
            }
            if (state is PostMachineBreakdownLoadedState) {
              if (state.item.RESULT == true) {
                deletedInfo();
                Navigator.pop(context);
                EasyLoading.showSuccess("Send complete",
                    duration: Duration(seconds: 3));
              } else {
                EasyLoading.showError("Please Check Data");
              }
            }
            if (state is PostMachineBreakdownErrorState) {
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
              BreakdownDataSource != null
                  ? Expanded(
                      child: Container(
                        child: SfDataGrid(
                          source: BreakdownDataSource!,
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
                                datagridRow = BreakdownDataSource!.effectiveRows
                                    .elementAt(selectedRowIndex!);
                                bdsSqliteModel = datagridRow!
                                    .getCells()
                                    .map(
                                      (e) => BreakDownSheetModel(),
                                    )
                                    .toList();
                                _colorSend = COLOR_SUCESS;
                                _colorDelete = COLOR_RED;
                              });
                            }
                          },
                          columns: <GridColumn>[
                            GridColumn(
                                columnName: 'machineno',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Machine No.',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                  // color: COLOR_BLUE_DARK,
                                )),
                            GridColumn(
                              columnName: 'operatorName',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                    child: Label(
                                  'Operator Name',
                                  textAlign: TextAlign.center,
                                  fontSize: 14,
                                  color: COLOR_WHITE,
                                )),
                              ),
                            ),
                            GridColumn(
                                columnName: 'service',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Service',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                ),
                                width: 100),
                            GridColumn(
                                columnName: 'breakstart',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'BreakStart',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                ),
                                width: 100),
                            GridColumn(
                                columnName: 'tech1',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Tech1',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'starttech1',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'StartTech1',
                                    textAlign: TextAlign.center,
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'tech2',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Tech2',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'starttech2',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'StartTech2',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'stoptech1',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'StopTech1',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'stoptech2',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'StopTech2',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'accept',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Accept',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'breakstop',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'BreakStop',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                          ],
                        ),
                      ),
                    )
                  : CircularProgressIndicator(),
              bdsSqliteModel != null && bdsList != null
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
                                  DataCell(Center(child: Label("Machine No."))),
                                  DataCell(Label(
                                      "${bdsList[selectedRowIndex!].MACHINE_NO}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("OperatorName"))),
                                  DataCell(Label(
                                      "${bdsList[selectedRowIndex!].OPERATOR_NAME}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("SERVICE"))),
                                  DataCell(Label(
                                      "${bdsList[selectedRowIndex!].SERVICE_NO}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("BreakStartDate"))),
                                  DataCell(Label(
                                      "${bdsList[selectedRowIndex!].BREAK_START_DATE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Tech1"))),
                                  DataCell(Label(
                                      "${bdsList[selectedRowIndex!].TECH_1}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("StartTech1"))),
                                  DataCell(Label(
                                      "${bdsList[selectedRowIndex!].START_TECH_DATE_1}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Tech2"))),
                                  DataCell(Label(
                                      "${bdsList[selectedRowIndex!].TECH_2}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("StartTech2"))),
                                  DataCell(Label(
                                      "${bdsList[selectedRowIndex!].START_TECH_DATE_2}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("StopTech1"))),
                                  DataCell(Label(
                                      "${bdsList[selectedRowIndex!].STOP_DATE_TECH_1}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("StopTech2"))),
                                  DataCell(Label(
                                      "${bdsList[selectedRowIndex!].STOP_DATE_TECH_2}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Accept"))),
                                  DataCell(Label(
                                      "${bdsList[selectedRowIndex!].OPERATOR_ACCEPT}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("BreakStop"))),
                                  DataCell(Label(
                                      "${bdsList[selectedRowIndex!].BREAK_STOP_DATE}"))
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
                      if (bdsSqliteModel != null) {
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
                      if (bdsSqliteModel != null) {
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

  void _checkValueController() async {
    if (password.text.isNotEmpty) {
      Navigator.pop(context);
      Navigator.pop(context);
      EasyLoading.showSuccess("Delete Success");
    }
  }

  void deletedInfo() async {
    await databaseHelper.deletedRowSqlite(
        tableName: 'BREAKDOWN_SHEET',
        columnName: 'ID',
        columnValue: bdsList[selectedRowIndex!].ID);
  }

  void _sendDataServer() async {
    // BlocProvider.of<LineElementBloc>(context).add(
    //   PostSendWindingStartEvent(
    //     SendWindingStartModelOutput(
    //         MACHINE_NO: bdsList[selectedRowIndex!].MACHINE_NO,
    //         OPERATOR_NAME: int.tryParse(
    //             bdsList[selectedRowIndex!].OPERATOR_NAME.toString()),
    //         PRODUCT: int.tryParse(
    //           bdsList[selectedRowIndex!].PRODUCT.toString(),
    //         ),
    //         FILM_PACK_NO: int.tryParse(
    //           bdsList[selectedRowIndex!].PACK_NO.toString(),
    //         ),
    //         PAPER_CODE_LOT: bdsList[selectedRowIndex!].PAPER_CORE,
    //         PP_FILM_LOT: bdsList[selectedRowIndex!].PP_CORE,
    //         FOIL_LOT: bdsList[selectedRowIndex!].FOIL_CORE),
    //   ),
    // );
  }

  void _selectData() {
    EasyLoading.showInfo("Please Select Data", duration: Duration(seconds: 2));
  }
}

class BreakDownDataSource extends DataGridSource {
  BreakDownDataSource({List<BreakDownSheetModel>? process}) {
    if (process != null) {
      for (var _item in process) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<String>(
                  columnName: 'machineno', value: _item.MACHINE_NO),
              DataGridCell<String>(
                  columnName: 'operatorName', value: _item.OPERATOR_NAME),
              DataGridCell<String>(
                  columnName: 'service', value: _item.SERVICE_NO),
              DataGridCell<String>(
                  columnName: 'breakstart', value: _item.BREAK_START_DATE),
              DataGridCell<String>(columnName: 'tech1', value: _item.TECH_1),
              DataGridCell<String>(
                  columnName: 'starttech1', value: _item.START_TECH_DATE_1),
              DataGridCell<String>(columnName: 'tech2', value: _item.TECH_2),
              DataGridCell<String>(
                  columnName: 'starttech2', value: _item.START_TECH_DATE_2),
              DataGridCell<String>(
                  columnName: 'stoptech1', value: _item.STOP_DATE_TECH_1),
              DataGridCell<String>(
                  columnName: 'stoptech2', value: _item.STOP_DATE_TECH_2),
              DataGridCell<String>(
                  columnName: 'accept', value: _item.OPERATOR_ACCEPT),
              DataGridCell<String>(
                  columnName: 'breakstop', value: _item.BREAK_STOP_DATE),
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