import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/windingSheetModel.dart';
import 'package:hitachi/models/SendWdFinish/sendWdsFinish_output_Model.dart';
import 'package:hitachi/models/SendWds/SendWdsModel_Output.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:hitachi/services/databaseHelper.dart';
// import 'package:hitachi/models/SendWds/HoldWdsMoel.dart';

class WindingJobFinishHoldScreen extends StatefulWidget {
  const WindingJobFinishHoldScreen({Key? key}) : super(key: key);

  @override
  State<WindingJobFinishHoldScreen> createState() =>
      _WindingJobFinishHoldScreenState();
}

class _WindingJobFinishHoldScreenState
    extends State<WindingJobFinishHoldScreen> {
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController machineNo = TextEditingController();
  // final TextEditingController operatorName = TextEditingController();
  // final TextEditingController batchNo = TextEditingController();
  // final TextEditingController product = TextEditingController();
  // final TextEditingController filmPackNo = TextEditingController();
  // final TextEditingController paperCodeLot = TextEditingController();
  // final TextEditingController ppFilmLot = TextEditingController();
  // final TextEditingController foilLot = TextEditingController();
  // final TextEditingController batchstartdate = TextEditingController();
  // final TextEditingController batchenddate = TextEditingController();
  // final TextEditingController element = TextEditingController();
  // final TextEditingController status = TextEditingController();
  final TextEditingController password = TextEditingController();
  WindingsDataSource? WindingDataSource;
  List<WindingSheetModel>? wdsSqliteModel;
  List<WindingSheetModel> wdsList = [];
  int? selectedRowIndex;
  DataGridRow? datagridRow;
  bool isClick = false;

  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  void initState() {
    super.initState();

    _getWindingSheet().then((result) {
      setState(() {
        wdsList = result;
        WindingDataSource = WindingsDataSource(process: wdsList);
      });
    });
  }

  Future<List<WindingSheetModel>> _getWindingSheet() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllRows('WINDING_SHEET');
      List<WindingSheetModel> result = rows
          .where((row) => row['start_end'] == 'E')
          .map((row) => WindingSheetModel.fromMap(row))
          .toList();
      return result;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      isHideAppBar: true,
      textTitle: "Winding job Finish(Hold)",
      body: MultiBlocListener(
        listeners: [
          BlocListener<LineElementBloc, LineElementState>(
            listener: (context, state) {
              if (state is PostSendWindingFinishLoadingState) {
                EasyLoading.show();
              }
              if (state is PostSendWindingFinishLoadedState) {
                EasyLoading.dismiss();
                EasyLoading.showSuccess("Send Complete");
                setState(() {});
              }
              if (state is PostSendWindingFinishErrorState) {
                EasyLoading.showError("Can not send");
              }
            },
          )
        ],
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              WindingDataSource != null
                  ? Expanded(
                      child: Container(
                        child: SfDataGrid(
                          source: WindingDataSource!,
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
                                datagridRow = WindingDataSource!.effectiveRows
                                    .elementAt(selectedRowIndex!);
                                wdsSqliteModel = datagridRow!
                                    .getCells()
                                    .map(
                                      (e) => WindingSheetModel(
                                        MACHINE_NO: e.value.toString(),
                                        OPERATOR_NAME: e.value.toString(),
                                        BATCH_NO:
                                            int.tryParse(e.value.toString()),
                                        PRODUCT:
                                            int.tryParse(e.value.toString()),
                                        PACK_NO:
                                            int.tryParse(e.value.toString()),
                                        PAPER_CORE: e.value.toString(),
                                        PP_CORE: e.value.toString(),
                                        FOIL_CORE: e.value.toString(),
                                        BATCH_START_DATE: e.value.toString(),
                                        BATCH_END_DATE: e.value.toString(),
                                        ELEMENT:
                                            int.tryParse(e.value.toString()),
                                        STATUS: e.value.toString(),
                                        START_END: e.value.toString(),
                                        CHECK_COMPLETE: e.value.toString(),
                                      ),
                                    )
                                    .toList();
                                print(wdsList[selectedRowIndex!].ID);
                              });
                            }
                          },
                          columns: <GridColumn>[
                            GridColumn(
                                columnName: 'operatorName',
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
                              columnName: 'batch',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                    child: Label(
                                  'Batch No.',
                                  textAlign: TextAlign.center,
                                  fontSize: 14,
                                  color: COLOR_WHITE,
                                )),
                              ),
                            ),
                            GridColumn(
                                columnName: 'startEnd',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Date End',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                ),
                                width: 100),
                            GridColumn(
                                columnName: 'element',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Element Qty',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                ),
                                width: 100),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      child: Center(
                        child: Label(
                          "NO DATA",
                          fontSize: 30,
                        ),
                      ),
                    ),
              wdsSqliteModel != null
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
                                      Center(child: Label("Operator Name"))),
                                  DataCell(Label(
                                      "${wdsList[selectedRowIndex!].OPERATOR_NAME}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Batch No."))),
                                  DataCell(Label(
                                      "${wdsList[selectedRowIndex!].BATCH_NO}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Finish Date"))),
                                  DataCell(Label(
                                      "${wdsList[selectedRowIndex!].START_END}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Element"))),
                                  DataCell(Label(
                                      "${wdsList[selectedRowIndex!].ELEMENT}"))
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
                      if (wdsSqliteModel != null) {
                        _AlertDialog();
                      } else {
                        _LoadingData();
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
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Label(
                            "Scan",
                            color: Colors.grey,
                          ),
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
                      _sendDataServer();
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
      deletedInfo();
    }
  }

  void deletedInfo() async {
    await databaseHelper.deletedRowSqlite(
        tableName: 'WINDING_SHEET',
        columnName: 'ID',
        columnValue: wdsList[selectedRowIndex!].ID);
  }

  void _sendDataServer() async {
    BlocProvider.of<LineElementBloc>(context).add(
      PostSendWindingFinishEvent(
        SendWdsFinishOutputModel(
          OPERATOR_NAME:
              int.tryParse(wdsList[selectedRowIndex!].OPERATOR_NAME.toString()),
          BATCH_NO: wdsList[selectedRowIndex!].BATCH_NO,
          ELEMNT_QTY: wdsList[selectedRowIndex!].ELEMENT,
          FINISH_DATE: DateTime.now().toString(),
        ),
      ),
    );
  }

  void _LoadingData() {
    EasyLoading.showInfo("Please Select Data", duration: Duration(seconds: 2));
  }
}

class WindingsDataSource extends DataGridSource {
  WindingsDataSource({List<WindingSheetModel>? process}) {
    if (process != null) {
      for (var _item in process) {
        if (_item.START_END == 'E') {
          _employees.add(
            DataGridRow(
              cells: [
                DataGridCell<String>(
                    columnName: 'operatorName', value: _item.MACHINE_NO),
                DataGridCell<String>(
                    columnName: 'batch', value: _item.BATCH_NO.toString()),
                DataGridCell<String>(
                    columnName: 'startEnd', value: _item.START_END),
                DataGridCell<String>(
                    columnName: 'element', value: _item.ELEMENT.toString()),
              ],
            ),
          );
        }
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
