import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/windingSheetModel.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:hitachi/services/databaseHelper.dart';
// import 'package:hitachi/models/SendWds/HoldWdsMoel.dart';

class WindingJobStartHoldScreen extends StatefulWidget {
  const WindingJobStartHoldScreen({Key? key}) : super(key: key);

  @override
  State<WindingJobStartHoldScreen> createState() =>
      _WindingJobStartHoldScreenState();
}

class _WindingJobStartHoldScreenState extends State<WindingJobStartHoldScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController machineNo = TextEditingController();
  final TextEditingController operatorName = TextEditingController();
  final TextEditingController batchNo = TextEditingController();
  final TextEditingController product = TextEditingController();
  final TextEditingController filmPackNo = TextEditingController();
  final TextEditingController paperCodeLot = TextEditingController();
  final TextEditingController ppFilmLot = TextEditingController();
  final TextEditingController foilLot = TextEditingController();
  final TextEditingController batchstartdate = TextEditingController();
  final TextEditingController batchenddate = TextEditingController();
  final TextEditingController element = TextEditingController();
  final TextEditingController status = TextEditingController();
  final TextEditingController password = TextEditingController();
  WindingsDataSource? employeeDataSource;
  List<WindingSheetModel>? windingSheetModel;
  WindingSheetModel whModel = WindingSheetModel();
  List<Map<String, dynamic>> _windingSheetList = [];

  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  void initState() {
    super.initState();

    _getWindingSheet().then((result) {
      setState(() {
        windingSheetModel = result;
        employeeDataSource = WindingsDataSource(process: windingSheetModel);
      });
    });
  }

  Future<List<WindingSheetModel>> _getWindingSheet() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllRows('WINDING_SHEET');
      List<WindingSheetModel> result =
          rows.map((row) => WindingSheetModel.fromMap(row)).toList();
      return result;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      isHidePreviour: true,
      textTitle: "Winding job Start(Hold)",
      body: Column(
        children: [
          employeeDataSource != null
              ? Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: SfDataGrid(
                      source: employeeDataSource!,
                      // columnWidthMode: ColumnWidthMode.fill,
                      showCheckboxColumn: true,
                      selectionMode: SelectionMode.multiple,
                      columns: <GridColumn>[
                        GridColumn(
                            columnName: 'machineno',
                            label: Container(
                              child: Center(child: Text('Machine No.')),
                              // color: COLOR_BLUE_DARK,
                            )),
                        GridColumn(
                            columnName: 'name',
                            label: Center(child: Text('Operator Name')),
                            width: 100),
                        GridColumn(
                            columnName: 'batchno',
                            label: Center(child: Text('Batch No.')),
                            width: 100),
                        GridColumn(
                            columnName: 'product',
                            label: Center(child: Text('Product')),
                            width: 100),
                        GridColumn(
                            columnName: 'filmpackno',
                            label: Center(child: Text('Film pack No.'))),
                        GridColumn(
                            columnName: 'papercodelot',
                            label: Center(child: Text('Paper code lot'))),
                        GridColumn(
                            columnName: 'PPfilmlot',
                            label: Center(child: Text('PP film lot'))),
                      ],
                    ),
                  ),
                )
              : Container(
                  child: Center(
                    child: Label(
                      "NO DATA",
                      fontSize: 30,
                    ),
                  ),
                ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _AlertDialog() async {
    // EasyLoading.showError("Error[03]", duration: Duration(seconds: 5));//if password
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('AlertDialog Title'),
        content: TextFormField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Please Input Password',
          ),
          controller: password,
        ),

        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _checkValueController(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _checkValueController() async {
    if (password.text.isNotEmpty) {
      Navigator.pop(context, 'OK');
    }
  }

  void _sendDataServer() async {
    if (password.text.isNotEmpty) {
      Navigator.pop(context, 'OK');
    }
  }
}

class WindingsDataSource extends DataGridSource {
  WindingsDataSource({List<WindingSheetModel>? process}) {
    if (process != null) {
      for (var _item in process) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<int>(
                  columnName: 'machineno', value: _item.MACHINE_NO),
              DataGridCell<String>(
                  columnName: 'name', value: _item.OPERATOR_NAME),
              DataGridCell<int>(columnName: 'batchno', value: _item.BATCH_NO),
              DataGridCell<int>(columnName: 'product', value: _item.PRODUCT),
              DataGridCell<String>(
                  columnName: 'filmpackno', value: _item.FOIL_CORE),
              DataGridCell<String>(
                  columnName: 'papercodelot', value: _item.PAPER_CORE),
              DataGridCell<String>(
                  columnName: 'PPfilmlot', value: _item.PP_CORE),
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
