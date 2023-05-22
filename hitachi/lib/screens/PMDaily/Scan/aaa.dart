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
import 'package:hitachi/models/planWinding/PlanWindingOutputModel.dart';
import 'package:hitachi/models/pmdailyModel/PMDailyOutputModel.dart';
import 'package:hitachi/models/reportRouteSheet/reportRouteSheetModel.dart';
import 'package:hitachi/screens/lineElement/reportRouteSheet/page/problemPage.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PMDaily_Screen extends StatefulWidget {
  const PMDaily_Screen({super.key, this.onChange});
  final ValueChanged<String>? onChange;

  @override
  State<PMDaily_Screen> createState() => _PMDaily_ScreenState();
}

class _PMDaily_ScreenState extends State<PMDaily_Screen> {
  final TextEditingController batchNoController = TextEditingController();
  List<PMDailyOutputModel>? PMDailyModel;
  EmployeeDataSource? employeeDataSource;
  Color? bgChange;
  String _loadData = "วันเวลาที่ load : ";

  final TextEditingController operatorNameController = TextEditingController();
  final TextEditingController CheckPointController = TextEditingController();

  final f1 = FocusNode();
  final f2 = FocusNode();

  @override
  void initState() {
    super.initState();
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
            if (state is PMDailyLoadingState) {
              EasyLoading.show();
              print("loading");
            }
            if (state is PMDailyLoadedState) {
              print("Loaded");

              EasyLoading.show(status: "Loaded");

              if (state.item.RESULT == true) {
                EasyLoading.showSuccess("SendComplete");
                // _clearAllData();
              } else if (state.item.RESULT == false) {
                EasyLoading.showError("Can not send & save Data");
                // items = state.item;
                // _getProcessStart();
                // if (_checkSendSqlite == true) {
                //   _saveSendSqlite();
                //   print("save true");
                // } else if (_checkSendSqlite == false) {
                //   _updateSendSqlite();
                //   print("save false");
                // }
                // _clearAllData();
              } else {
                EasyLoading.showError("Can not Call API");
                // _getProcessStart();
                // if (_checkSendSqlite == true) {
                //   _saveSendSqlite();
                //   print("save true");
                // } else if (_checkSendSqlite == false) {
                //   _updateSendSqlite();
                //   print("save false");
                // }
                // _clearAllData();
              }
            }
            if (state is PMDailyErrorState) {
              print("ERROR");
              EasyLoading.dismiss();
              // _getProcessStart();
              // if (_checkSendSqlite == true) {
              //   _saveSendSqlite();
              //   print("save true");
              // } else if (_checkSendSqlite == false) {
              //   _updateSendSqlite();
              //   print("save false");
              // }
              // _clearAllData();
              EasyLoading.showError("Please Check Connection Internet");
            }
          },
        )
      ],
      child: BgWhite(
        isHideAppBar: true,
        textTitle: "Report Route Sheet",
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              // Container(
              //   child: Label(_loadData),
              // ),
              RowBoxInputField(
                labelText: "Operator Name :",
                height: 35,
                controller: operatorNameController,
                maxLength: 12,
                focusNode: f1,
                // enabled: _enabledCheckMachine,
                onEditingComplete: () {
                  f2.requestFocus();
                },
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                onChanged: (value) {
                  if (
                      //MachineController.text.isNotEmpty &&
                      CheckPointController.text.isNotEmpty) {
                    setState(() {
                      bgChange = COLOR_RED;
                    });
                  } else {
                    setState(() {
                      bgChange = Colors.grey;
                    });
                  }
                },
              ),
              SizedBox(
                height: 5,
              ),
              RowBoxInputField(
                labelText: "Check Point :",
                maxLength: 12,
                height: 35,
                controller: CheckPointController,
                type: TextInputType.number,
                focusNode: f2,
                onChanged: (value) {
                  if (
                      //MachineController.text.isNotEmpty &&
                      operatorNameController.text.isNotEmpty) {
                    setState(() {
                      bgChange = COLOR_RED;
                    });
                  } else {
                    setState(() {
                      bgChange = Colors.grey;
                    });
                  }
                },
              ),
              SizedBox(
                height: 5,
              ),
              employeeDataSource != null
                  ? Expanded(
                      flex: 5,
                      child: Container(
                        child: SfDataGrid(
                          footerHeight: 10,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          source: employeeDataSource!,
                          columnWidthMode: ColumnWidthMode.fill,
                          columns: [
                            GridColumn(
                              width: 120,
                              columnName: 'data',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'Data',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
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
                              width: 120,
                              columnName: 'order',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'Order',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: 120,
                              columnName: 'b',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'B',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: 120,
                              columnName: 'ipe',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'IPE',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: 120,
                              columnName: 'qty',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'QTY',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: 120,
                              columnName: 'remark',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'Remark',
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
                        Expanded(
                          flex: 3,
                          child: Button(
                            onPress: (_btnLoad),
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
                            onPress: (_btnSend),
                            text: Label(
                              "Send",
                              color: COLOR_WHITE,
                            ),
                          ),
                        ),
                      ],
                    )
              // Container(
              //         child: Button(
              //           height: 40,
              //           bgColor: bgChange ?? Colors.grey,
              //           text: Label(
              //             "Load Plan",
              //             color: COLOR_WHITE,
              //           ),
              //           onPress: () => _btnSend(),
              //         ),
              //       ),
            ],
          ),
        ),
      ),
    );
  }

  _btnLoad() {}
  _btnSend() {
    if (operatorNameController.text.isNotEmpty &&
        CheckPointController.text.isNotEmpty) {
      // _callAPI();
    } else {
      EasyLoading.showInfo("กรุณาใส่ข้อมูลให้ครบ");
    }
  }
}

// void _callAPI() {
//   BlocProvider.of<PmDailyBloc>(context).add(
//     PMDailySendEvent(
//       PMDailyOutputModel(
//
//         OPERATORNAME: int.tryParse(operatorNameController.text.trim()),
//
//         STARTDATE: DateTime.now().toString(),
//       ),
//     ),
//   );
// }

// BlocProvider.of<PmDailyBloc>(context).add(
// PMDailySendEvent(
// PMDailyOutputModel(
// OPERATORNAME: int.tryParse(row.OPERATOR_NAME.toString()),
// CHECKPOINT: row.CHECKPOINT,
// STATUS: row.STATUS,
// STARTDATE: row.STARTDATE,
// ),
// ),
// );

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({List<PMDailyOutputModel>? process}) {
    if (process != null) {
      for (var _item in process) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<int>(
                  columnName: 'operatorname', value: _item.OPERATORNAME),
              DataGridCell<String>(
                  columnName: 'checkpoint', value: _item.CHECKPOINT),
              DataGridCell<String>(columnName: 'status', value: _item.STATUS),
              DataGridCell<String>(
                  columnName: 'startdate', value: _item.STARTDATE),
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
