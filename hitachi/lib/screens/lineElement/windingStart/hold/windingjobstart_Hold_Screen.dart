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
    // employees = getWindings();
    // employeeDataSource = WindingsDataSource(employees: employees);
    // machineNo.text = "machineNo";
    // getshow();
    // _getWindingSheet();
    // print(_windingSheetList);
    // windingSheetModel = _getWindingSheet();
  }

  // Future<List<WindingSheetModel>> _getWindingSheet() async {
  //   try {
  //     Windings item;
  //     List<Map<String, dynamic>> rows =
  //     await databaseHelper.queryAllRows('WINDING_SHEET');
  //     _windingSheetList = rows;
  //     List<WindingSheetModel> result = whModel.convertToList(rows);
  //     setState(() {
  //       print("+++++++++++++++++++++++++++++++++++++++++");
  //       // print(result[1].MACHINE_NO);
  //       result.forEach((results) {
  //         // item.machineno = results.MACHINE_NO;
  //         print(results.MACHINE_NO);
  //         print(results.PACK_NO);
  //         print("--------------------------------------------");
  //       });
  //     });
  //     return result;
  //   } catch (e) {
  //     print(e);
  //     rethrow;
  //   }
  // }

  List<Windings> getWindings() {
    return [
      Windings('P1', 'James', 'Project Lead', 'James', 'James', 'James',
          'Manager', 'James', 'James', 'James', 'James', 'James'),
      Windings('P2', 'James', 'Project Lead', 'James', 'James', 'James',
          'Manager', 'James', 'James', 'James', 'James', 'James'),
    ];
  }

  getshow() async {
    await databaseHelper.insertDataSheet('WINDING_SHEET', {
      'MachineNo': 13,
      'OperatorName': 222,
      'BatchNo': 222,
      'Product': 222,
      'PackNo': 222,
      'PaperCore': 222,
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
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
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
                      columnName: 'BatchEndDate',
                      label: Center(child: Text('BATCH END DATE'))),
                  GridColumn(
                      columnName: 'Element',
                      label: Center(child: Text('Element'))),
                  GridColumn(
                      columnName: 'status',
                      label: Center(child: Text('STATUS'))),
                ],
                onCellDoubleTap: (DataGridCellDoubleTapDetails details) {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container();
                      // return Container(
                      //   height: 1000,
                      //   // color: Colors.amber,
                      //   child: Center(
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: <Widget>[
                      //         Padding(
                      //           padding: const EdgeInsets.all(10),
                      //           child: Expanded(
                      //             flex: 1,
                      //             child: Container(
                      //               padding: const EdgeInsets.only(
                      //                   left: 15,
                      //                   right: 15,
                      //                   top: 15,
                      //                   bottom: 15),
                      //               decoration: BoxDecoration(
                      //                   border:
                      //                       Border.all(color: Colors.black)),
                      //               child: Column(
                      //                 children: [
                      //                   Row(
                      //                     children: [
                      //                       Expanded(
                      //                           child: Text("Material Type :",
                      //                               style: TextStyle(
                      //                                   fontSize: 15))),
                      //                       Expanded(
                      //                         flex: 2,
                      //                         child: TextFormField(
                      //                           controller: machineNo,
                      //                           enabled: false,
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                   Row(
                      //                     children: [
                      //                       Expanded(
                      //                           child: Text("Operator Name :",
                      //                               style: TextStyle(
                      //                                   fontSize: 15))),
                      //                       Expanded(
                      //                         flex: 2,
                      //                         child: TextFormField(
                      //                           controller: machineNo,
                      //                           enabled: false,
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                   Row(
                      //                     children: [
                      //                       Expanded(
                      //                           child: Text("Batch No:",
                      //                               style: TextStyle(
                      //                                   fontSize: 15))),
                      //                       Expanded(
                      //                         flex: 2,
                      //                         child: TextFormField(
                      //                           controller: machineNo,
                      //                           enabled: false,
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                   Row(
                      //                     children: [
                      //                       Expanded(
                      //                           child: Text("Product:",
                      //                               style: TextStyle(
                      //                                   fontSize: 15))),
                      //                       Expanded(
                      //                         flex: 2,
                      //                         child: TextFormField(
                      //                           controller: machineNo,
                      //                           enabled: false,
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                   Row(
                      //                     children: [
                      //                       Expanded(
                      //                           child: Text("Film pack No:",
                      //                               style: TextStyle(
                      //                                   fontSize: 15))),
                      //                       Expanded(
                      //                         flex: 2,
                      //                         child: TextFormField(
                      //                           controller: machineNo,
                      //                           enabled: false,
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         Row(
                      //           children: [
                      //             Expanded(
                      //               child: Padding(
                      //                 padding: const EdgeInsets.all(8.0),
                      //                 child: Button(
                      //                   onPress: () => Navigator.pop(context),
                      //                   bgColor: _formKey.currentState == null
                      //                       ? COLOR_RED
                      //                       : COLOR_RED,
                      //                   text: Label(
                      //                     "Deleted",
                      //                     color: COLOR_WHITE,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //             Expanded(
                      //               child: Padding(
                      //                 padding: const EdgeInsets.all(8.0),
                      //                 child: Button(
                      //                   onPress: () => Navigator.pop(context),
                      //                   bgColor: _formKey.currentState == null
                      //                       ? COLOR_BLUE_DARK
                      //                       : COLOR_RED,
                      //                   text: Label(
                      //                     "OK",
                      //                     color: COLOR_WHITE,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // );
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Padding(
          //   padding: const EdgeInsets.all(10),
          //   child: Expanded(
          //     flex: 1,
          //     child: Container(
          //       padding: const EdgeInsets.only(
          //           left: 15, right: 15, top: 15, bottom: 15),
          //       decoration:
          //           BoxDecoration(border: Border.all(color: Colors.black)),
          //       child: Column(
          //         children: [
          //           Row(
          //             children: [
          //               Expanded(
          //                   child: Text("Material Type :",
          //                       style: TextStyle(fontSize: 15))),
          //               Expanded(
          //                 flex: 2,
          //                 child: TextFormField(
          //                   controller: machineNo,
          //                   enabled: false,
          //                 ),
          //               ),
          //             ],
          //           ),
          //           Row(
          //             children: [
          //               Expanded(
          //                   child: Text("Operator Name :",
          //                       style: TextStyle(fontSize: 15))),
          //               Expanded(
          //                 flex: 2,
          //                 child: TextFormField(
          //                   controller: machineNo,
          //                   enabled: false,
          //                 ),
          //               ),
          //             ],
          //           ),
          //           Row(
          //             children: [
          //               Expanded(
          //                   child: Text("Batch No:",
          //                       style: TextStyle(fontSize: 15))),
          //               Expanded(
          //                 flex: 2,
          //                 child: TextFormField(
          //                   controller: machineNo,
          //                   enabled: false,
          //                 ),
          //               ),
          //             ],
          //           ),
          //           Row(
          //             children: [
          //               Expanded(
          //                   child: Text("Product:",
          //                       style: TextStyle(fontSize: 15))),
          //               Expanded(
          //                 flex: 2,
          //                 child: TextFormField(
          //                   controller: machineNo,
          //                   enabled: false,
          //                 ),
          //               ),
          //             ],
          //           ),
          //           Row(
          //             children: [
          //               Expanded(
          //                   child: Text("Film pack No:",
          //                       style: TextStyle(fontSize: 15))),
          //               Expanded(
          //                 flex: 2,
          //                 child: TextFormField(
          //                   controller: machineNo,
          //                   enabled: false,
          //                 ),
          //               ),
          //             ],
          //           ),
          //           // Row(
          //           //   children: [
          //           //     Expanded(
          //           //         child: Text("Paper code lot:",
          //           //             style: TextStyle(fontSize: 15))),
          //           //     Expanded(
          //           //       flex: 2,
          //           //       child: TextFormField(
          //           //         controller: machineNo,
          //           //         enabled: false,
          //           //       ),
          //           //     ),
          //           //   ],
          //           // ),
          //           // Row(
          //           //   children: [
          //           //     Expanded(
          //           //         child: Text("PP film lot:",
          //           //             style: TextStyle(fontSize: 15))),
          //           //     Expanded(
          //           //       flex: 2,
          //           //       child: TextFormField(
          //           //         controller: machineNo,
          //           //         enabled: false,
          //           //       ),
          //           //     ),
          //           //   ],
          //           // ),
          //           // Row(
          //           //   children: [
          //           //     Expanded(
          //           //         child: Text("Foil lot:",
          //           //             style: TextStyle(fontSize: 15))),
          //           //     Expanded(
          //           //       flex: 2,
          //           //       child: TextFormField(
          //           //         controller: machineNo,
          //           //         enabled: false,
          //           //       ),
          //           //     ),
          //           //   ],
          //           // ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     GestureDetector(
          //         onTap: () => Navigator.pop(context),
          //         child: Label(
          //           "Scan",
          //           color: Colors.grey,
          //         )),
          //     const SizedBox(
          //       height: 15,
          //       child: VerticalDivider(
          //         color: COLOR_BLACK,
          //         thickness: 2,
          //       ),
          //     ),
          //     Label(
          //       "Hold",
          //       color: COLOR_BLACK,
          //     ),
          //   ],
          // ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Button(
          //           bgColor:
          //               _formKey.currentState == null ? COLOR_RED : COLOR_RED,
          //           text: Label(
          //             "Deleted",
          //             color: COLOR_WHITE,
          //           ),
          //           onPress: () => _AlertDialog(),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Button(
          //           bgColor: _formKey.currentState == null
          //               ? COLOR_BLUE_DARK
          //               : COLOR_RED,
          //           text: Label(
          //             "Send",
          //             color: COLOR_WHITE,
          //           ),
          //           //   onPress: () => _checkValueController(),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
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

// Future<List<Employee>> _SelectWindingStartWithWeight({
//   int? machineNo,
//   String? OperatorName,
//   int? batchNo,
//   int? product,
//   int? filmPackNo,
//   String? paperCodeLot,
//   String? ppFilmLot,
//   String? foilLot,
//   String? batchstartdate,
//   String? batchenddate,
//   int? element,
//   String? status,
//   num? weight,
// }) async {
//   try {
//     var sql = await databaseHelper.queryDataSelectwindingjobstart(
//         MachineNo: machineNo,
//         OperatorName: OperatorName,
//         BatchNo: batchNo,
//         Product: product,
//         PackNo: filmPackNo,
//         PaperCore: paperCodeLot,
//         PPCore: ppFilmLot,
//         FoilCore: foilLot,
//       BatchStartDate: batchstartdate,
//       BatchEndDate: batchenddate,
//       Element: element,
//       Status: status,
//       formTable: 'WINDING_SHEET',
//
//
//     );
//
//
//     //Weight
//
//     return  <List<Employee>>;
//   } catch (e) {
//     EasyLoading.showError("error[04]", duration: Duration(seconds: 5));
//    // return false;
//   }
// }
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
  WindingsDataSource({List<Windings>? employees}) {
    _employees = employees!
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'machineno', value: e.machineno),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(columnName: 'batchno', value: e.batchno),
              DataGridCell<String>(columnName: 'product', value: e.product),
              DataGridCell<String>(
                  columnName: 'filmpackno', value: e.filmpackno),
              DataGridCell<String>(
                  columnName: 'papercodelot', value: e.papercodelot),
              DataGridCell<String>(columnName: 'PPfilmlot', value: e.PPfilmlot),
              DataGridCell<String>(columnName: 'filmlot', value: e.filmlot),
              DataGridCell<String>(
                  columnName: 'batchstartdate', value: e.batchstartdate),
              DataGridCell<String>(
                  columnName: 'batchenddate', value: e.batchenddate),
              DataGridCell<String>(columnName: 'element', value: e.element),
              DataGridCell<String>(columnName: 'status', value: e.status),
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
            ? Alignment.center
            : Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}

// class WindingsDataSource extends DataGridSource {
//   WindingsDataSource({List<WindingSheetModel>? process}) {
//     if (process != null) {
//       for (var _item in process) {
//         _employees.add(
//           DataGridRow(
//             cells: [
//               DataGridCell<int>(
//                   columnName: 'machineno', value: _item.MACHINE_NO),
//               DataGridCell<String>(
//                   columnName: 'name', value: _item.OPERATOR_NAME),
//               DataGridCell<int>(columnName: 'batchno', value: _item.BATCH_NO),
//               DataGridCell<int>(columnName: 'product', value: _item.PRODUCT),
//               DataGridCell<String>(
//                   columnName: 'filmpackno', value: _item.FOIL_CORE),
//               DataGridCell<String>(
//                   columnName: 'papercodelot', value: _item.PAPER_CORE),
//               DataGridCell<String>(
//                   columnName: 'PPfilmlot', value: _item.PP_CORE),
//             ],
//           ),
//         );
//       }
//     } else {
//       EasyLoading.showError("Can not Call API");
//     }
//   }
//
//   List<DataGridRow> _employees = [];
//
//   @override
//   List<DataGridRow> get rows => _employees;
//
//   @override
//   DataGridRowAdapter? buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//       cells: row.getCells().map<Widget>(
//         (dataGridCell) {
//           return Container(
//             alignment: (dataGridCell.columnName == 'id' ||
//                     dataGridCell.columnName == 'qty')
//                 ? Alignment.center
//                 : Alignment.center,
//             child: Text(dataGridCell.value.toString()),
//           );
//         },
//       ).toList(),
//     );
//   }
// }
