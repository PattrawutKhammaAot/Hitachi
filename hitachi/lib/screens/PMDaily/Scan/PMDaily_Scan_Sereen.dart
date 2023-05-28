import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/blocs/planwinding/planwinding_bloc.dart';
import 'package:hitachi/blocs/pmDaily/pm_daily_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/pmdailyModel.dart';
import 'package:hitachi/models/ResponeDefault.dart';
import 'package:hitachi/models/planWinding/PlanWindingOutputModel.dart';
import 'package:hitachi/models/pmdailyModel/PMDailyCheckpointOutputModel.dart';
import 'package:hitachi/models/pmdailyModel/PMDailyOutputModel.dart';
import 'package:hitachi/models/reportRouteSheet/reportRouteSheetModel.dart';
import 'package:hitachi/screens/lineElement/reportRouteSheet/page/problemPage.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PMDaily_Screen extends StatefulWidget {
  const PMDaily_Screen({super.key, this.onChange});
  final ValueChanged<String>? onChange;

  @override
  State<PMDaily_Screen> createState() => _PMDaily_ScreenState();
}

class _PMDaily_ScreenState extends State<PMDaily_Screen> {
  final TextEditingController batchNoController = TextEditingController();
  List<PMDailyOutputModelPlan>? PMDailyCheckPointModel;
  //PMDailyOutputModelPlan
  PlanWindingDataSource? PMDailyDataSource;
  Color? bgChange;
  ResponeDefault? items;
  List<int> _index = [];
  DataGridRow? datagridRow;
  String CheckFirst = "";
  String valuetxtinput = "";

  DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController checkpointController = TextEditingController();
  final TextEditingController operatorNameController = TextEditingController();

  final f1 = FocusNode();
  final f2 = FocusNode();

  bool _enabledOperator = true;
  List<PMDailyModel>? processModelSqlite;

  @override
  void initState() {
    super.initState();
    f1.requestFocus();
    // BlocProvider.of<LineElementBloc>(context).add(
    //   ReportRouteSheetEvenet(batchNoController.text.trim()),
    // );
  }

  // PlanWindingBloc
  // PlanWindingState
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PmDailyBloc, PmDailyState>(
          listener: (context, state) {
            //=======================Status====================================
            if (state is PMDailyGetLoadingState) {
              EasyLoading.show();
              print("(EasyLoading2)");
            } else {
              EasyLoading.dismiss();
              print("(EasyLoadings)");
            }
            if (state is PMDailyGetLoadedState) {
              EasyLoading.dismiss();
              if (state.item.CHECKPOINT!.isEmpty) {
                _errorDialog(
                    text: Label("Load PM Not Complete"),
                    isHideCancle: false,
                    onpressOk: () async {
                      Navigator.pop(context);
                      checkpointController.clear();
                    });
              } else if (state.item.CHECKPOINT!.isNotEmpty) {
                _enabledOperator = false;
                setState(() {
                  bgChange = COLOR_RED;
                  PMDailyCheckPointModel = state.item.CHECKPOINT;
                  PMDailyDataSource =
                      PlanWindingDataSource(CHECKPOINT: PMDailyCheckPointModel);
                });
              }
            }

            if (state is PMDailyGetErrorState) {
              EasyLoading.dismiss();
              EasyLoading.showError("Can not Call Api");
              // print(state.error);
            }
            //===========================send================================
            if (state is PMDailyLoadingState) {
              EasyLoading.show();
              print("loading");
            } else {
              EasyLoading.dismiss();
            }
            if (state is PMDailyLoadedState) {
              print("Loaded");
              EasyLoading.dismiss();
              // EasyLoading.showSuccess("Loaded");

              if (state.item.RESULT == true) {
                EasyLoading.dismiss();

                _errorDialog(
                    text: Label("${state.item.MESSAGE}"),
                    onpressOk: () async {
                      Navigator.pop(context);
                      // operatorNameController.clear();
                      // checkpointController.clear();
                    });
                // _index.clear();
                // bgChange = Colors.grey;
                f1.requestFocus();
              } else if (state.item.RESULT == false) {
                // EasyLoading.showError("Can not send & save Data");
                items = state.item;
                EasyLoading.dismiss();
                _errorDialog(
                    text: Label("${state.item.MESSAGE}"),
                    onpressOk: () async {
                      Navigator.pop(context);
                      await _getProcessStart(_index.first);
                      // operatorNameController.clear();
                      // checkpointController.clear();
                    });
              } else {
                // EasyLoading.showError("Can not Call API");
                EasyLoading.dismiss();
                _errorDialog(
                    text: Label("${state.item.MESSAGE}"),
                    onpressOk: () async {
                      Navigator.pop(context);
                      await _getProcessStart(_index.first);
                      // operatorNameController.clear();
                      // checkpointController.clear();
                      print("checkpointController");
                    });
              }
              f1.requestFocus();
            }
            if (state is PMDailyErrorState) {
              print("ERROR");
              // EasyLoading.dismiss();
              // _errorDialog();
              _getProcessStart(_index.first);
              EasyLoading.showError("Please Check Connection Internet");
            }
            //===========================================================
          },
        )
      ],
      child: BgWhite(
        isHideAppBar: true,
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              RowBoxInputField(
                labelText: "Operator Name : ",
                height: 35,
                controller: operatorNameController,
                maxLength: 12,
                focusNode: f1,
                enabled: _enabledOperator,
                // enabled: _enabledPMDaily,

                onEditingComplete: () {
                  if (operatorNameController.text.isNotEmpty) {
                    setState(() {
                      f2.requestFocus();
                      valuetxtinput = " ";
                    });
                  } else {
                    setState(() {
                      valuetxtinput = "Operator Name : User INVALID";
                    });
                    operatorNameController.clear();
                  }
                },
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^(?!.*\d{12})[0-9]+$'),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              RowBoxInputField(
                labelText: "Check Point : ",
                height: 35,
                maxLength: 10,
                controller: checkpointController,
                focusNode: f2,
                enabled: _enabledOperator,
                // enabled: _enabledPMDaily,
                onEditingComplete: () {
                  if (checkpointController.text.isNotEmpty) {
                    setState(() {
                      f2.requestFocus();
                      valuetxtinput = " ";
                    });
                  } else {
                    setState(() {
                      valuetxtinput = "Check Point : Check Point INVALID";
                    });
                    checkpointController.clear();
                  }
                },

                onChanged: (value) {
                  if (operatorNameController.text.isNotEmpty &&
                      checkpointController.text.isNotEmpty) {
                    // setState(() {
                    //   bgChange = COLOR_RED;
                    // });
                  } else {
                    // setState(() {
                    //   bgChange = Colors.grey;
                    // });
                  }
                },
              ),
              SizedBox(
                height: 5,
              ),
              PMDailyDataSource != null
                  ? Expanded(
                      flex: 5,
                      child: Container(
                        child: SfDataGrid(
                          footerHeight: 10,
                          showCheckboxColumn: true,
                          selectionMode: SelectionMode.single,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          source: PMDailyDataSource!,
                          columnWidthMode: ColumnWidthMode.fill,
                          onSelectionChanged:
                              (selectRow, deselectedRows) async {
                            _index.clear();
                            if (selectRow.isNotEmpty) {
                              if (selectRow.length ==
                                      PMDailyDataSource!.effectiveRows.length &&
                                  selectRow.length > 1) {
                                setState(() {
                                  selectRow.forEach((row) {
                                    _index.add(int.tryParse(
                                        row.getCells()[0].value.toString())!);
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
                                        (e) => PMDailyModel(),
                                      )
                                      .toList();
                                  print(_index);
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

                              print('No Rows Selected');
                            }
                          },
                          columns: [
                            GridColumn(
                              width: 120,
                              columnName: 'no',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'No',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'status',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'Status',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        Visibility(
                          visible: true,
                          child: Container(
                              child: Label(
                            " ${valuetxtinput}",
                            color: COLOR_RED,
                          )),
                        ),
                      ],
                    ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Button(
                      onPress: () => _loadPlan(),
                      text: Label(
                        "Load Status",
                        color: COLOR_WHITE,
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Expanded(
                    flex: 3,
                    child: Button(
                      bgColor: bgChange ?? Colors.grey,
                      onPress: () => _btnSend(_index.first),
                      text: Label(
                        "Send",
                        color: COLOR_WHITE,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _loadPlan() {
    // CheckFirst = checkpointController.text.substring(0, 1);
    // if (CheckFirst == "1" || CheckFirst == "2" || CheckFirst == "3") {
    BlocProvider.of<PmDailyBloc>(context).add(
      PMDailyGetSendEvent(checkpointController.text),
    );
    // } else {
    //   _errorDialog(
    //       text: Label("Check Point Not Correct"),
    //       onpressOk: () async {
    //         Navigator.pop(context);
    //       });
    // }
    // widget.onChange!(batchNoController.text.trim());
  }

  void _btnSend(int _index) async {
    if (checkpointController.text.isNotEmpty &&
        operatorNameController.text.isNotEmpty) {
      _callAPI(_index);
    } else {
      setState(() {
        // _enabledPMDaily = true;
      });
      EasyLoading.showInfo("กรุณาใส่ข้อมูลให้ครบ");
    }
  }

  void _callAPI(int _index) {
    BlocProvider.of<PmDailyBloc>(context).add(
      PMDailySendEvent(PMDailyOutputModel(
        OPERATORNAME: int.tryParse(operatorNameController.text.trim()),
        CHECKPOINT: checkpointController.text.trim(),
        STATUS: _index.toString().trim(),
        STARTDATE:
            DateFormat('yyyy MM dd HH:mm:ss').format(DateTime.now()).toString(),
      )),
    );
  }

  void _saveSendSqlite(int _index) async {
    try {
      if (operatorNameController.text.isNotEmpty) {
        await databaseHelper.insertSqlite('PM_SHEET', {
          'OperatorName': operatorNameController.text.trim(),
          'CheckPointPM': checkpointController.text.trim(),
          'Status': _index.toString().trim(),
          'DatePM': DateFormat('yyyy MM dd HH:mm:ss')
              .format(DateTime.now())
              .toString(),
        });
        print("ok");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _getProcessStart(int _index) async {
    try {
      var sql_pmDailySheet = await databaseHelper.queryDataSelectPMDaily(
        select1: 'OperatorName'.trim(),
        select2: 'CheckPointPM'.trim(),
        select3: 'Status'.trim(),
        select4: 'StartDate'.trim(),
        formTable: 'PM_SHEET'.trim(),
        where: 'OperatorName'.trim(),
        stringValue: operatorNameController.text.trim(),
      );
      print(sql_pmDailySheet.length);

      // if (sql_processSheet[0]['Machine'] != MachineController.text.trim()) {
      print(operatorNameController.text.trim());
      print(sql_pmDailySheet.length);
      if (sql_pmDailySheet.isEmpty) {
        print("if");
        // setState(() {
        print("_checkSendSqlite = true;");
        _saveSendSqlite(_index);
        // });
      } else {
        // setState(() {
        print("_checkSendSqlite = false;");
        // _updateSendSqlite();//
        // });
        print("else");
      }
      return true;
    } catch (e) {
      print("Catch : ${e}");
      return false;
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
}

class PlanWindingDataSource extends DataGridSource {
  PlanWindingDataSource({List<PMDailyOutputModelPlan>? CHECKPOINT}) {
    if (CHECKPOINT != null) {
      for (var _item in CHECKPOINT) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'status', value: _item.STATUS),
              DataGridCell<String>(columnName: 'no', value: _item.DESCRIPTION),
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
