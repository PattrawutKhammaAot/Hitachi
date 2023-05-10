import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/reportRouteSheet/reportRouteSheetModel.dart';
import 'package:hitachi/screens/lineElement/reportRouteSheet/page/problemPage.dart';
import 'package:hitachi/screens/lineElement/reportRouteSheet/page/processPage.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ReportRouteSheetScreen extends StatefulWidget {
  const ReportRouteSheetScreen({super.key});

  @override
  State<ReportRouteSheetScreen> createState() => _ReportRouteSheetScreenState();
}

class _ReportRouteSheetScreenState extends State<ReportRouteSheetScreen> {
  String sendValueController = '';
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = [
      ProcessPage(
        onChange: (value) {
          setState(() {
            sendValueController = value;
          });
          print(sendValueController);
        },
      ),
      ProblemPage(
        valueString: sendValueController,
      ),
    ];

    return BgWhite(
      isHidePreviour: true,
      textTitle: "ReportRouteSheet",
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Process',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync_problem),
            label: 'Problem',
            backgroundColor: Colors.green,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: COLOR_BLUE_DARK,
        onTap: _onItemTapped,
      ),
    );

    //   MultiBlocListener(
    //     listeners: [
    //       BlocListener<LineElementBloc, LineElementState>(
    //         listener: (context, state) {
    //           if (state is GetReportRuteSheetLoadingState) {
    //             EasyLoading.show();
    //           }
    //           if (state is GetReportRuteSheetLoadedState) {
    //             EasyLoading.dismiss();
    //             setState(() {
    //               reportRouteSheetModel = state.item.PROCESS;
    //               employeeDataSource =
    //                   EmployeeDataSource(process: reportRouteSheetModel);
    //             });
    //           }
    //           if (state is GetReportRuteSheetErrorState) {
    //             EasyLoading.dismiss();
    //             EasyLoading.showError("Can not Call Api");
    //             print(state.error);
    //           }
    //         },
    //       )
    //     ],
    //     child: BgWhite(
    //       bottomNavigationBar: BottomNavigationBar(
    //         items: [
    //           BottomNavigationBarItem(
    //             icon: Icon(Icons.home),
    //             label: 'Home',
    //             backgroundColor: Colors.red,
    //           ),
    //           BottomNavigationBarItem(
    //             icon: Icon(Icons.home),
    //             label: 'PAGE',
    //             backgroundColor: Colors.red,
    //           ),
    //         ],
    //         currentIndex: _selectedIndex,
    //         selectedItemColor: Colors.amber[800],
    //         onTap: _onItemTapped,
    //       ),
    //       textTitle: "Report Route Sheet",
    //       body: Container(
    //         padding: EdgeInsets.all(15),
    //         child: Column(
    //           children: [
    //             Container(
    //               child: BoxInputField(
    //                 labelText: "Batch No",
    //                 type: TextInputType.number,
    //                 maxLength: 12,
    //                 controller: _batchNoController,
    //                 onChanged: (value) {
    //                   if (value.length >= 12) {
    //                     BlocProvider.of<LineElementBloc>(context).add(
    //                       ReportRouteSheetEvenet(_batchNoController.text.trim()),
    //                     );
    //                   }
    //                 },
    //               ),
    //             ),
    //             SizedBox(
    //               height: 5,
    //             ),
    //             employeeDataSource != null
    //                 ? Expanded(
    //                     flex: 5,
    //                     child: Container(
    //                       child: SfDataGrid(
    //                         footerHeight: 10,
    //                         gridLinesVisibility: GridLinesVisibility.both,
    //                         headerGridLinesVisibility: GridLinesVisibility.both,
    //                         source: employeeDataSource!,
    //                         columnWidthMode: ColumnWidthMode.fill,
    //                         columns: [
    //                           GridColumn(
    //                             width: 120,
    //                             columnName: 'id',
    //                             label: Container(
    //                               color: COLOR_BLUE_DARK,
    //                               child: Center(
    //                                 child: Label(
    //                                   'ID',
    //                                   color: COLOR_WHITE,
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                           GridColumn(
    //                             columnName: 'qty',
    //                             label: Container(
    //                               color: COLOR_BLUE_DARK,
    //                               child: Center(
    //                                 child: Label(
    //                                   'Qty',
    //                                   color: COLOR_WHITE,
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                           GridColumn(
    //                             width: 120,
    //                             columnName: 'name',
    //                             label: Container(
    //                               color: COLOR_BLUE_DARK,
    //                               child: Center(
    //                                 child: Label(
    //                                   'Proc',
    //                                   color: COLOR_WHITE,
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                           GridColumn(
    //                             width: 120,
    //                             columnName: 'startDate',
    //                             label: Container(
    //                               color: COLOR_BLUE_DARK,
    //                               child: Center(
    //                                 child: Label(
    //                                   'start Date',
    //                                   color: COLOR_WHITE,
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                           GridColumn(
    //                             width: 120,
    //                             columnName: 'startTime',
    //                             label: Container(
    //                               color: COLOR_BLUE_DARK,
    //                               child: Center(
    //                                 child: Label(
    //                                   'Start Time',
    //                                   color: COLOR_WHITE,
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                           GridColumn(
    //                             width: 120,
    //                             columnName: 'FINISH_DATE',
    //                             label: Container(
    //                               color: COLOR_BLUE_DARK,
    //                               child: Center(
    //                                 child: Label(
    //                                   'End Date',
    //                                   color: COLOR_WHITE,
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                           GridColumn(
    //                             width: 120,
    //                             columnName: 'FINISH_TIME',
    //                             label: Container(
    //                               color: COLOR_BLUE_DARK,
    //                               child: Center(
    //                                 child: Label(
    //                                   'End Time',
    //                                   color: COLOR_WHITE,
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   )
    //                 : Container(
    //                     child: Label(" กรุณากรอกข้อมูล"),
    //                   ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    // }
  }
}
