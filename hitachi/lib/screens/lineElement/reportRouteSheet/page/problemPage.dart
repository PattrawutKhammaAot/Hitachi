import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/reportRouteSheet/reportRouteSheetModel.dart';
import 'package:hitachi/screens/lineElement/reportRouteSheet/page/processPage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../widget/alertSnackBar.dart';

class ProblemPage extends StatefulWidget {
  const ProblemPage({super.key, this.valueString});
  // final String? controller;
  // final ValueChanged<String>? onChange;
  final String? valueString;

  @override
  State<ProblemPage> createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  List<ReportRouteSheetModelProblem>? reportRouteSheetModel;
  EmployeeDataSource? employeeDataSource;

  @override
  void initState() {
    if (widget.valueString!.isNotEmpty) {
      BlocProvider.of<LineElementBloc>(context).add(
        ReportRouteSheetEvenet(widget.valueString.toString()),
      );
    } else {
      EasyLoading.showError("Please Input Batch No In Process");
    }
  }

  Map<String, double> columnWidths = {
    'Process': double.nan,
    'des': double.nan,
  };

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LineElementBloc, LineElementState>(
          listener: (context, state) {
            if (state is GetReportRuteSheetLoadingState) {
              EasyLoading.show();
            }
            if (state is GetReportRuteSheetLoadedState) {
              EasyLoading.dismiss();
              setState(() {
                reportRouteSheetModel = state.item.PROBLEM;
                employeeDataSource =
                    EmployeeDataSource(process: reportRouteSheetModel);
              });
            }
            if (state is GetReportRuteSheetErrorState) {
              EasyLoading.dismiss();
              AlertSnackBar.show(
                  title: 'Connection Failed',
                  message: 'Check your internet connection and try again ',
                  type: AlertType.error,
                  duration: const Duration(seconds: 10));
              print(state.error);
            }
          },
        )
      ],
      child: BgWhite(
        isHideAppBar: true,
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              employeeDataSource != null
                  ? Expanded(
                      flex: 5,
                      child: Container(
                        child: SfDataGrid(
                          footerHeight: 10,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          source: employeeDataSource!,
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
                          columns: [
                            GridColumn(
                              width: columnWidths['Process']!,
                              columnName: 'Process',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'Process',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['des']!,
                              columnName: 'des',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'Description',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({List<ReportRouteSheetModelProblem>? process}) {
    if (process != null) {
      for (var _item in process) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'Process', value: _item.PROCESS),
              DataGridCell<String>(columnName: 'des', value: _item.DESCRIPTION),
            ],
          ),
        );
      }
    } else {
      AlertSnackBar.show(
          title: 'Connection Failed',
          message: 'Check your internet connection and try again ',
          type: AlertType.error,
          duration: const Duration(seconds: 10));
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
