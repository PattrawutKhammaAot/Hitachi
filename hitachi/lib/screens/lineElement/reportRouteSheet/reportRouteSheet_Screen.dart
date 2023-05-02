import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/widget/box_inputfield.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ReportRouteSheetScreen extends StatefulWidget {
  const ReportRouteSheetScreen({super.key});

  @override
  State<ReportRouteSheetScreen> createState() => _ReportRouteSheetScreenState();
}

class _ReportRouteSheetScreenState extends State<ReportRouteSheetScreen> {
  List<Employee> employees = <Employee>[];

  EmployeeDataSource? employeeDataSource;

  @override
  void initState() {
    super.initState();
    employees = getEmployees();
    employeeDataSource = EmployeeDataSource(employees: employees);
  }

  List<Employee> getEmployees() {
    return [
      Employee(10001, 'James', 'Project Lead', 20000, DateTime.now(),
          DateTime.now(), DateTime.now()),
      Employee(10002, 'Kathryn', 'Manager', 30000, DateTime.now(),
          DateTime.now(), DateTime.now()),
      Employee(10003, 'Lara', 'Developer', 15000, DateTime.now(),
          DateTime.now(), DateTime.now()),
      Employee(10004, 'Michael', 'Designer', 15000, DateTime.now(),
          DateTime.now(), DateTime.now()),
      Employee(10005, 'Martin', 'Developer', 15000, DateTime.now(),
          DateTime.now(), DateTime.now()),
      Employee(10006, 'Newberry', 'Developer', 15000, DateTime.now(),
          DateTime.now(), DateTime.now()),
      Employee(10007, 'Balnc', 'Developer', 15000, DateTime.now(),
          DateTime.now(), DateTime.now()),
      Employee(10008, 'Perry', 'Developer', 15000, DateTime.now(),
          DateTime.now(), DateTime.now()),
      Employee(10009, 'Gable', 'Developer', 15000, DateTime.now(),
          DateTime.now(), DateTime.now()),
      Employee(10010, 'Grimes', 'Developer', 15000, DateTime.now(),
          DateTime.now(), DateTime.now())
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BgWhite(
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
                          columnName: 'qty',
                          label: Container(
                              color: COLOR_BLUE_DARK,
                              child: Center(
                                  child: Label(
                                'Quantity',
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
                          columnName: 'endDate',
                          label: Container(
                              color: COLOR_BLUE_DARK,
                              child: Center(
                                  child: Label(
                                'End Date',
                                color: COLOR_WHITE,
                              )))),
                      GridColumn(
                          width: 120,
                          columnName: 'endTime',
                          label: Container(
                              color: COLOR_BLUE_DARK,
                              child: Center(
                                  child: Label(
                                'End Time',
                                color: COLOR_WHITE,
                              )))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class Employee {
  Employee(this.id, this.name, this.designation, this.salary, this.endDate,
      this.endTime, this.startTime);
  final int id;
  final String name;
  final String designation;
  final int salary;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime endDate;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({List<Employee>? employees}) {
    _employees = employees!
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'Proc', value: e.name),
              DataGridCell<String>(columnName: 'qty', value: e.designation),
              DataGridCell<int>(columnName: 'startDate', value: e.salary),
              DataGridCell<DateTime>(
                  columnName: 'startTime', value: e.startTime),
              DataGridCell<DateTime>(columnName: 'endDate', value: e.endDate),
              DataGridCell<DateTime>(columnName: 'endTime', value: e.endTime),
            ]))
        .toList();
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
