import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/blocs/planwinding/planwinding_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/planWinding/PlanWindingOutputModel.dart';
import 'package:hitachi/models/reportRouteSheet/reportRouteSheetModel.dart';
import 'package:hitachi/screens/lineElement/reportRouteSheet/page/problemPage.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PlanWinding_Screen extends StatefulWidget {
  const PlanWinding_Screen({super.key, this.onChange});
  final ValueChanged<String>? onChange;

  @override
  State<PlanWinding_Screen> createState() => _PlanWinding_ScreenState();
}

class _PlanWinding_ScreenState extends State<PlanWinding_Screen> {
  final TextEditingController batchNoController = TextEditingController();
  List<PlanWindingOutputModelProcess>? PlanWindingModel;
  PlanWindingDataSource? planwindingDataSource;
  Color? bgChange;
  String _loadData = "วันเวลาที่ load : ";

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
        // BlocListener<PlanWindingBloc, PlanWindingState>(
        BlocListener<PlanWindingBloc, PlanWindingState>(
          listener: (context, state) {
            if (state is PlanWindingLoadingState) {
              EasyLoading.show();
            }
            if (state is PlanWindingLoadedState) {
              EasyLoading.dismiss();
              setState(() {
                planwindingDataSource =
                    PlanWindingDataSource(process: PlanWindingModel);
              });
            }
            if (state is PlanWindingErrorState) {
              EasyLoading.dismiss();
              EasyLoading.showError("Can not Call Api");
              // print(state.error);
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
              Container(
                child: Label(_loadData),
              ),
              SizedBox(
                height: 5,
              ),
              planwindingDataSource != null
                  ? Expanded(
                      flex: 5,
                      child: Container(
                        child: SfDataGrid(
                          footerHeight: 10,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          source: planwindingDataSource!,
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
                  : Container(
                      child: Button(
                        height: 40,
                        // bgColor: bgChange ?? Colors.grey,
                        text: Label(
                          "Load Plan",
                          color: COLOR_WHITE,
                        ),
                        onPress: () => _loadPlan(),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _loadPlan() {
    _loadData = "วันเวลาที่ load : " + DateTime.now().toString();
    // BlocProvider.of<PlanWindingBloc>(context).add(
    //   PlanWindingSendEvent(batchNoController.text.trim()),
    // );
    BlocProvider.of<PlanWindingBloc>(context).add(
      PlanWindingSendEvent(batchNoController.text.trim()),
    );
    widget.onChange!(batchNoController.text.trim());
  }
}

class PlanWindingDataSource extends DataGridSource {
  PlanWindingDataSource({List<PlanWindingOutputModelProcess>? process}) {
    if (process != null) {
      for (var _item in process) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<int>(columnName: 'data', value: _item.ORDER),
              DataGridCell<String>(columnName: 'no', value: _item.PROCESS),
              DataGridCell<String>(
                  columnName: 'order', value: _item.START_DATE),
              DataGridCell<String>(columnName: 'b', value: _item.START_TIME),
              DataGridCell<String>(columnName: 'ipe', value: _item.FINISH_DATE),
              DataGridCell<String>(columnName: 'qty', value: _item.FINISH_TIME),
              DataGridCell<int>(columnName: 'remark', value: _item.AMOUNT),
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
