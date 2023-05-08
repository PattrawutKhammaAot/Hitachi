import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/reportRouteSheet/reportRouteSheetModel.dart';
import 'package:hitachi/widget/box_inputfield.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ReportRouteSheetScreen extends StatefulWidget {
  const ReportRouteSheetScreen({super.key});

  @override
  State<ReportRouteSheetScreen> createState() => _ReportRouteSheetScreenState();
}

class _ReportRouteSheetScreenState extends State<ReportRouteSheetScreen> {
  List<ReportRouteSheetModelProcess>? reportRouteSheetModel;

  EmployeeDataSource? employeeDataSource;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LineElementBloc>(context).add(
      ReportRouteSheetEvenet(100136982104.toString()),
    );
  }

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
                reportRouteSheetModel = state.item.PROCESS;
                employeeDataSource =
                    EmployeeDataSource(process: reportRouteSheetModel);
              });
            }
            if (state is GetReportRuteSheetErrorState) {
              print(state.error);
            }
          },
        )
      ],
      child: BgWhite(
          textTitle: "Report Route Sheet",
          body: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  child: BoxInputField(
                    labelText: "Batch No",
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                if (employeeDataSource != null)
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: SfDataGrid(
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        source: employeeDataSource!,
                        columnWidthMode: ColumnWidthMode.fill,
                        columns: [
                          GridColumn(
                            width: 120,
                            columnName: 'id',
                            label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                    child: Label(
                                  'ID',
                                  color: COLOR_WHITE,
                                ))),
                          ),
                          GridColumn(
                              width: 120,
                              columnName: 'name',
                              label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Proc',
                                    color: COLOR_WHITE,
                                  )))),
                          GridColumn(
                              width: 120,
                              columnName: 'startDate',
                              label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'start Date',
                                    color: COLOR_WHITE,
                                  )))),
                          GridColumn(
                              width: 120,
                              columnName: 'startTime',
                              label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Start Time',
                                    color: COLOR_WHITE,
                                  )))),
                          GridColumn(
                              width: 120,
                              columnName: 'FINISH_DATE',
                              label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'End Date',
                                    color: COLOR_WHITE,
                                  )))),
                          GridColumn(
                              width: 120,
                              columnName: 'FINISH_TIME',
                              label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'End Time',
                                    color: COLOR_WHITE,
                                  )))),
                          GridColumn(
                              columnName: 'qty',
                              label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Quantity',
                                    color: COLOR_WHITE,
                                  )))),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          )),
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({List<ReportRouteSheetModelProcess>? process}) {
    if (process != null) {
      for (var _item in process!) {
        _employees.add(DataGridRow(cells: [
          DataGridCell<int>(columnName: 'id', value: _item.ORDER),
          DataGridCell<String>(columnName: 'name', value: _item.PROCESS),
          DataGridCell<String>(
              columnName: 'startDate', value: _item.START_DATE),
          DataGridCell<String>(
              columnName: 'startTime', value: _item.START_TIME),
          DataGridCell<String>(
              columnName: 'FINISH_DATE', value: _item.FINISH_DATE),
          DataGridCell<String>(
              columnName: 'FINISH_TIME', value: _item.FINISH_TIME),
          DataGridCell<int>(columnName: 'qty', value: _item.AMOUNT),
        ]));
      }
    } else {
      print("null");
    }

    // try {
    //   _employees = process!
    //       .map<DataGridRow>((items) => DataGridRow(cells: [
    //             DataGridCell<int>(columnName: 'id', value: process.ORDER),
    //             // DataGridCell<String>(columnName: 'Proc', value: items.),
    //             // DataGridCell<String>(columnName: 'qty', value: e.startDate),
    //             // DataGridCell<int>(columnName: 'startDate', value: e.salary),
    //             // DataGridCell<DateTime>(
    //             //     columnName: 'startTime', value: e.startTime),
    //             // DataGridCell<DateTime>(columnName: 'endDate', value: e.endDate),
    //             // DataGridCell<DateTime>(columnName: 'endTime', value: e.endTime),
    //           ]))
    //       .toList();
    // } catch (e) {
    //   print(e);
    // }
  }

  List<DataGridRow> _employees = [];

  @override
  List<DataGridRow> get rows => _employees;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: (dataGridCell.columnName == 'id' ||
                dataGridCell.columnName == 'qty')
            ? Alignment.center
            : Alignment.center,
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
