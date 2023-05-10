import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/windingSheetModel.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:hitachi/screens/lineElement/windingStart/DataGridSource.dart';
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
  List<Windings> employees = <Windings>[];
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
    // getshow();

    _getWindingSheet().then((result) {
      setState(() {
        windingSheetModel = result;
        employeeDataSource = WindingsDataSource(process: windingSheetModel);
      });
    });
  }

  void deleteSave(var MACHINE_NO) async {
    print(MACHINE_NO);
    try {
      await databaseHelper.deleteSave(
          tableName: 'WINDING_SHEET',
          where: 'MACHINE_NO',
          keyWhere: MACHINE_NO);
    } catch (e) {
      print(e);
    }
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

  getshow() async {
    await databaseHelper.insertDataSheet('WINDING_SHEET', {
      'MachineNo': 14,
      'OperatorName': 111,
      'BatchNo': 111,
      'Product': 111,
      'PackNo': 111,
      'PaperCore': 111,
      'PPCore': 222,
      'FoilCore': 222,
      'BatchStartDate': 222,
      'BatchEndDate': 222,
      'Element': 222,
      'Status': 222,
      'start_end': 222,
      'checkComplete ': 222,
    });
    print("---getshow---");
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
                        GridColumn(
                            columnName: 'foillot',
                            label: Center(child: Text('Foil lot'))),
                        GridColumn(
                            columnName: 'batchstartdate',
                            label: Center(child: Text('BATCH START DATE'))),
                        GridColumn(
                            columnName: 'batchenddate',
                            label: Center(child: Text('BATCH END DATE'))),
                        GridColumn(
                            columnName: 'Element',
                            label: Center(child: Text('Element'))),
                        GridColumn(
                            columnName: 'status',
                            label: Center(child: Text('STATUS'))),
                      ],
                      onCellDoubleTap: (DataGridCellDoubleTapDetails details) {
                        if (details.rowColumnIndex.rowIndex != 0) {
                          setState(() {
                            var rowindex = details.rowColumnIndex.rowIndex - 1;
                            var dataGirdRow = employeeDataSource!.effectiveRows
                                .elementAt(rowindex);
                            // whModel = dataGirdRow!
                            //     .getCells()
                            //     .map((e) => WindingSheetModel(
                            //   'MachineNo': e.value.,
                            //   'OperatorName': 111,
                            //   'BatchNo': 111,
                            //   'Product': 111,
                            //   'PackNo': 111,
                            //   'PaperCore': 111,
                            //   'PPCore': 222,
                            //   'FoilCore': 222,
                            //   'BatchStartDate': 222,
                            //   'BatchEndDate': 222,
                            //   'Element': 222,
                            //   'Status': 222,
                            //   'start_end': 222,
                            //   'checkComplete ': 222,))
                            //     .toList();
                          });
                        }
                        ;

                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            print('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
                            print(details.rowColumnIndex.rowIndex != 0);
                            print(details.rowColumnIndex);
                            print(employeeDataSource);
                            print('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
                            print(context.toString());
                            print(context.debugDoingBuild.toString());
                            print(context.select);
                            print(context.widget);
                            print('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
                            // return Container();
                            return Container(
                              height: 1000,
                              // color: Colors.amber,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              top: 15,
                                              bottom: 15),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black)),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                          "Material NO :",
                                                          style: TextStyle(
                                                              fontSize: 15))),
                                                  Expanded(
                                                    flex: 2,
                                                    child: TextFormField(
                                                      // decoration:
                                                      // InputDecoration(
                                                      //     hintText: context
                                                      //         .toString()),
                                                      controller: machineNo,
                                                      enabled: false,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                          "Operator Name :",
                                                          style: TextStyle(
                                                              fontSize: 15))),
                                                  Expanded(
                                                    flex: 2,
                                                    child: TextFormField(
                                                      controller: machineNo,
                                                      enabled: false,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Text("Batch No:",
                                                          style: TextStyle(
                                                              fontSize: 15))),
                                                  Expanded(
                                                    flex: 2,
                                                    child: TextFormField(
                                                      controller: machineNo,
                                                      enabled: false,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Text("Product:",
                                                          style: TextStyle(
                                                              fontSize: 15))),
                                                  Expanded(
                                                    flex: 2,
                                                    child: TextFormField(
                                                      controller: machineNo,
                                                      enabled: false,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                          "Film pack No:",
                                                          style: TextStyle(
                                                              fontSize: 15))),
                                                  Expanded(
                                                    flex: 2,
                                                    child: TextFormField(
                                                      controller: machineNo,
                                                      enabled: false,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Button(
                                              onPress: () {
                                                // print(machineNo.text);
                                                print(machineNo);
                                              },
                                              bgColor:
                                                  _formKey.currentState == null
                                                      ? COLOR_RED
                                                      : COLOR_RED,
                                              text: Label(
                                                "Deleted",
                                                color: COLOR_WHITE,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Button(
                                              onPress: () =>
                                                  Navigator.pop(context),
                                              bgColor:
                                                  _formKey.currentState == null
                                                      ? COLOR_BLUE_DARK
                                                      : COLOR_RED,
                                              text: Label(
                                                "OK",
                                                color: COLOR_WHITE,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Label(
                    "Scan",
                    color: Colors.grey,
                  )),
              const SizedBox(
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
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Button(
                    bgColor:
                        _formKey.currentState == null ? COLOR_RED : COLOR_RED,
                    text: Label(
                      "Deleted",
                      color: COLOR_WHITE,
                    ),
                    onPress: () => _AlertDialog(),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Button(
                    bgColor: _formKey.currentState == null
                        ? COLOR_BLUE_DARK
                        : COLOR_RED,
                    text: Label(
                      "Send",
                      color: COLOR_WHITE,
                    ),
                    //   onPress: () => _checkValueController(),
                  ),
                ),
              ),
            ],
          ),
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
      print('ssssssssssssssssssssssssssssssssssssssssss');
      print(employeeDataSource);
      print('ssssssssssssssssssssssssssssssssssssssssss');
    }
  }

  void _sendDataServer() async {
    if (password.text.isNotEmpty) {
      Navigator.pop(context, 'OK');
    }
  }
}

class Windings {
  Windings(
      this.machineno,
      this.name,
      this.batchno,
      this.product,
      this.filmpackno,
      this.papercodelot,
      this.PPfilmlot,
      this.filmlot,
      this.batchstartdate,
      this.batchenddate,
      this.element,
      this.status);
  final String machineno;
  final String name;
  final String batchno;
  final String product;
  final String filmpackno;
  final String papercodelot;
  final String PPfilmlot;
  final String filmlot;
  final String batchstartdate;
  final String batchenddate;
  final String element;
  final String status;
}

class WindingsDataSource extends DataGridSource {
  WindingsDataSource({List<WindingSheetModel>? process}) {
    if (process != null) {
      for (var _item in process) {
        _Windings.add(
          DataGridRow(
            cells: [
              DataGridCell<int>(
                  columnName: 'machineno', value: _item.MACHINE_NO),
              DataGridCell<String>(
                  columnName: 'name', value: _item.OPERATOR_NAME),
              DataGridCell<int>(columnName: 'batchno', value: _item.BATCH_NO),
              DataGridCell<int>(columnName: 'product', value: _item.PRODUCT),
              DataGridCell<int>(columnName: 'filmpackno', value: _item.PACK_NO),
              DataGridCell<String>(
                  columnName: 'papercodelot', value: _item.PAPER_CORE),
              DataGridCell<String>(
                  columnName: 'PPfilmlot', value: _item.PP_CORE),
              DataGridCell<String>(
                  columnName: 'filmlot', value: _item.FOIL_CORE),
              DataGridCell<String>(
                  columnName: 'batchstartdate', value: _item.PP_CORE),
              DataGridCell<String>(
                  columnName: 'batchenddate', value: _item.BATCH_END_DATE),
              DataGridCell<int>(columnName: 'element', value: _item.ELEMENT),
              DataGridCell<String>(columnName: 'status', value: _item.STATUS),
            ],
          ),
        );
      }
    } else {
      EasyLoading.showError("Can not Call API");
    }
  }

  ModalBottomSheet({List<WindingSheetModel>? process}) {
    if (process != null) {
    } else {
      EasyLoading.showError("Can not Call API");
    }
  }

  List<DataGridRow> _Windings = [];

  @override
  List<DataGridRow> get rows => _Windings;

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
