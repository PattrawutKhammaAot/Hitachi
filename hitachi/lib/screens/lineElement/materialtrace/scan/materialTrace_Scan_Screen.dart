import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';

import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/materialTraces/deleteMaterialTraceModel.dart';

import 'package:hitachi/models/materialTraces/materialTraceUpdateModel.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:hitachi/widget/custom_textinput.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../blocs/materialTrace/update_material_trace_bloc.dart';

class MaterialTraceScanScreen extends StatefulWidget {
  const MaterialTraceScanScreen({super.key, this.onChange});
  final ValueChanged<List<Map<String, dynamic>>>? onChange;

  @override
  State<MaterialTraceScanScreen> createState() =>
      _MaterialTraceScanScreenState();
}

class _MaterialTraceScanScreenState extends State<MaterialTraceScanScreen> {
  MaterialTraceDataSource? datasoruce;
  List<MaterialTraceDatagridModel> dataText = [];
  List<MaterialTraceDatagridModel> dataTextGrid = [];

  TextEditingController _operatorController = TextEditingController();
  TextEditingController _batchController = TextEditingController();
  TextEditingController _processController = TextEditingController();
  TextEditingController _lotNoController = TextEditingController();
  TextEditingController _lotSubController = TextEditingController();
  TextEditingController _materialController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _highVoltageController = TextEditingController();
  TextEditingController _ipeakController = TextEditingController();
  TextEditingController _ipeController = TextEditingController();

  FocusNode _processFocus = FocusNode();
  FocusNode _lotNoFocus = FocusNode();
  FocusNode _operatorNameFocus = FocusNode();
  FocusNode _batchFocus = FocusNode();
  List<int> _index = [];
  bool isCheckValue = false;
  ScrollController _scrollController = ScrollController();

  int id = 0;
  DataGridRow? datagridRow;
  Map<String, double> columnWidths = {
    'no': double.nan,
    'pro': double.nan,
    'mat': double.nan,
    'lot': double.nan,
  };

  @override
  void initState() {
    _getHold();
    _getHoldData().then((value) {
      dataText = value;
      datasoruce = MaterialTraceDataSource(value);
    });
    super.initState();
    _processFocus.requestFocus();
  }

  _setValueDataGrid() async {
    var masterLot = await DatabaseHelper().queryMASTERLOT(
        [_lotNoController.text.trim().replaceAll(RegExp(r"\s+"), "")]);

    if (masterLot.isEmpty) {
      await DatabaseHelper().insertSqlite('MASTERLOT', {
        'Material': _materialController.text.trim(),
        'PROCESS': _processController.text.trim().toUpperCase(),
        'Lot': _lotNoController.text.trim().replaceAll(RegExp(r"\s+"), ""),
        'LOTNO': _lotNoController.text.trim().replaceAll(RegExp(r"\s+"), "")
      });
      await _getHoldData().then((value) {
        dataText = value;
        datasoruce = MaterialTraceDataSource(value);
      });
    } else {
      _errorDialog(
          text: Label("MasterLot Duplicate !"),
          isHideCancle: false,
          onpressOk: () async {
            Navigator.pop(context);
          });
    }

    setState(() {});
  }

  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await DatabaseHelper().queryAllRows('MASTERLOT');

    setState(() {
      widget.onChange?.call(sql);
    });
  }

  Future<List<MaterialTraceDatagridModel>> _getHoldData() async {
    List<Map<String, dynamic>> sql =
        await DatabaseHelper().queryAllRows('MASTERLOT');
    List<MaterialTraceDatagridModel> result =
        sql.map((row) => MaterialTraceDatagridModel.fromMap(row)).toList();
    setState(() {});

    return result;
  }

  Map<String, String> extractValues(String input, {String? type}) {
    Map<String, String> values = {};

    if (type == 'PI') {
      int startIndex = input.indexOf('<');

      if (startIndex >= 0 && 8 >= 0) {
        String value = input.substring(startIndex, 8);
        values['PI'] = value;
      }

      return values;
    } else {
      List<String> parts = input.split('<');

      for (int i = 1; i < parts.length; i++) {
        List<String> codeValue = parts[i].split('>');

        if (codeValue.length == 2) {
          String code = codeValue[0];
          String value = codeValue[1];
          values[code] = value; // Add code and value to the map
        }
      }
      return values;
    }
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (_lotNoController.text.isNotEmpty) {
          var mapMat = extractValues(_lotNoController.text);
          var mapLot = extractValues(_lotNoController.text, type: "PI");

          _materialController.text = mapMat['PI'] ?? "";
          _lotSubController.text = mapLot['PI'] ?? "";
          isCheckValue = true;
          Future.delayed(Duration(milliseconds: 500), () {
            _lotNoController.selection = TextSelection(
                baseOffset: 0, extentOffset: _lotNoController.text.length);
          });
        } else {
          isCheckValue = false;
        }
        setState(() {});
      }
    }
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
              // await deletedInfo();
              // await _refreshPage();
              _operatorController.clear();
              _batchController.clear();
              _processController.clear();
              _lotNoController.clear();
              _ipeakController.clear();
              _ipeController.clear();
              _highVoltageController.clear();
              _processFocus.requestFocus();
              EasyLoading.showSuccess("Send Success !");
              isCheckValue = false;
              setState(() {});
            } else {
              EasyLoading.showError("${state.item.MESSAGE}");
            }
            EasyLoading.dismiss();
          } else if (state is UpdateMaterialTraceErrorState) {
            EasyLoading.showError("Please Check your Connection and try again");
          }
        }),
        BlocListener<LineElementBloc, LineElementState>(
            listener: (context, state) {
          if (state is GetIPEProdSpecByBatchLoadedState) {
            if (state.item.IPE_NO != null) {
              _ipeController.text = state.item.IPE_NO!;
            }
            print(_ipeController.text);
            setState(() {});
          }
        })
      ],
      child: BgWhite(
          isHideAppBar: true,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CustomTextInputField(
                          controller: _processController,
                          focusNode: _processFocus,
                          isHideLable: true,
                          labelText: "Machine/Process",
                          maxLength: 3,
                          onFieldSubmitted: (value) {
                            if (value.length == 3) {
                              _lotNoFocus.requestFocus();
                            }
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: RawKeyboardListener(
                              onKey: _handleKeyEvent,
                              focusNode: FocusNode(),
                              child: TextFormField(
                                textInputAction: TextInputAction.done,
                                focusNode: _lotNoFocus,
                                controller: _lotNoController,
                                minLines: 1,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  labelText: "Lot No",
                                  labelStyle: TextStyle(color: COLOR_BLUE_DARK),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(COLOR_RED)),
                            onPressed: () async {
                              if (_index.isNotEmpty) {
                                await deletedInfo();
                                await _refreshPage();
                              } else {
                                EasyLoading.showError("Please Select Column");
                              }
                            },
                            child: Label(
                              "Delete Lot",
                              color: COLOR_WHITE,
                            )),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      COLOR_BLUE_DARK)),
                              onPressed: () async {
                                if (_index.isNotEmpty) {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (buildContext) {
                                        _operatorNameFocus.requestFocus();
                                        return AlertDialog(
                                          title: Label("Edit Material"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              FutureBuilder(
                                                future: Future.delayed(Duration
                                                    .zero), // ใช้ Future.delayed เพื่อทำให้โฟกัสทันที
                                                builder: (context, snapshot) {
                                                  _operatorNameFocus
                                                      .requestFocus();
                                                  return SizedBox
                                                      .shrink(); // ไม่มีการแสดงผลในระหว่างการรอ Future.delayed
                                                },
                                              ),
                                              CustomTextInputField(
                                                focusNode: _operatorNameFocus,
                                                controller: _operatorController,
                                                isHideLable: true,
                                                labelText: "Operator Name",
                                                maxLength: 10,
                                                onFieldSubmitted: (value) {
                                                  if (value.length == 10) {
                                                    _batchFocus.requestFocus();
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              CustomTextInputField(
                                                focusNode: _batchFocus,
                                                isHideLable: true,
                                                labelText: "Batch/Serial",
                                                controller: _batchController,
                                                onFieldSubmitted:
                                                    (value) async {
                                                  BlocProvider.of<
                                                              LineElementBloc>(
                                                          context)
                                                      .add(
                                                    GetIPEProdSpecByBatchEvent(
                                                      _batchController.text
                                                          .trim(),
                                                    ),
                                                  );
                                                  await Future.delayed(Duration(
                                                      milliseconds: 500));
                                                  await sendApi();
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStatePropertyAll(
                                                                    COLOR_RED)),
                                                        onPressed: () {
                                                          _operatorController
                                                              .clear();
                                                          _batchController
                                                              .clear();
                                                          Navigator.pop(
                                                              context);
                                                          _operatorController
                                                              .clear();
                                                        },
                                                        child: Label(
                                                          "Back",
                                                          color: COLOR_WHITE,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStatePropertyAll(
                                                                    COLOR_BLUE_DARK)),
                                                        onPressed: () async {
                                                          BlocProvider.of<
                                                                      LineElementBloc>(
                                                                  context)
                                                              .add(
                                                            GetIPEProdSpecByBatchEvent(
                                                              _batchController
                                                                  .text
                                                                  .trim(),
                                                            ),
                                                          );
                                                          await Future.delayed(
                                                              Duration(
                                                                  milliseconds:
                                                                      500));
                                                          await sendApi();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Label(
                                                          "Send",
                                                          color: COLOR_WHITE,
                                                        )),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                } else {
                                  EasyLoading.showError("Please SelectRow");
                                }
                              },
                              child: Label(
                                "Edit Mat",
                                color: COLOR_WHITE,
                                textAlign: TextAlign.center,
                              )),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      isCheckValue
                                          ? COLOR_SUCESS
                                          : COLOR_GREY)),
                              onPressed: isCheckValue
                                  ? () async {
                                      if (_lotNoController.text.isNotEmpty &&
                                          _processController.text.isNotEmpty &&
                                          _materialController.text.isNotEmpty &&
                                          _lotSubController.text.isNotEmpty &&
                                          _materialController.text != '') {
                                        await _setValueDataGrid();
                                        isCheckValue = false;
                                        setState(() {});
                                      } else {
                                        EasyLoading.showError(
                                            "Please Input Lot No");
                                      }
                                    }
                                  : () {
                                      EasyLoading.showError(
                                          "Please Enter Lot No");
                                    },
                              child: Label(
                                "Save Lot",
                                color: COLOR_WHITE,
                              )),
                        ),
                      ],
                    ),
                  ),
                  datasoruce != null
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            height: dataText.length >= 3
                                ? MediaQuery.of(context).size.width
                                : 150,
                            child: SfDataGrid(
                              shrinkWrapColumns: true,
                              shrinkWrapRows: true,
                              // horizontalScrollPhysics: BouncingScrollPhysics(),
                              verticalScrollPhysics: BouncingScrollPhysics(),
                              columnWidthMode: ColumnWidthMode.fill,
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              // allowSwiping: true,
                              isScrollbarAlwaysShown: true,
                              // // allowPullToRefresh: true,
                              allowColumnsResizing: true,
                              columnResizeMode: ColumnResizeMode.onResizeEnd,
                              selectionMode: SelectionMode.multiple,
                              source: datasoruce!,
                              showCheckboxColumn: true,
                              onColumnResizeUpdate:
                                  (ColumnResizeUpdateDetails details) {
                                setState(() {
                                  columnWidths[details.column.columnName] =
                                      details.width;
                                });
                                return true;
                              },
                              onSelectionChanged:
                                  (selectRow, deselectedRows) async {
                                if (selectRow.isNotEmpty) {
                                  if (selectRow.length ==
                                          datasoruce!.effectiveRows.length &&
                                      selectRow.length > 1) {
                                    setState(() {
                                      selectRow.forEach((row) {
                                        _index.add(int.tryParse(row
                                            .getCells()[0]
                                            .value
                                            .toString())!);
                                      });
                                    });
                                  } else {
                                    setState(() {
                                      _index.add(int.tryParse(selectRow.first
                                          .getCells()[0]
                                          .value
                                          .toString())!);
                                      datagridRow = selectRow.first;
                                      dataTextGrid = datagridRow!
                                          .getCells()
                                          .map(
                                            (e) => MaterialTraceDatagridModel(),
                                          )
                                          .toList();
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
                              columns: [
                                GridColumn(
                                  width: columnWidths['no']!,
                                  columnName: 'no',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label(
                                        'No.',
                                        color: COLOR_WHITE,
                                      ),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  width: columnWidths['pro']!,
                                  columnName: 'pro',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label(
                                        'Pro.',
                                        color: COLOR_WHITE,
                                      ),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  width: columnWidths['mat']!,
                                  columnName: 'mat',
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
                                  width: columnWidths['lot']!,
                                  // width: MediaQuery.of(context).size.width,
                                  columnName: 'lot',
                                  label: Container(
                                    color: COLOR_BLUE_DARK,
                                    child: Center(
                                      child: Label(
                                        'Lot',
                                        color: COLOR_WHITE,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          )),
    );
  }

  Future sendApi() async {
    if (_index.isNotEmpty &&
        _operatorController.text.isNotEmpty &&
        _batchController.text.isNotEmpty) {
      _index.forEach((element) async {
        for (var item in dataText) {
          if (item.ID == element) {
            BlocProvider.of<UpdateMaterialTraceBloc>(context).add(
                DeleteMaterialTraceTraceEvent(DeleteMaterialTraceUpdateModel(
                    BATCH: _batchController.text.trim(), PROCESS: item.Pro)));

            BlocProvider.of<UpdateMaterialTraceBloc>(context).add(
                PostUpdateMaterialTraceEvent(
                    MaterialTraceUpdateModel(
                        DATE: DateTime.now().toString(),
                        IPE_NO: _ipeController.text,
                        MATERIAL: item.Mat,
                        LOT: item.Lot,
                        PROCESS: item.Pro,
                        I_PEAK: null,
                        HIGH_VOLT: null,
                        OPERATOR: _operatorController.text.trim(),
                        BATCH_NO: _batchController.text.trim()),
                    "MatUp"));
          }
        }
      });
    } else {
      print(_materialController.text);
      if (_operatorController.text.isEmpty) {
        _operatorNameFocus.requestFocus();
      } else if (_batchController.text.isEmpty) {
        _batchFocus.requestFocus();
      } else if (_operatorController.text.isEmpty &&
          _operatorController.text.isEmpty) {
        _operatorNameFocus.requestFocus();
      } else if (_index.isEmpty) {
        EasyLoading.showError("Please Select Row");
      } else {}
    }
  }

  Future deletedInfo() async {
    setState(() {
      _index.forEach((element) async {
        await DatabaseHelper().deletedRowSqlite(
            tableName: 'MASTERLOT', columnName: 'ID', columnValue: element);
        _index.clear();
      });
    });
  }

  Future _refreshPage() async {
    await Future.delayed(Duration(seconds: 1), () {
      _getHoldData().then((value) {
        dataText = value;
        datasoruce = MaterialTraceDataSource(value);
      });
      setState(() {});
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
}

class MaterialTraceDataSource extends DataGridSource {
  MaterialTraceDataSource(List<MaterialTraceDatagridModel> items) {
    for (var item in items) {
      _employees.add(DataGridRow(
        cells: [
          DataGridCell<int>(columnName: 'no', value: item.ID),
          DataGridCell<String>(columnName: 'pro', value: item.Pro),
          DataGridCell<String>(columnName: 'mat', value: item.Mat),
          DataGridCell<String>(columnName: 'lot', value: item.Lot),
        ],
      ));
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

class MaterialTraceDatagridModel {
  const MaterialTraceDatagridModel({this.Lot, this.Mat, this.Pro, this.ID});
  final int? ID;
  final String? Pro;
  final String? Mat;
  final String? Lot;

  List<Object> get props => [ID!, Pro!, Mat!, Lot!];
  MaterialTraceDatagridModel.fromMap(Map<String, dynamic> map)
      : ID = map['ID'],
        Pro = map['PROCESS'],
        Mat = map['Material'],
        Lot = map['Lot'];
}
