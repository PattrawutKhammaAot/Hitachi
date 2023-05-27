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
import 'package:hitachi/models/pmdailyModel/PMDailyCheckpointOutputModel.dart';
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
  List<PMDailyOutputModelPlan>? PlanWindingModel;
  //PMDailyOutputModelPlan
  PlanWindingDataSource? planwindingDataSource;
  Color? bgChange;

  final TextEditingController checkpointController = TextEditingController();
  final TextEditingController operatorNameController = TextEditingController();

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
        // BlocListener<PlanWindingBloc, PlanWindingState>(
        BlocListener<PmDailyBloc, PmDailyState>(
          listener: (context, state) {
            if (state is PMDailyGetLoadingState) {
              EasyLoading.show();
            }
            if (state is PMDailyGetLoadedState) {
              EasyLoading.dismiss();
              setState(() {
                PlanWindingModel = state.item.CHECKPOINT;
                planwindingDataSource =
                    PlanWindingDataSource(CHECKPOINT: PlanWindingModel);
              });
            }
            if (state is PMDailyGetErrorState) {
              EasyLoading.dismiss();
              EasyLoading.showError("Can not Call Api");
              // print(state.error);
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
              RowBoxInputField(
                labelText: "Operator Name : ",
                height: 35,
                controller: operatorNameController,
                maxLength: 12,
                focusNode: f1,
                // enabled: _enabledPMDaily,
                onEditingComplete: () {
                  if (operatorNameController.text.isNotEmpty) {
                    setState(() {
                      f2.requestFocus();
                    });
                  } else {}
                },
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              RowBoxInputField(
                labelText: "Check Point : ",
                height: 35,
                maxLength: 1,
                controller: checkpointController,
                focusNode: f2,
                // enabled: _enabledPMDaily,

                onChanged: (value) {
                  if (operatorNameController.text.isNotEmpty &&
                      checkpointController.text.isNotEmpty) {
                    setState(() {
                      bgChange = COLOR_RED;
                    });
                  } else {
                    setState(() {
                      bgChange = Colors.grey;
                    });
                  }
                },
                // onEditingComplete: () => f4.requestFocus(),
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[1-3]')),
                ],
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
                            " ",
                            color: COLOR_RED,
                          )),
                        ),
                      ],
                    ),
              Container(
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
              // Container(
              //         child: Button(
              //           height: 40,
              //           // bgColor: bgChange ?? Colors.grey,
              //           text: Label(
              //             "Load Plan",
              //             color: COLOR_WHITE,
              //           ),
              //           onPress: () => _loadPlan(),
              //         ),
              //       ),
            ],
          ),
        ),
      ),
    );
  }

  _loadPlan() {
    // BlocProvider.of<PlanWindingBloc>(context).add(
    //   PlanWindingSendEvent(batchNoController.text.trim()),
    // );
    BlocProvider.of<PmDailyBloc>(context).add(
      PMDailyGetSendEvent(checkpointController.text),
    );
    // widget.onChange!(batchNoController.text.trim());
  }
}

class PlanWindingDataSource extends DataGridSource {
  PlanWindingDataSource({List<PMDailyOutputModelPlan>? CHECKPOINT}) {
    if (CHECKPOINT != null) {
      for (var _item in CHECKPOINT) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'data', value: _item.STATUS),
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
