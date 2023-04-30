import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class WindingJobStartHoldScreen extends StatefulWidget {
  const WindingJobStartHoldScreen({Key? key}) : super(key: key);

  @override
  State<WindingJobStartHoldScreen> createState() =>
      _WindingJobStartHoldScreenState();
}

class _WindingJobStartHoldScreenState extends State<WindingJobStartHoldScreen> {
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
      Employee(10001, 'James', 'Project Lead', 20000),
      Employee(10002, 'Kathryn', 'Manager', 30000),
      Employee(10003, 'Lara', 'Developer', 15000),
      Employee(10004, 'Michael', 'Designer', 15000),
      Employee(10005, 'Martin', 'Developer', 15000),
      Employee(10006, 'Newberry', 'Developer', 15000),
      Employee(10007, 'Balnc', 'Developer', 15000),
      Employee(10008, 'Perry', 'Developer', 15000),
      Employee(10009, 'Gable', 'Developer', 15000),
      Employee(10010, 'Grimes', 'Developer', 15000)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      isHidePreviour: true,
      textTitle: "Winding job Start(Hold)",
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: SfDataGrid(
                source: employeeDataSource!,
                columnWidthMode: ColumnWidthMode.fill,
                columns: <GridColumn>[
                  GridColumn(columnName: 'id', label: Text('ID')),
                  GridColumn(columnName: 'name', label: Text('Name')),
                  GridColumn(
                      columnName: 'designation', label: Text('Designation')),
                  GridColumn(columnName: 'salary', label: Text('Salary')),
                ],
              ),
            ),
          ),
          Expanded(
              child: Container(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Label(
                        "Scan",
                        color: Colors.grey,
                      )),
                  SizedBox(
                    height: 15,
                    child: VerticalDivider(
                      color: COLOR_BLACK,
                      thickness: 2,
                    ),
                  ),
                  Label(
                    "Hold",
                    color: COLOR_BLACK,
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}

class Employee {
  Employee(this.id, this.name, this.designation, this.salary);
  final int id;
  final String name;
  final String designation;
  final int salary;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({List<Employee>? employees}) {
    _employees = employees!
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(
                  columnName: 'designation', value: e.designation),
              DataGridCell<int>(columnName: 'salary', value: e.salary),
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
                dataGridCell.columnName == 'salary')
            ? Alignment.centerRight
            : Alignment.centerLeft,
        padding: EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
