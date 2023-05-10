import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/materialInput/materialInputModel.dart';
import 'package:hitachi/models/materialInput/materialOutputModel.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:sqflite/sqlite_api.dart';

class MaterialInputScreen extends StatefulWidget {
  const MaterialInputScreen({super.key});

  @override
  State<MaterialInputScreen> createState() => _MaterialInputScreenState();
}

class _MaterialInputScreenState extends State<MaterialInputScreen> {
  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _operatorNameController = TextEditingController();
  final TextEditingController _batchOrSerialController =
      TextEditingController();
  final TextEditingController _machineOrProcessController =
      TextEditingController();
  final TextEditingController _lotNoController = TextEditingController();

  final DateTime _dateTime = DateTime.now();
  MaterialInputModel? _inputMtModel;
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    // _insertSqlite();
    // TODO: implement initState
    super.initState();
  }

  void checkValueController() {
    if (_machineOrProcessController.text.isNotEmpty &&
        _operatorNameController.text.isNotEmpty &&
        _batchOrSerialController.text.isNotEmpty &&
        _machineOrProcessController.text.isNotEmpty &&
        _lotNoController.text.isNotEmpty) {
      _callApi();
    } else {
      EasyLoading.showInfo("กรุณาใส่ข้อมูลให้ครบ");
    }
  }

  void _callApi() async {
    BlocProvider.of<LineElementBloc>(context).add(
      MaterialInputEvent(
        MaterialOutputModel(
          MATERIAL: _materialController.text.trim(),
          MACHINENO: _machineOrProcessController.text.trim(),
          OPERATORNAME: int.tryParse(_operatorNameController.text.trim()),
          BATCHNO: int.tryParse(_batchOrSerialController.text.trim()),
          LOT: _lotNoController.text.trim(),
          STARTDATE: _dateTime.toString(),
        ),
      ),
    );
  }

  void _insertSqlite() async {
    await databaseHelper.insertSqlite('MATERIAL_TRACE_SHEET', {
      'Material': _machineOrProcessController.text.trim(),
      'OperatorName': _operatorNameController.text.trim(),
      'BatchNo': _batchOrSerialController.text.trim(),
      'LotNo1': _lotNoController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      textTitle: "MaterialInput",
      body: MultiBlocListener(
        listeners: [
          BlocListener<LineElementBloc, LineElementState>(
            listener: (context, state) {
              if (state is MaterialInputLoadingState) {
                EasyLoading.show();
              } else if (state is MaterialInputLoadedState) {
                EasyLoading.dismiss();
                setState(() {
                  _inputMtModel = state.item;
                });
              } else {
                EasyLoading.dismiss();
                _insertSqlite();
                EasyLoading.showError("Please Check Connection Internet");
              }
            },
          )
        ],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                BoxInputField(
                  labelText: "Material:",
                  controller: _materialController,
                ),
                const SizedBox(
                  height: 5,
                ),
                BoxInputField(
                  labelText: "Operator Name",
                  controller: _operatorNameController,
                ),
                const SizedBox(
                  height: 5,
                ),
                BoxInputField(
                  labelText: "Batch/Serial",
                  controller: _batchOrSerialController,
                  maxLength: 12,
                ),
                const SizedBox(
                  height: 5,
                ),
                BoxInputField(
                  labelText: 'Machine/Process',
                  controller: _machineOrProcessController,
                  maxLength: 3,
                ),
                const SizedBox(
                  height: 5,
                ),
                BoxInputField(
                  labelText: "Lot No. :",
                  controller: _lotNoController,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Label("Scan"),
                    SizedBox(
                      height: 15,
                      child: VerticalDivider(
                        color: COLOR_BLACK,
                        thickness: 2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, RouterList.MaterialInput_Hold_Screen),
                      child: Label(
                        "Hold",
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Button(
                  text: Label(
                    "Send",
                    color: COLOR_WHITE,
                  ),
                  onPress: () {
                    checkValueController();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> _selectedSqliteAndInsert({
  //   String? material,
  //   String? typeMaterial,
  //   String? operatorName,
  //   String? batchNo,
  //   String? machineNo,
  //   String? material1,
  //   String? lotNo1,
  //   String? date1,
  //   String? material2,
  //   String? lotNo2,
  //   String? date2,
  // }) async {
  //   try {
  //     switch (typeMaterial) {
  //       case "B":
  //         {
  //           await databaseHelper.queryTypeMaterial(
  //               material: material,
  //               value: machineNo,
  //               value2: operatorName,
  //               value3: batchNo,
  //               value4: lotNo1,
  //               value5: date1);

  // await databaseHelper.insertSqlite('MATERIAL_TRACE_SHEET', {
  //   'Material': material,
  //   'Type': typeMaterial,
  //   'OperatorName': operatorName,
  //   'BatchNo': batchNo,
  //   'MachineNo': null,
  //   'Material1': null,
  //   'LotNo1': lotNo1,
  //   'Date1': date1,
  //   'Material2': null,
  //   'LotNo2': null,
  //   'Date2': null,
  // });
  //           //dosomethings
  //         }
  //         break;
  //       case "P1":
  //         {
  //           await databaseHelper.queryTypeMaterial(
  //               material: material,
  //               value: typeMaterial,
  //               value2: operatorName,
  //               value3: batchNo,
  //               value4: lotNo1,
  //               value5: date1);

  //           await databaseHelper.insertSqlite('MATERIAL_TRACE_SHEET', {
  //             'Material': material,
  //             'Type': typeMaterial,
  //             'OperatorName': operatorName,
  //             'BatchNo': null,
  //             'MachineNo': machineNo,
  //             'Material1': null,
  //             'LotNo1': lotNo1,
  //             'Date1': date1,
  //             'Material2': null,
  //             'LotNo2': null,
  //             'Date2': null,
  //           });
  //           //dosomethings
  //         }
  //         break;
  //       case "P22":
  //         {
  //           await databaseHelper.queryTypeMaterialAll(
  //               material: material,
  //               value: typeMaterial,
  //               value2: operatorName,
  //               value3: batchNo,
  //               valueMaterial1: material1,
  //               value4: lotNo1,
  //               value5: date1,
  //               value6: material2,
  //               value7: lotNo2,
  //               value8: date2);

  //           await databaseHelper.insertSqlite('MATERIAL_TRACE_SHEET', {
  //             'Material': material,
  //             'Type': typeMaterial,
  //             'OperatorName': operatorName,
  //             'BatchNo': batchNo,
  //             'MachineNo': machineNo,
  //             'Material1': material1,
  //             'LotNo1': lotNo1,
  //             'Date1': date1,
  //             'Material2': material2,
  //             'LotNo2': lotNo2,
  //             'Date2': date2,
  //           });
  //           //dosomethings
  //         }
  //         break;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
