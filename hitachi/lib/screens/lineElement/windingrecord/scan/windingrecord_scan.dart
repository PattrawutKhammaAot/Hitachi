import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/cardButton.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/windingrecordModel.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:hitachi/widget/custom_textinput.dart';

class WindingRecordScanScreen extends StatefulWidget {
  const WindingRecordScanScreen({super.key});

  @override
  State<WindingRecordScanScreen> createState() =>
      _WindingRecordScanScreenState();
}

class _WindingRecordScanScreenState extends State<WindingRecordScanScreen> {
  final TextEditingController _batch_Controller = TextEditingController();
  final TextEditingController _startTime_Controller = TextEditingController();
  final TextEditingController _finishTime_Controller = TextEditingController();
  final TextEditingController _ipeNo_Controller = TextEditingController();
  final TextEditingController _thickness_Controller = TextEditingController();
  final TextEditingController _turn_Controller = TextEditingController();
  final TextEditingController _diameter_Controller = TextEditingController();
  final TextEditingController _custommer_Controller = TextEditingController();
  final TextEditingController _uf_Controller = TextEditingController();
  final TextEditingController _ppmweight_Controller = TextEditingController();
  final TextEditingController _packno_Controller = TextEditingController();
  final TextEditingController _output_Controller = TextEditingController();
  final TextEditingController _gross_Controller = TextEditingController();
  final TextEditingController _width_L__Controller = TextEditingController();
  final TextEditingController _width_R__Controller = TextEditingController();
  final TextEditingController _cb11_Controller = TextEditingController();
  final TextEditingController _cb12_Controller = TextEditingController();
  final TextEditingController _cb13_Controller = TextEditingController();
  final TextEditingController _cb21_Controller = TextEditingController();
  final TextEditingController _cb22_Controller = TextEditingController();
  final TextEditingController _cb23_Controller = TextEditingController();
  final TextEditingController _cb31_Controller = TextEditingController();
  final TextEditingController _cb32_Controller = TextEditingController();
  final TextEditingController _cb33_Controller = TextEditingController();
  final TextEditingController _of1_Controller = TextEditingController();
  final TextEditingController _of2_Controller = TextEditingController();
  final TextEditingController _of3_Controller = TextEditingController();
  final TextEditingController _burnOff_Controller = TextEditingController();
  final TextEditingController _fs1_Controller = TextEditingController();
  final TextEditingController _fs2_Controller = TextEditingController();
  final TextEditingController _fs3_Controller = TextEditingController();
  final TextEditingController _fs4_Controller = TextEditingController();
  final TextEditingController _grade_Controller = TextEditingController();
  final TextEditingController _time_Press_Controller = TextEditingController();
  final TextEditingController _time_Released_Controller =
      TextEditingController();
  final TextEditingController _heat_temp_Controller = TextEditingController();
  final TextEditingController _tension_Controller = TextEditingController();
  final TextEditingController _nip_roll_press_Controller =
      TextEditingController();
  final FocusNode _batch_FocusNode = FocusNode();
  final FocusNode _startTime_FocusNode = FocusNode();
  final FocusNode _finishTime_FocusNode = FocusNode();
  final FocusNode _ipeNo_FocusNode = FocusNode();
  final FocusNode _thickness_FocusNode = FocusNode();
  final FocusNode _turn_FocusNode = FocusNode();
  final FocusNode _diameter_FocusNode = FocusNode();
  final FocusNode _custommer_FocusNode = FocusNode();
  final FocusNode _uf_FocusNode = FocusNode();
  final FocusNode _ppmweight_FocusNode = FocusNode();
  final FocusNode _packno_FocusNode = FocusNode();
  final FocusNode _output_FocusNode = FocusNode();
  final FocusNode _gross_FocusNode = FocusNode();
  final FocusNode _width_L__FocusNode = FocusNode();
  final FocusNode _width_R__FocusNode = FocusNode();
  final FocusNode _cb11_FocusNode = FocusNode();
  final FocusNode _cb12_FocusNode = FocusNode();
  final FocusNode _cb13_FocusNode = FocusNode();
  final FocusNode _cb21_FocusNode = FocusNode();
  final FocusNode _cb22_FocusNode = FocusNode();
  final FocusNode _cb23_FocusNode = FocusNode();
  final FocusNode _cb31_FocusNode = FocusNode();
  final FocusNode _cb32_FocusNode = FocusNode();
  final FocusNode _cb33_FocusNode = FocusNode();
  final FocusNode _of1_FocusNode = FocusNode();
  final FocusNode _of2_FocusNode = FocusNode();
  final FocusNode _of3_FocusNode = FocusNode();
  final FocusNode _burnOff_FocusNode = FocusNode();
  final FocusNode _fs1_FocusNode = FocusNode();
  final FocusNode _fs2_FocusNode = FocusNode();
  final FocusNode _fs3_FocusNode = FocusNode();
  final FocusNode _fs4_FocusNode = FocusNode();
  final FocusNode _grade_FocusNode = FocusNode();
  final FocusNode _time_Press_FocusNode = FocusNode();
  final FocusNode _time_Released_FocusNode = FocusNode();
  final FocusNode _heat_temp_FocusNode = FocusNode();
  final FocusNode _tension_FocusNode = FocusNode();
  final FocusNode _nip_roll_press_FocusNode = FocusNode();

  _getDataRecordFormPDA() async {
    try {
      var loadDataFormPDA = await DatabaseHelper().queryWindingRecodeFormPda(
          'WINDING_RECORD_LOAD_PDA', [_batch_Controller.text]);
      var loadDataSend = await DatabaseHelper().queryWindingRecodeFormPda(
          'WINDING_RECORD_SEND_SERVER', [_batch_Controller.text]);

      if (loadDataFormPDA.isNotEmpty && loadDataSend.isEmpty)
      //Data ในเครื่องมี แต่ ใน ที่จะส่งServer ไม่มี
      {
        List<WindingRecordModel> temp = [];
        temp =
            loadDataFormPDA.map((e) => WindingRecordModel.fromMap(e)).toList();
        print(temp);
        _setValueController(temp);
        setState(() {});
      } else if (loadDataFormPDA.isEmpty && loadDataSend.isNotEmpty)
      //Data ในเครื่องไม่มี แต่่ Data ที่จะส่งใน server มี
      {
        print("object");
        List<WindingRecordModel> temp = [];
        temp = loadDataSend.map((e) => WindingRecordModel.fromMap(e)).toList();
        _setValueController(temp);
        setState(() {});
      } else if (loadDataFormPDA.isNotEmpty && loadDataFormPDA.isNotEmpty)
      //DATA ในเครื่องมี SERVER มี ให้เลือกเอาจากที่จะส่ง API
      {
        List<WindingRecordModel> temp = [];
        temp = loadDataSend.map((e) => WindingRecordModel.fromMap(e)).toList();
        _setValueController(temp);
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  _setValueController(List<WindingRecordModel> temp) async {
    for (var items in temp) {
      _startTime_Controller.text = items.START_TIME ?? "";
      _finishTime_Controller.text = items.FINISH_TIME ?? "";
      _ipeNo_Controller.text = items.IPE_NO ?? "";
      _thickness_Controller.text = items.THICKNESS ?? "";
      _turn_Controller.text = items.TURN.toString() ?? "";
      _diameter_Controller.text = items.DIAMETER.toString() ?? "";
      _custommer_Controller.text = items.CUSTOMER ?? "";
      _uf_Controller.text = items.UF.toString();
      _ppmweight_Controller.text = items.PPM_WEIGHT.toString() ?? "";
      _packno_Controller.text = items.PACK_NO.toString() ?? "";
      _output_Controller.text = items.OUTPUT.toString() ?? "";
      _gross_Controller.text = items.GROSS.toString() ?? "";
      _width_L__Controller.text = items.WIDTH_L.toString() ?? "";
      _width_R__Controller.text = items.WIDHT_R.toString() ?? "";
      _cb11_Controller.text = items.CB11.toString() ?? "";
      _cb12_Controller.text = items.CB12.toString() ?? "";
      _cb13_Controller.text = items.CB13.toString() ?? "";
      _cb21_Controller.text = items.CB21.toString() ?? "";
      _cb22_Controller.text = items.CB22.toString() ?? "";
      _cb23_Controller.text = items.CB23.toString() ?? "";
      _cb31_Controller.text = items.CB31.toString() ?? "";
      _cb32_Controller.text = items.CB32.toString() ?? "";
      _cb33_Controller.text = items.CB33.toString();
      _of1_Controller.text = items.OF1.toString() ?? "";
      _of2_Controller.text = items.OF2.toString() ?? "";
      _of3_Controller.text = items.OF3.toString() ?? "";
      _burnOff_Controller.text = items.BURN_OFF.toString() ?? "";
      _fs1_Controller.text = items.FS1.toString() ?? "";
      _fs2_Controller.text = items.FS2.toString() ?? "";
      _fs3_Controller.text = items.FS3.toString() ?? "";
      _fs4_Controller.text = items.FS4.toString() ?? "";
      _grade_Controller.text = items.GRADE ?? "";
      _time_Press_Controller.text = items.TIME_PRESS.toString() ?? "";
      _time_Released_Controller.text = items.TIME_RELEASED.toString() ?? "";
      _heat_temp_Controller.text = items.HEAT_TEMP.toString() ?? "";
      _tension_Controller.text = items.TENSION.toString() ?? "";
      _nip_roll_press_Controller.text = items.NIP_ROLL_PRESS ?? "";
    }
  }

  _funcSave() async {
    var loadDataSend = await DatabaseHelper().queryWindingRecodeFormPda(
        'WINDING_RECORD_SEND_SERVER', [_batch_Controller.text]);
    if (loadDataSend.isEmpty) {
      await DatabaseHelper().insertRecordDB('WINDING_RECORD_SEND_SERVER', {
        'BATCH_NO': _batch_Controller.text,
        'START_TIME': _startTime_Controller.text,
        'FINISH_TIME': _finishTime_Controller.text,
        'IPENO': _ipeNo_Controller.text,
        'THICKNESS': _thickness_Controller.text,
        'TURN': _turn_Controller.text,
        'DIAMETER': _diameter_Controller.text,
        'CUSTOMER': _custommer_Controller.text,
        'UF': _uf_Controller.text,
        'PPM_WEIGHT': _ppmweight_Controller.text,
        'PACK_NO': _packno_Controller.text,
        'OUTPUT': _output_Controller.text,
        'GROSS': _gross_Controller.text,
        'WIDTH_L': _width_L__Controller.text,
        'WIDHT_R': _width_R__Controller.text,
        'CB11': _cb11_Controller.text,
        'CB12': _cb12_Controller.text,
        'CB13': _cb13_Controller.text,
        'CB21': _cb21_Controller.text,
        'CB22': _cb22_Controller.text,
        'CB23': _cb23_Controller.text,
        'CB31': _cb31_Controller.text,
        'CB32': _cb32_Controller.text,
        'CB33': _cb33_Controller.text,
        'OF1': _of1_Controller.text,
        'OF2': _of2_Controller.text,
        'OF3': _of3_Controller.text,
        'Burnoff': _burnOff_Controller.text,
        'FS1': _fs1_Controller.text,
        'FS2': _fs2_Controller.text,
        'FS3': _fs3_Controller.text,
        'FS4': _fs4_Controller.text,
        'GRADE': _grade_Controller.text,
        'TIME_RESS': _time_Press_Controller.text,
        'TIME_RELEASED': _time_Released_Controller.text,
        'HEAT_TEMP': _heat_temp_Controller.text,
        'TENSION': _tension_Controller.text,
        'NIP_ROLL_PRESS': _nip_roll_press_Controller.text,
      });
    } else {
      await DatabaseHelper().updateRecordDB('WINDING_RECORD_SEND_SERVER', {
        'BATCH_NO': _batch_Controller.text.trim(),
        'START_TIME': _startTime_Controller.text.trim(),
        'FINISH_TIME': _finishTime_Controller.text.trim(),
        'IPENO': _ipeNo_Controller.text.trim(),
        'THICKNESS': _thickness_Controller.text.trim(),
        'TURN': _turn_Controller.text.trim(),
        'DIAMETER': _diameter_Controller.text.trim(),
        'CUSTOMER': _custommer_Controller.text.trim(),
        'UF': _uf_Controller.text.trim(),
        'PPM_WEIGHT': _ppmweight_Controller.text.trim(),
        'PACK_NO': _packno_Controller.text.trim(),
        'OUTPUT': _output_Controller.text.trim(),
        'GROSS': _gross_Controller.text.trim(),
        'WIDTH_L': _width_L__Controller.text.trim(),
        'WIDHT_R': _width_R__Controller.text.trim(),
        'CB11': _cb11_Controller.text.trim(),
        'CB12': _cb12_Controller.text.trim(),
        'CB13': _cb13_Controller.text.trim(),
        'CB21': _cb21_Controller.text.trim(),
        'CB22': _cb22_Controller.text.trim(),
        'CB23': _cb23_Controller.text.trim(),
        'CB31': _cb31_Controller.text.trim(),
        'CB32': _cb32_Controller.text.trim(),
        'CB33': _cb33_Controller.text.trim(),
        'OF1': _of1_Controller.text.trim(),
        'OF2': _of2_Controller.text.trim(),
        'OF3': _of3_Controller.text.trim(),
        'Burnoff': _burnOff_Controller.text.trim(),
        'FS1': _fs1_Controller.text.trim(),
        'FS2': _fs2_Controller.text.trim(),
        'FS3': _fs3_Controller.text.trim(),
        'FS4': _fs4_Controller.text.trim(),
        'GRADE': _grade_Controller.text.trim(),
        'TIME_RESS': _time_Press_Controller.text.trim(),
        'TIME_RELEASED': _time_Released_Controller.text.trim(),
        'HEAT_TEMP': _heat_temp_Controller.text.trim(),
        'TENSION': _tension_Controller.text.trim(),
        'NIP_ROLL_PRESS': _nip_roll_press_Controller.text.trim(),
      }, [
        _batch_Controller.text.trim()
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BgWhite(
        isHideAppBar: true,
        body: Padding(
          padding: EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInputField(
                        focusNode: _batch_FocusNode,
                        controller: _batch_Controller,
                        maxLength: 12,
                        keyboardType: TextInputType.number,
                        isHideLable: true,
                        labelText: "BATCH NO",
                        onFieldSubmitted: (value) async {
                          if (value.length == 12) {
                            // await _getDataRecordFormPDA();
                            // _thickness_FocusNode.requestFocus();
                          }
                          await _getDataRecordFormPDA();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a value';
                          }
                          return null;
                        },
                        textInputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextInputField(
                        focusNode: _startTime_FocusNode,
                        controller: _startTime_Controller,
                        isHideLable: true,
                        labelText: "START TIME",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInputField(
                        focusNode: _finishTime_FocusNode,
                        controller: _finishTime_Controller,
                        isHideLable: true,
                        labelText: "Finish Time".toUpperCase(),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextInputField(
                        focusNode: _ipeNo_FocusNode,
                        controller: _ipeNo_Controller,
                        isHideLable: true,
                        labelText: "IPE No.".toUpperCase(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInputField(
                        focusNode: _thickness_FocusNode,
                        controller: _thickness_Controller,
                        keyboardType: TextInputType.number,
                        textInputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                        ],
                        isHideLable: true,
                        labelText: "Thickness".toUpperCase(),
                        onFieldSubmitted: (value) {
                          if (value.isNotEmpty) {
                            double? thicknessValue = double.tryParse(value);
                            if (thicknessValue == null ||
                                thicknessValue < 8 ||
                                thicknessValue > 15.7) {
                              _thickness_FocusNode.requestFocus();
                              _thickness_Controller.clear();
                            } else {
                              _turn_FocusNode.requestFocus();
                            }
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a value';
                          }

                          double? thicknessValue = double.tryParse(value);
                          if (thicknessValue == null ||
                              thicknessValue < 8 ||
                              thicknessValue > 15.7) {
                            return ' between 8 and 15.7';
                          }

                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextInputField(
                        focusNode: _turn_FocusNode,
                        controller: _turn_Controller,
                        keyboardType: TextInputType.number,
                        textInputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                        isHideLable: true,
                        labelText: "Turn".toUpperCase(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInputField(
                        controller: _diameter_Controller,
                        focusNode: _diameter_FocusNode,
                        isHideLable: true,
                        labelText: "Diameter".toUpperCase(),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextInputField(
                        controller: _custommer_Controller,
                        focusNode: _custommer_FocusNode,
                        isHideLable: true,
                        labelText: "Customer".toUpperCase(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInputField(
                        controller: _uf_Controller,
                        focusNode: _uf_FocusNode,
                        isHideLable: true,
                        labelText: "uf".toUpperCase(),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextInputField(
                        controller: _ppmweight_Controller,
                        focusNode: _ppmweight_FocusNode,
                        isHideLable: true,
                        labelText: "PPMWeight".toUpperCase(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInputField(
                        controller: _packno_Controller,
                        focusNode: _packno_FocusNode,
                        isHideLable: true,
                        labelText: "PackNo".toUpperCase(),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextInputField(
                        controller: _output_Controller,
                        focusNode: _output_FocusNode,
                        isHideLable: true,
                        labelText: "Output:pcs".toUpperCase(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInputField(
                        controller: _width_R__Controller,
                        focusNode: _width_R__FocusNode,
                        isHideLable: true,
                        labelText: "WIDTH : R",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextInputField(
                        controller: _width_L__Controller,
                        focusNode: _width_L__FocusNode,
                        isHideLable: true,
                        labelText: "WIDTH : L",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInputField(
                        focusNode: _gross_FocusNode,
                        controller: _gross_Controller,
                        isHideLable: true,
                        labelText: "GROSS WT",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextInputField(
                        controller: _cb11_Controller,
                        focusNode: _cb11_FocusNode,
                        isHideLable: true,
                        labelText: "CB11",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInputField(
                        controller: _cb12_Controller,
                        focusNode: _cb12_FocusNode,
                        isHideLable: true,
                        labelText: "CB12",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextInputField(
                        controller: _cb13_Controller,
                        focusNode: _cb13_FocusNode,
                        isHideLable: true,
                        labelText: "CB13",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInputField(
                        controller: _cb21_Controller,
                        focusNode: _cb21_FocusNode,
                        isHideLable: true,
                        labelText: "CB21",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextInputField(
                        controller: _cb22_Controller,
                        focusNode: _cb22_FocusNode,
                        isHideLable: true,
                        labelText: "CB22",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInputField(
                        controller: _cb23_Controller,
                        focusNode: _cb23_FocusNode,
                        isHideLable: true,
                        labelText: "CB23",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextInputField(
                        controller: _cb31_Controller,
                        focusNode: _cb31_FocusNode,
                        isHideLable: true,
                        labelText: "CB31",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInputField(
                        controller: _cb32_Controller,
                        focusNode: _cb32_FocusNode,
                        isHideLable: true,
                        labelText: "CB32",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextInputField(
                        controller: _cb33_Controller,
                        focusNode: _cb33_FocusNode,
                        isHideLable: true,
                        labelText: "CB33",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInputField(
                        controller: _of1_Controller,
                        focusNode: _of1_FocusNode,
                        isHideLable: true,
                        labelText: "OF1",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextInputField(
                        controller: _of2_Controller,
                        focusNode: _of2_FocusNode,
                        isHideLable: true,
                        labelText: "OF2",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInputField(
                        controller: _of3_Controller,
                        focusNode: _of3_FocusNode,
                        isHideLable: true,
                        labelText: "OF3",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextInputField(
                        controller: _burnOff_Controller,
                        focusNode: _burnOff_FocusNode,
                        isHideLable: true,
                        labelText: "BURN OFF",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInputField(
                        controller: _fs1_Controller,
                        focusNode: _fs1_FocusNode,
                        isHideLable: true,
                        labelText: "FS1",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextInputField(
                        controller: _fs2_Controller,
                        focusNode: _fs2_FocusNode,
                        isHideLable: true,
                        labelText: "FS2",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInputField(
                        controller: _fs3_Controller,
                        focusNode: _fs3_FocusNode,
                        isHideLable: true,
                        labelText: "FS3",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextInputField(
                        controller: _fs4_Controller,
                        focusNode: _fs4_FocusNode,
                        isHideLable: true,
                        labelText: "FS4",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInputField(
                        controller: _grade_Controller,
                        focusNode: _grade_FocusNode,
                        isHideLable: true,
                        labelText: "FILM GRADE",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextInputField(
                        controller: _time_Press_Controller,
                        focusNode: _time_Press_FocusNode,
                        isHideLable: true,
                        labelText: "TIME PRESS",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInputField(
                        controller: _time_Released_Controller,
                        focusNode: _time_Released_FocusNode,
                        isHideLable: true,
                        labelText: "TIME RELASED",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextInputField(
                        controller: _heat_temp_Controller,
                        focusNode: _heat_temp_FocusNode,
                        isHideLable: true,
                        labelText: "HEAT TEMP",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInputField(
                        controller: _tension_Controller,
                        focusNode: _tension_FocusNode,
                        isHideLable: true,
                        labelText: "WINDING TENSION",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextInputField(
                        controller: _nip_roll_press_Controller,
                        focusNode: _nip_roll_press_FocusNode,
                        isHideLable: true,
                        labelText: "NIP ROLL PRESS",
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await _funcSave();
                        },
                        child: Label(
                          "Save",
                          color: COLOR_WHITE,
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(COLOR_BLUE_DARK)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ));
  }
}
