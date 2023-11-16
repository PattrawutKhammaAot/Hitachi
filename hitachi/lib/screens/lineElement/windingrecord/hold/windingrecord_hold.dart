import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/windingRecord/windingrecord_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/windingrecordModel.dart';
import 'package:hitachi/models/windingRecordModel/output_windingRecordModel.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class WindingRecordHoldScreen extends StatefulWidget {
  WindingRecordHoldScreen({super.key, this.onChange});
  ValueChanged<List<Map<String, dynamic>>>? onChange;
  @override
  State<WindingRecordHoldScreen> createState() =>
      _WindingRecordHoldScreenState();
}

class _WindingRecordHoldScreenState extends State<WindingRecordHoldScreen> {
  Color _colorSend = COLOR_GREY;
  Color _colorDelete = COLOR_GREY;
  Map<String, double> columnWidths = {
    'ID': double.nan,
    'BATCH_NO': double.nan,
    'START_TIME': double.nan,
    'FINISH_TIME': double.nan,
    'IPENO': double.nan,
    'THICKNESS': double.nan,
    'TURN': double.nan,
    'DIAMETER': double.nan,
    'CUSTOMER': double.nan,
    'UF': double.nan,
    'PPM_WEIGHT': double.nan,
    'PACK_NO': double.nan,
    'OUTPUT': double.nan,
    'GROSS': double.nan,
    'WIDTH_L': double.nan,
    'WIDHT_R': double.nan,
    'CB11': double.nan,
    'CB12': double.nan,
    'CB13': double.nan,
    'CB21': double.nan,
    'CB22': double.nan,
    'CB23': double.nan,
    'CB31': double.nan,
    'CB32': double.nan,
    'CB33': double.nan,
    'OF1': double.nan,
    'OF2': double.nan,
    'OF3': double.nan,
    'BURN_OFF': double.nan,
    'FS1': double.nan,
    'FS2': double.nan,
    'FS3': double.nan,
    'FS4': double.nan,
    'GRADE': double.nan,
    'TIME_PRESS': double.nan,
    'TIME_RELEASED': double.nan,
    'HEAT_TEMP': double.nan,
    'TENSION': double.nan,
    'NIP_ROLL_PRESS': double.nan,
    'CheckComplete': double.nan,
  };
  DatabaseHelper databaseHelper = DatabaseHelper();
  WindingRecordDataSource? wdRecordDBS;
  List<int> _index = [];
  DataGridRow? datagridRow;
  List<WindingRecordModelSqlite>? wdrSqliteModel;
  List<WindingRecordModelSqlite> wdrList = [];
  List<int> batchID = [];
  Future<List<WindingRecordModelSqlite>> _getTreatMentSheet() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllRows('WINDING_RECORD_SEND_SERVER');
      List<WindingRecordModelSqlite> result =
          rows.map((row) => WindingRecordModelSqlite.fromMap(row)).toList();
      return result;
    } catch (e, s) {
      print(e);
      print(s);
      return [];
    }
  }

  void initState() {
    _getTreatMentSheet().then((result) {
      setState(() {
        wdrList = result;
        wdRecordDBS = WindingRecordDataSource(process: wdrList);
      });
    });

    super.initState();
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
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
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
        BlocListener<WindingrecordBloc, WindingrecordState>(
            listener: (context, state) async {
          if (state is SendWindingRecordLoadingState) {
            EasyLoading.show(status: "Loading ...");
          } else if (state is SendWindingRecordLoadedState) {
            if (state.item.MESSAGE == "Success") {
              if (batchID.isNotEmpty) {
                for (var iditem in batchID) {
                  await deletedInfo(type: "Success", ID: iditem);
                }

                await _getHold();
                await _refreshPage();
              }

              EasyLoading.dismiss();

              EasyLoading.showSuccess("Send Success!");
            } else {
              _errorDialog(
                  isHideCancle: false,
                  text: Label("${state.item.MESSAGE ?? "Check Connection"}"),
                  onpressOk: () {
                    Navigator.pop(context);
                  });
            }
          } else if (state is SendWindingRecordErrorState) {
            EasyLoading.dismiss();
            _errorDialog(
                isHideCancle: false,
                text: Label(" Check Connection"),
                onpressOk: () {
                  Navigator.pop(context);
                });
          }
        }),
      ],
      child: BgWhite(
          isHideAppBar: true,
          body: Column(
            children: [
              wdRecordDBS != null
                  ? Expanded(
                      child: Container(
                        child: SfDataGrid(
                          showCheckboxColumn: true,
                          source: wdRecordDBS!,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          gridLinesVisibility: GridLinesVisibility.both,
                          selectionMode: SelectionMode.multiple,
                          allowPullToRefresh: true,
                          allowColumnsResizing: true,
                          sortingGestureType: SortingGestureType.tap,
                          onColumnResizeUpdate:
                              (ColumnResizeUpdateDetails details) {
                            setState(() {
                              columnWidths[details.column.columnName] =
                                  details.width;
                            });
                            return true;
                          },
                          columnResizeMode: ColumnResizeMode.onResizeEnd,
                          onSelectionChanged:
                              (selectRow, deselectedRows) async {
                            if (selectRow.isNotEmpty) {
                              if (selectRow.length ==
                                      wdRecordDBS!.effectiveRows.length &&
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
                                  wdrSqliteModel = datagridRow!
                                      .getCells()
                                      .map(
                                        (e) => WindingRecordModelSqlite(),
                                      )
                                      .toList();

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
                                columnName: 'ID',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                    child: Label('ID', color: COLOR_WHITE),
                                  ),
                                ),
                                width: 100),
                            GridColumn(
                              width: columnWidths['BATCH_NO']!,
                              columnName: 'BATCH_NO',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('BATCH_NO', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['START_TIME']!,
                              columnName: 'START_TIME',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child:
                                      Label('START TIME', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['FINISH_TIME']!,
                              columnName: 'FINISH_TIME',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child:
                                      Label('FINISH TIME', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['IPENO']!,
                              columnName: 'IPENO',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('IPE NO', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['THICKNESS']!,
                              columnName: 'THICKNESS',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('THICKNESS', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['TURN']!,
                              columnName: 'TURN',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('TURN', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['DIAMETER']!,
                              columnName: 'DIAMETER',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('DIAMETER', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['CUSTOMER']!,
                              columnName: 'CUSTOMER',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('CUSTOMER', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['UF']!,
                              columnName: 'UF',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('UF', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['PPM_WEIGHT']!,
                              columnName: 'PPM_WEIGHT',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child:
                                      Label('PPM WEIGHT', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['PACK_NO']!,
                              columnName: 'PACK_NO',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('PACK NO', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['OUTPUT']!,
                              columnName: 'OUTPUT',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('OUTPUT', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['GROSS']!,
                              columnName: 'GROSS',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('GROSS', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['WIDTH_L']!,
                              columnName: 'WIDTH_L',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('WIDTH L', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['WIDHT_R']!,
                              columnName: 'WIDHT_R',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('WIDHT R', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['CB11']!,
                              columnName: 'CB11',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('CB11', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['CB12']!,
                              columnName: 'CB12',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('CB12', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['CB13']!,
                              columnName: 'CB13',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('CB13', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['CB21']!,
                              columnName: 'CB21',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('CB21', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['CB22']!,
                              columnName: 'mCB22ac',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('CB22', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['CB23']!,
                              columnName: 'CB23',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('CB23', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['CB31']!,
                              columnName: 'CB31',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('CB31', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['CB32']!,
                              columnName: 'CB32',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('CB32', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['CB33']!,
                              columnName: 'CB33',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('CB33', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['OF1']!,
                              columnName: 'OF1',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('OF1', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['OF2']!,
                              columnName: 'OF2',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('OF2', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['OF3']!,
                              columnName: 'OF3',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('OF3', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['BURN_OFF']!,
                              columnName: 'BURN_OFF',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('BURN OFF', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['FS1']!,
                              columnName: 'FS1',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('FS1', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['FS2']!,
                              columnName: 'FS2',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('FS2', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['FS3']!,
                              columnName: 'FS3',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('FS3', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['FS4']!,
                              columnName: 'FS4',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('FS4', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['GRADE']!,
                              columnName: 'GRADE',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('GRADE', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['TIME_PRESS']!,
                              columnName: 'TIME_PRESS',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child:
                                      Label('TIME PRESS', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['TIME_RELEASED']!,
                              columnName: 'TIME_RELEASED',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('TIME RELEASED',
                                      color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['HEAT_TEMP']!,
                              columnName: 'HEAT_TEMP',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('HEAT TEMP', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['TENSION']!,
                              columnName: 'TENSION',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('TENSION', color: COLOR_WHITE),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['NIP_ROLL_PRESS']!,
                              columnName: 'NIP_ROLL_PRESS',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label('NIP ROLL PRESS',
                                      color: COLOR_WHITE),
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
                                DataCell(Center(child: Label("BATCH No"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.BATCH_NO}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("START TIME"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.START_TIME}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("FINISH TIME"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.FINISH_TIME}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("IPE_NO"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.IPE_NO}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Thickness"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.THICKNESS}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Turn"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.TURN}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Diameter"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.DIAMETER}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Customer"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.CUSTOMER}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("UF"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.UF}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("PPM_WEIGHT"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.PPM_WEIGHT}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("PACK_NO"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.PACK_NO}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("OUTPUT"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.OUTPUT}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Gross"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.GROSS}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("WIDTH_L"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.WIDTH_L}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("WIDTH_R"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.WIDHT_R}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("CB11"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.CB11}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("CB12"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.CB12}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("CB13"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.CB13}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("CB21"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.CB21}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("CB22"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.CB22}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("CB23"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.CB23}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("CB31"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.CB31}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("CB32"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.CB32}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("CB33"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.CB33}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("OF1"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.OF1}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("OF2"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.OF2}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("OF3"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.OF3}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("BURN OFF"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.BURN_OFF}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("FS1"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.FS1}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("FS2"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.FS2}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("FS3"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.FS3}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("FS4"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.FS4}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("GRADE"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.GRADE}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("TIME_PRESS"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.TIME_PRESS}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("TIME_RELEASED"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.TIME_RELEASED}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("HEAT_TEMP"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.HEAT_TEMP}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("TENSION"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.TENSION}"))
                              ]),
                              DataRow(cells: [
                                DataCell(
                                    Center(child: Label("NIP_ROLL_PRESS"))),
                                DataCell(Label(
                                    "${wdrList.where((element) => element.ID == _index.first).first.NIP_ROLL_PRESS}"))
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
          )),
    );
  }

  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('WINDING_RECORD_SEND_SERVER');

    setState(() {
      widget.onChange?.call(sql.toList());
    });
  }

  _sendDataServer() {
    _index.forEach((element) async {
      print(_index.length);
      var row = wdrList.where((value) => value.ID == element).first;

      batchID.add(row.ID!);
      BlocProvider.of<WindingrecordBloc>(context).add(
        SendWindingRecordEvent(OutputWindingRecordModel(
          BATCH_NO: row.BATCH_NO,
          START_DATE: row.START_TIME,
          END_DATE: row.FINISH_TIME,
          START_TIME: row.START_TIME,
          FINISH_TIME: row.FINISH_TIME,
          MACHINE: "",
          OPERATOR: "",
          OUTPUT: int.tryParse(row.OUTPUT!),
          IPE_NO: int.tryParse(row.IPE_NO!),
          THICKNESS: row.THICKNESS,
          PACK_NO: row.PACK_NO,
          PPM_WEIGHT: num.tryParse(row.PPM_WEIGHT!),
          TURN: int.tryParse(row.TURN!),
          DIAMETER: num.tryParse(row.DIAMETER!),
          CUSTOMER: row.CUSTOMER,
          UF: num.tryParse(row.UF!),
          GROSS: num.tryParse(row.GROSS!),
          WIDTHL: num.tryParse(row.WIDHT_R!),
          WIDTHR: num.tryParse(row.WIDTH_L!),
          CB11: num.tryParse(row.CB11!),
          CB12: num.tryParse(row.CB12!),
          CB13: num.tryParse(row.CB13!),
          CB21: num.tryParse(row.CB21!),
          CB22: num.tryParse(row.CB22!),
          CB23: num.tryParse(row.CB23!),
          CB31: num.tryParse(row.CB31!),
          CB32: num.tryParse(row.CB32!),
          CB33: num.tryParse(row.CB33!),
          OF1: num.tryParse(row.OF1!),
          OF2: num.tryParse(row.OF2!),
          OF3: num.tryParse(row.OF3!),
          BURNOFF: num.tryParse(row.BURN_OFF!),
          FS1: num.tryParse(row.FS1!),
          FS2: num.tryParse(row.FS2!),
          FS3: num.tryParse(row.FS3!),
          FS4: num.tryParse(row.FS4!),
          GRADE: row.GRADE,
          TIME_PRESS: num.tryParse(row.TIME_PRESS!),
          TIME_RELEASED: num.tryParse(row.TIME_RELEASED!),
          HEAT_TEMP: num.tryParse(row.HEAT_TEMP!),
          TENSION: int.tryParse(row.TENSION!),
          NIP_ROLL_PRESS: row.NIP_ROLL_PRESS,
        )),
      );
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
          wdrList = result;
          wdRecordDBS = WindingRecordDataSource(process: wdrList);
        });
      });
    });
  }

  Future deletedInfo({String? type, int? ID}) async {
    if (type == "Success") {
      wdrList.forEach((row) async {
        if (row.BATCH_NO != null &&
            row.START_TIME != null &&
            row.FINISH_TIME != null &&
            row.IPE_NO != null &&
            row.THICKNESS != null &&
            row.TURN != null &&
            row.DIAMETER != null &&
            row.CUSTOMER != null &&
            row.UF != null &&
            row.PPM_WEIGHT != null &&
            row.PACK_NO != null &&
            row.OUTPUT != null &&
            row.GROSS != null &&
            row.WIDTH_L != null &&
            row.WIDHT_R != null &&
            row.CB11 != null &&
            row.CB12 != null &&
            row.CB13 != null &&
            row.CB21 != null &&
            row.CB22 != null &&
            row.CB23 != null &&
            row.CB31 != null &&
            row.CB32 != null &&
            row.CB33 != null &&
            row.OF1 != null &&
            row.OF2 != null &&
            row.OF3 != null &&
            row.BURN_OFF != null &&
            row.FS1 != null &&
            row.FS2 != null &&
            row.FS3 != null &&
            row.FS4 != null &&
            row.GRADE != null &&
            row.TIME_PRESS != null &&
            row.TIME_RELEASED != null &&
            row.HEAT_TEMP != null &&
            row.TENSION != null &&
            row.NIP_ROLL_PRESS != null &&
            row.BATCH_NO != null &&
            row.START_TIME != null &&
            row.FINISH_TIME != null &&
            row.IPE_NO != null &&
            row.THICKNESS != null &&
            row.TURN != null &&
            row.DIAMETER != null &&
            row.CUSTOMER != null &&
            row.UF != null &&
            row.PPM_WEIGHT != null &&
            row.PACK_NO != null &&
            row.OUTPUT != null &&
            row.GROSS != null &&
            row.WIDTH_L != null &&
            row.WIDHT_R != null &&
            row.CB11 != null &&
            row.CB12 != null &&
            row.CB13 != null &&
            row.CB21 != null &&
            row.CB22 != null &&
            row.CB23 != null &&
            row.CB31 != null &&
            row.CB32 != null &&
            row.CB33 != null &&
            row.OF1 != null &&
            row.OF2 != null &&
            row.OF3 != null &&
            row.BURN_OFF != null &&
            row.FS1 != null &&
            row.FS2 != null &&
            row.FS3 != null &&
            row.FS4 != null &&
            row.GRADE != null &&
            row.TIME_PRESS != null &&
            row.TIME_RELEASED != null &&
            row.HEAT_TEMP != null &&
            row.TENSION != null &&
            row.NIP_ROLL_PRESS != null &&
            row.BATCH_NO != '' &&
            row.START_TIME != '' &&
            row.FINISH_TIME != '' &&
            row.IPE_NO != '' &&
            row.THICKNESS != '' &&
            row.TURN != '' &&
            row.DIAMETER != '' &&
            row.CUSTOMER != '' &&
            row.UF != '' &&
            row.PPM_WEIGHT != '' &&
            row.PACK_NO != '' &&
            row.OUTPUT != '' &&
            row.GROSS != '' &&
            row.WIDTH_L != '' &&
            row.WIDHT_R != '' &&
            row.CB11 != '' &&
            row.CB12 != '' &&
            row.CB13 != '' &&
            row.CB21 != '' &&
            row.CB22 != '' &&
            row.CB23 != '' &&
            row.CB31 != '' &&
            row.CB32 != '' &&
            row.CB33 != '' &&
            row.OF1 != '' &&
            row.OF2 != '' &&
            row.OF3 != '' &&
            row.BURN_OFF != '' &&
            row.FS1 != '' &&
            row.FS2 != '' &&
            row.FS3 != '' &&
            row.FS4 != '' &&
            row.GRADE != '' &&
            row.TIME_PRESS != '' &&
            row.TIME_RELEASED != '' &&
            row.HEAT_TEMP != '' &&
            row.TENSION != '' &&
            row.NIP_ROLL_PRESS != '' &&
            row.BATCH_NO != '' &&
            row.START_TIME != '' &&
            row.FINISH_TIME != '' &&
            row.IPE_NO != '' &&
            row.THICKNESS != '' &&
            row.TURN != '' &&
            row.DIAMETER != '' &&
            row.CUSTOMER != '' &&
            row.UF != '' &&
            row.PPM_WEIGHT != '' &&
            row.PACK_NO != '' &&
            row.OUTPUT != '' &&
            row.GROSS != '' &&
            row.WIDTH_L != '' &&
            row.WIDHT_R != '' &&
            row.CB11 != '' &&
            row.CB12 != '' &&
            row.CB13 != '' &&
            row.CB21 != '' &&
            row.CB22 != '' &&
            row.CB23 != '' &&
            row.CB31 != '' &&
            row.CB32 != '' &&
            row.CB33 != '' &&
            row.OF1 != '' &&
            row.OF2 != '' &&
            row.OF3 != '' &&
            row.BURN_OFF != '' &&
            row.FS1 != '' &&
            row.FS2 != '' &&
            row.FS3 != '' &&
            row.FS4 != '' &&
            row.GRADE != '' &&
            row.TIME_PRESS != '' &&
            row.TIME_RELEASED != '' &&
            row.HEAT_TEMP != '' &&
            row.TENSION != '' &&
            row.NIP_ROLL_PRESS != '') {
          await databaseHelper.deletedRowSqlite(
              tableName: 'WINDING_RECORD_SEND_SERVER',
              columnName: 'ID',
              columnValue: ID);
          _index.clear();
        } else {
          print("else");
        }
      });

      setState(() {});
    } else {
      setState(() {
        _index.forEach((element) async {
          await databaseHelper.deletedRowSqlite(
              tableName: 'WINDING_RECORD_SEND_SERVER',
              columnName: 'ID',
              columnValue: element);
          _index.clear();
        });
      });
    }
  }
}

class WindingRecordDataSource extends DataGridSource {
  WindingRecordDataSource({List<WindingRecordModelSqlite>? process}) {
    try {
      if (process != null) {
        for (var _item in process) {
          _employees.add(
            DataGridRow(
              cells: [
                DataGridCell<int>(columnName: 'ID', value: _item.ID),
                DataGridCell<String>(
                    columnName: 'BATCH_NO', value: _item.BATCH_NO.toString()),
                DataGridCell<String>(
                    columnName: 'START_TIME',
                    value: _item.START_TIME.toString()),
                DataGridCell<String>(
                    columnName: 'FINISH_TIME',
                    value: _item.FINISH_TIME.toString()),
                DataGridCell<String>(
                    columnName: 'IPENO', value: _item.IPE_NO.toString()),
                DataGridCell<String>(
                    columnName: 'THICKNESS', value: _item.THICKNESS.toString()),
                DataGridCell<String>(
                    columnName: 'TURN', value: _item.TURN.toString()),
                DataGridCell<String>(
                    columnName: 'DIAMETER', value: _item.DIAMETER.toString()),
                DataGridCell<String>(
                    columnName: 'CUSTOMER', value: _item.CUSTOMER.toString()),
                DataGridCell<String>(
                    columnName: 'UF', value: _item.UF.toString()),
                DataGridCell<String>(
                    columnName: 'PPM_WEIGHT',
                    value: _item.PPM_WEIGHT.toString()),
                DataGridCell<String>(
                    columnName: 'PACK_NO', value: _item.PACK_NO.toString()),
                DataGridCell<String>(
                    columnName: 'OUTPUT', value: _item.OUTPUT.toString()),
                DataGridCell<String>(
                    columnName: 'GROSS', value: _item.GROSS.toString()),
                DataGridCell<String>(
                    columnName: 'WIDTH_L', value: _item.WIDTH_L.toString()),
                DataGridCell<String>(
                    columnName: 'WIDHT_R', value: _item.WIDHT_R.toString()),
                DataGridCell<String>(
                    columnName: 'CB11', value: _item.CB11.toString()),
                DataGridCell<String>(
                    columnName: 'CB12', value: _item.CB12.toString()),
                DataGridCell<String>(
                    columnName: 'CB13', value: _item.CB13.toString()),
                DataGridCell<String>(
                    columnName: 'CB21', value: _item.CB21.toString()),
                DataGridCell<String>(
                    columnName: 'CB22', value: _item.CB22.toString()),
                DataGridCell<String>(
                    columnName: 'CB23', value: _item.CB23.toString()),
                DataGridCell<String>(
                    columnName: 'CB31', value: _item.CB31.toString()),
                DataGridCell<String>(
                    columnName: 'CB32', value: _item.CB32.toString()),
                DataGridCell<String>(
                    columnName: 'CB33', value: _item.CB33.toString()),
                DataGridCell<String>(
                    columnName: 'OF1', value: _item.OF1.toString()),
                DataGridCell<String>(
                    columnName: 'OF2', value: _item.OF2.toString()),
                DataGridCell<String>(
                    columnName: 'OF3', value: _item.OF3.toString()),
                DataGridCell<String>(
                    columnName: 'BURN_OFF', value: _item.BURN_OFF.toString()),
                DataGridCell<String>(
                    columnName: 'FS1', value: _item.FS1.toString()),
                DataGridCell<String>(
                    columnName: 'FS2', value: _item.FS2.toString()),
                DataGridCell<String>(
                    columnName: 'FS3', value: _item.FS3.toString()),
                DataGridCell<String>(
                    columnName: 'FS4', value: _item.FS4.toString()),
                DataGridCell<String>(
                    columnName: 'GRADE', value: _item.GRADE.toString()),
                DataGridCell<String>(
                    columnName: 'TIME_PRESS',
                    value: _item.TIME_PRESS.toString()),
                DataGridCell<String>(
                    columnName: 'TIME_RELEASED',
                    value: _item.TIME_RELEASED.toString()),
                DataGridCell<String>(
                    columnName: 'HEAT_TEMP', value: _item.HEAT_TEMP.toString()),
                DataGridCell<String>(
                    columnName: 'TENSION', value: _item.TENSION.toString()),
                DataGridCell<String>(
                    columnName: 'NIP_ROLL_PRESS',
                    value: _item.NIP_ROLL_PRESS.toString()),
              ],
            ),
          );
        }
      }
    } catch (e, s) {
      print(e);
      print(s);
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
