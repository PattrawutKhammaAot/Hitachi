import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:hitachi/blocs/connection/testconnection_bloc.dart';
import 'package:hitachi/blocs/network/bloc/network_bloc.dart';
import 'package:hitachi/blocs/windingRecord/windingrecord_bloc.dart';
import 'package:hitachi/config.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/cardButton.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/windingrecordModel.dart';
import 'package:hitachi/models/windingRecordModel/ResponeseWindingRecordModel.dart';
import 'package:hitachi/models/windingRecordModel/output_windingRecordModel.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:hitachi/widget/custom_textinput.dart';

class WindingRecordScanScreen extends StatefulWidget {
  const WindingRecordScanScreen({super.key, this.onChange});

  final ValueChanged<List<Map<String, dynamic>>>? onChange;

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
  ResponeseWindingRecordModel itemWindingRecord = ResponeseWindingRecordModel();

  String isCheckConnection = 'Save';

  _getDataRecordFormPDA() async {
    try {
      var loadDataSend = await DatabaseHelper().queryWindingRecodeFormPda(
          'WINDING_RECORD_SEND_SERVER', [_batch_Controller.text]);
      var ipe = await DatabaseHelper()
          .queryIPESHEET('IPE_SHEET', [_batch_Controller.text]);
      var windingSheet = await DatabaseHelper()
          .queryIPESHEET('WINDING_SHEET', [_batch_Controller.text]);
      String ipeText = '';
      String _startTime = '';
      String _finishTime = '';

      if (ipe.isNotEmpty) {
        for (var itemIPE in ipe) {
          if (itemIPE['BatchNo'] == _batch_Controller.text) {
            ipeText = itemIPE['IPE_NO'];
          }
        }
      }
      if (windingSheet.isNotEmpty) {
        for (var itemWinding in windingSheet) {
          if (itemWinding['BatchNo'] == _batch_Controller.text) {
            _startTime = itemWinding['BatchStartDate'];
            _finishTime = itemWinding['BatchEndDate'];
          }
        }
      }

      if (loadDataSend.isNotEmpty) {
        List<WindingRecordModelSqlite> temp = [];
        temp = loadDataSend
            .map((e) => WindingRecordModelSqlite.fromMap(e))
            .toList();

        _setValueController(temp, ipeText, _startTime, _finishTime);
        setState(() {});
        EasyLoading.showSuccess("Load Data Success");
      } else {
        _clearController();
        _ipeNo_Controller.text = ipeText;

        _thickness_FocusNode.requestFocus();
        setState(() {});
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  _setValueController(List<WindingRecordModelSqlite> temp, String ipe,
      String startTime, String endTime) async {
    for (var items in temp) {
      _startTime_Controller.text =
          (startTime.isEmpty ? items.START_TIME : startTime) ?? "";
      _finishTime_Controller.text =
          (startTime.isEmpty ? items.FINISH_TIME : endTime) ?? "";
      _ipeNo_Controller.text = ipe;
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
      }).then((value) {
        _clearController();
        _batch_Controller.clear();
        _batch_FocusNode.requestFocus();
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
      ]).then((value) {
        _clearController();
        _batch_Controller.clear();
        _batch_FocusNode.requestFocus();
      });
    }
    EasyLoading.showInfo("Save Success!");
  }

  _getValuesFromServer(ResponeseWindingRecordModel items) {
    _batch_Controller.text = items.BATCH_NO.toString();
    _startTime_Controller.text = items.START_TIME.toString();
    _finishTime_Controller.text = items.FINISH_TIME.toString();
    _ipeNo_Controller.text = items.IPE_NO.toString();
    _thickness_Controller.text = items.THICKNESS.toString();
    _turn_Controller.text = items.TURN.toString();
    _diameter_Controller.text = items.DIAMETER.toString();
    _custommer_Controller.text = items.CUSTOMER ?? "";
    _uf_Controller.text = items.UF.toString();
    _ppmweight_Controller.text = items.PPM_WEIGHT.toString();
    _packno_Controller.text = items.PACK_NO.toString();
    _output_Controller.text = items.OUTPUT.toString();
    _gross_Controller.text = items.GROSS.toString();
    _width_L__Controller.text = items.WIDTHL.toString();
    _width_R__Controller.text = items.WIDTHR.toString();
    _cb11_Controller.text = items.CB11.toString();
    _cb12_Controller.text = items.CB12.toString();
    _cb13_Controller.text = items.CB13.toString();
    _cb21_Controller.text = items.CB21.toString();
    _cb22_Controller.text = items.CB22.toString();
    _cb23_Controller.text = items.CB23.toString();
    _cb31_Controller.text = items.CB31.toString();
    _cb32_Controller.text = items.CB32.toString();
    _cb33_Controller.text = items.CB33.toString();
    _of1_Controller.text = items.OF1.toString();
    _of2_Controller.text = items.OF2.toString();
    _of3_Controller.text = items.OF3.toString();
    _burnOff_Controller.text = items.BURNOFF.toString();
    _fs1_Controller.text = items.FS1.toString();
    _fs2_Controller.text = items.FS2.toString();
    _fs3_Controller.text = items.FS3.toString();
    _fs4_Controller.text = items.FS4.toString();
    _grade_Controller.text = items.GRADE.toString();
    _time_Press_Controller.text = items.TIME_PRESS.toString();
    _time_Released_Controller.text = items.TIME_RELEASED.toString();
    _heat_temp_Controller.text = items.HEAT_TEMP.toString();
    _tension_Controller.text = items.TENSION.toString();
    _nip_roll_press_Controller.text = items.NIP_ROLL_PRESS.toString();
  }

  _clearController() {
    _startTime_Controller.clear();
    _finishTime_Controller.clear();
    _ipeNo_Controller.clear();
    _thickness_Controller.clear();
    _turn_Controller.clear();
    _diameter_Controller.clear();
    _custommer_Controller.clear();
    _uf_Controller.clear();
    _ppmweight_Controller.clear();
    _packno_Controller.clear();
    _output_Controller.clear();
    _gross_Controller.clear();
    _width_L__Controller.clear();
    _width_R__Controller.clear();
    _cb11_Controller.clear();
    _cb12_Controller.clear();
    _cb13_Controller.clear();
    _cb21_Controller.clear();
    _cb22_Controller.clear();
    _cb23_Controller.clear();
    _cb31_Controller.clear();
    _cb32_Controller.clear();
    _cb33_Controller.clear();
    _of1_Controller.clear();
    _of2_Controller.clear();
    _of3_Controller.clear();
    _burnOff_Controller.clear();
    _fs1_Controller.clear();
    _fs2_Controller.clear();
    _fs3_Controller.clear();
    _fs4_Controller.clear();
    _grade_Controller.clear();
    _time_Press_Controller.clear();
    _time_Released_Controller.clear();
    _heat_temp_Controller.clear();
    _tension_Controller.clear();
    _nip_roll_press_Controller.clear();
    setState(() {});
  }

  _sendApi() {
    BlocProvider.of<WindingrecordBloc>(context)
        .add(SendWindingRecordEvent(OutputWindingRecordModel(
      BATCH_NO: _batch_Controller.text.trim(),
      START_DATE: _startTime_Controller.text,
      END_DATE: _finishTime_Controller.text,
      START_TIME: _startTime_Controller.text,
      FINISH_TIME: _finishTime_Controller.text,
      OUTPUT: _output_Controller.text.isNotEmpty
          ? int.tryParse(_output_Controller.text)
          : 0,
      IPE_NO: _ipeNo_Controller.text.isNotEmpty
          ? int.tryParse(_ipeNo_Controller.text)
          : 0,
      THICKNESS: _thickness_Controller.text.trim(),
      PACK_NO: _packno_Controller.text.trim(),
      PPM_WEIGHT: _ppmweight_Controller.text.isNotEmpty
          ? num.tryParse(_ppmweight_Controller.text)
          : 0,
      TURN: _turn_Controller.text.isNotEmpty
          ? int.tryParse(_turn_Controller.text)
          : 0,
      DIAMETER: _diameter_Controller.text.isNotEmpty
          ? num.tryParse(_diameter_Controller.text)
          : 0,
      CUSTOMER: _custommer_Controller.text.trim(),
      UF: _uf_Controller.text.isNotEmpty
          ? num.tryParse(_uf_Controller.text)
          : 0,
      GROSS: _gross_Controller.text.isNotEmpty
          ? num.tryParse(_gross_Controller.text)
          : 0,
      WIDTHL: _width_L__Controller.text.isNotEmpty
          ? num.tryParse(_width_L__Controller.text)
          : 0,
      WIDTHR: _width_R__Controller.text.isNotEmpty
          ? num.tryParse(_width_R__Controller.text)
          : 0,
      CB11: _cb11_Controller.text.isNotEmpty
          ? num.tryParse(_cb11_Controller.text)
          : 0,
      CB12: _cb12_Controller.text.isNotEmpty
          ? num.tryParse(_cb12_Controller.text)
          : 0,
      CB13: _cb13_Controller.text.isNotEmpty
          ? num.tryParse(_cb13_Controller.text)
          : 0,
      CB21: _cb21_Controller.text.isNotEmpty
          ? num.tryParse(_cb21_Controller.text)
          : 0,
      CB22: _cb22_Controller.text.isNotEmpty
          ? num.tryParse(_cb22_Controller.text)
          : 0,
      CB23: _cb23_Controller.text.isNotEmpty
          ? num.tryParse(_cb23_Controller.text)
          : 0,
      CB31: _cb31_Controller.text.isNotEmpty
          ? num.tryParse(_cb31_Controller.text)
          : 0,
      CB32: _cb32_Controller.text.isNotEmpty
          ? num.tryParse(_cb32_Controller.text)
          : 0,
      CB33: _cb33_Controller.text.isNotEmpty
          ? num.tryParse(_cb33_Controller.text)
          : 0,
      OF1: _of1_Controller.text.isNotEmpty
          ? num.tryParse(_of1_Controller.text)
          : 0,
      OF2: _of2_Controller.text.isNotEmpty
          ? num.tryParse(_of2_Controller.text)
          : 0,
      OF3: _of3_Controller.text.isNotEmpty
          ? num.tryParse(_of3_Controller.text)
          : 0,
      BURNOFF: _burnOff_Controller.text.isNotEmpty
          ? num.tryParse(_burnOff_Controller.text)
          : 0,
      FS1: _fs1_Controller.text.isNotEmpty
          ? num.tryParse(_fs1_Controller.text)
          : 0,
      FS2: _fs2_Controller.text.isNotEmpty
          ? num.tryParse(_fs2_Controller.text)
          : 0,
      FS3: _fs3_Controller.text.isNotEmpty
          ? num.tryParse(_fs3_Controller.text)
          : 0,
      FS4: _fs4_Controller.text.isNotEmpty
          ? num.tryParse(_fs4_Controller.text)
          : 0,
      GRADE: _grade_Controller.text.trim(),
      TIME_PRESS: _time_Press_Controller.text.isNotEmpty
          ? num.tryParse(_time_Press_Controller.text)
          : 0,
      TIME_RELEASED: _time_Released_Controller.text.isNotEmpty
          ? num.tryParse(_time_Released_Controller.text)
          : 0,
      HEAT_TEMP: _heat_temp_Controller.text.isNotEmpty
          ? num.tryParse(_heat_temp_Controller.text)
          : 0,
      TENSION: _tension_Controller.text.isNotEmpty
          ? int.tryParse(_tension_Controller.text)
          : 0,
      NIP_ROLL_PRESS: _nip_roll_press_Controller.text.trim(),
    )));
  }

  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await DatabaseHelper().queryAllRows('WINDING_RECORD_SEND_SERVER');

    setState(() {
      widget.onChange?.call(sql.toList());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<TestconnectionBloc>(context)
        .add(Test_ConnectionOnWindingRecordEvent());
    _getHold();
    _batch_FocusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<WindingrecordBloc, WindingrecordState>(
            listener: (context, state) async {
          if (state is GetWindingRecordLoadingState) {
            EasyLoading.show(status: "Loading Data ...");
          } else if (state is GetWindingRecordLoadedState) {
            if (state.item.MESSAGE == 'No data in WindingRecord') {
              _startTime_Controller.text = state.item.START_TIME.toString();
              _ipeNo_Controller.text = state.item.IPE_NO.toString();
              _finishTime_Controller.text = state.item.FINISH_TIME.toString();
              _ppmweight_Controller.text = state.item.PPM_WEIGHT.toString();
              _packno_Controller.text = state.item.PACK_NO.toString();
              _output_Controller.text = state.item.OUTPUT.toString();
              // if(PDA HAS DATA KEYIN) SETVALUES
              EasyLoading.showInfo("${state.item.MESSAGE}");
              EasyLoading.dismiss();
              _thickness_FocusNode.requestFocus();
            } else if (state.item.MESSAGE == 'No data in WINDING_SHEET') {
              EasyLoading.showInfo("${state.item.MESSAGE}");
              await _getDataRecordFormPDA();
            } else if (state.item.RESULT == true &&
                state.item.MESSAGE == null) {
              EasyLoading.dismiss();
              itemWindingRecord = state.item;
              _getValuesFromServer(itemWindingRecord);
              setState(() {});
            }
          } else if (state is GetWindingRecordErrorState) {
            EasyLoading.dismiss();
            await _getDataRecordFormPDA();
          }
        }),
        BlocListener<NetworkBloc, NetworkState>(
            listener: (context, state) async {
          if (state is NetworkFailure) {
            isCheckConnection = 'Save';
            setState(() {});
          } else if (state is NetworkSuccess) {
            BlocProvider.of<TestconnectionBloc>(context)
                .add(Test_ConnectionOnWindingRecordEvent());
          }
        }),
        BlocListener<TestconnectionBloc, TestconnectionState>(
          listener: (context, state) {
            if (state is TestconnectionWRDLoadingState) {
            } else if (state is TestconnectionWRDLoadedState) {
              EasyLoading.dismiss();
              if (state.item.RESULT == true) {
                isCheckConnection = 'Send';
              } else {
                isCheckConnection = 'Save';
              }
              setState(() {});
            }
            if (state is TestconnectionWRDErrorState) {
              EasyLoading.dismiss();
              isCheckConnection = 'Save';
              setState(() {});
            }
          },
        ),
        BlocListener<WindingrecordBloc, WindingrecordState>(
            listener: (context, state) async {
          if (state is SendWindingRecordLoadingState) {
            EasyLoading.show(status: "Loading Data ...");
          } else if (state is SendWindingRecordLoadedState) {
            if (state.item.RESULT == true) {
              await DatabaseHelper().deleteRecordDB(
                  'WINDING_RECORD_SEND_SERVER',
                  [_batch_Controller.text.trim()]);
              EasyLoading.dismiss();
              _batch_Controller.clear();
              _clearController();
              _batch_FocusNode.requestFocus();
              EasyLoading.showSuccess("Send Success!");
            } else {
              EasyLoading.showError("${state.item.MESSAGE}");
              _batch_Controller.clear();
              _clearController();
              _batch_FocusNode.requestFocus();
            }
          } else if (state is SendWindingRecordErrorState) {
            EasyLoading.showError(state.error);
          }
        }),
      ],
      child: BgWhite(
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
                              BlocProvider.of<WindingrecordBloc>(context).add(
                                GetWindingRecordEvent(value),
                              );
                              // _thickness_FocusNode.requestFocus();
                            } else {
                              _batch_FocusNode.requestFocus();
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            } else if (value == null || value.length != 12) {
                              return 'Please input batch 12 digit';
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
                          // readOnly: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextInputField(
                          focusNode: _finishTime_FocusNode,
                          controller: _finishTime_Controller,
                          isHideLable: true,
                          labelText: "Finish Time".toUpperCase(),
                          // readOnly: true,
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
                          // readOnly: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
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
                          maxLength: 4,
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
                              return 'Thickness between 8 and 15.7';
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
                          onFieldSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _diameter_FocusNode.requestFocus();
                            } else {
                              _turn_FocusNode.requestFocus();
                            }
                          },
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
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextInputField(
                          controller: _diameter_Controller,
                          focusNode: _diameter_FocusNode,
                          keyboardType: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,1}$')),
                          ],
                          onFieldSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _custommer_FocusNode.requestFocus();
                            } else {
                              _diameter_FocusNode.requestFocus();
                            }
                          },
                          isHideLable: true,
                          labelText: "Diameter".toUpperCase(),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: DropdownButtonFormField2(
                          focusNode: _custommer_FocusNode,
                          value: _custommer_Controller.text.isNotEmpty
                              ? _custommer_Controller.text
                              : null,
                          alignment: Alignment.center,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: "Customer",
                            labelStyle: TextStyle(color: COLOR_BLUE_DARK),
                            contentPadding: EdgeInsets.only(left: 15),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: COLOR_BLUE_DARK),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          isExpanded: true,
                          items: ['Export', 'Local']
                              .toList()
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      "${item}",
                                      style: const TextStyle(
                                          fontSize: 14, color: COLOR_BLUE_DARK),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            _custommer_Controller.text = value!;
                            _uf_FocusNode.requestFocus();
                          },
                          onSaved: (value) {
                            _custommer_Controller.text = value!;
                          },
                          buttonStyleData: const ButtonStyleData(
                            height: 50,
                            padding: EdgeInsets.only(left: 10, right: 10),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black45,
                            ),
                            iconSize: 30,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextInputField(
                          controller: _uf_Controller,
                          focusNode: _uf_FocusNode,
                          keyboardType: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,1}$')),
                          ],
                          isHideLable: true,
                          labelText: "uf".toUpperCase(),
                          onFieldSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _ppmweight_FocusNode.requestFocus();
                            } else {
                              _uf_FocusNode.requestFocus();
                            }
                          },
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
                            onFieldSubmitted: (value) => value.isNotEmpty
                                ? _packno_FocusNode.requestFocus()
                                : _ppmweight_FocusNode.requestFocus()),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextInputField(
                            controller: _packno_Controller,
                            focusNode: _packno_FocusNode,
                            isHideLable: true,
                            labelText: "PackNo".toUpperCase(),
                            onFieldSubmitted: (value) => value.isNotEmpty
                                ? _output_FocusNode.requestFocus()
                                : _packno_FocusNode.requestFocus()),
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
                            onFieldSubmitted: (value) => value.isNotEmpty
                                ? _width_R__FocusNode.requestFocus()
                                : _output_FocusNode.requestFocus()),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextInputField(
                          controller: _width_R__Controller,
                          focusNode: _width_R__FocusNode,
                          isHideLable: true,
                          labelText: "WIDTH : R",
                          keyboardType: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}$')),
                          ],
                          onFieldSubmitted: (p0) => p0.isNotEmpty
                              ? _width_L__FocusNode.requestFocus()
                              : _width_R__FocusNode.requestFocus(),
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
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}$')),
                            ],
                            onFieldSubmitted: (value) => value.isNotEmpty
                                ? _gross_FocusNode.requestFocus()
                                : _width_L__FocusNode.requestFocus()),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextInputField(
                            focusNode: _gross_FocusNode,
                            controller: _gross_Controller,
                            isHideLable: true,
                            labelText: "GROSS WT",
                            onFieldSubmitted: (value) => value.isNotEmpty
                                ? _cb11_FocusNode.requestFocus()
                                : _gross_FocusNode.requestFocus()),
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
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,1}$')),
                            ],
                            onFieldSubmitted: (value) => value.isNotEmpty
                                ? _cb12_FocusNode.requestFocus()
                                : _cb11_FocusNode.requestFocus()),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextInputField(
                            controller: _cb12_Controller,
                            focusNode: _cb12_FocusNode,
                            isHideLable: true,
                            labelText: "CB12",
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,1}$')),
                            ],
                            onFieldSubmitted: (value) => value.isNotEmpty
                                ? _cb13_FocusNode.requestFocus()
                                : _cb12_FocusNode.requestFocus()),
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
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,1}$')),
                            ],
                            onFieldSubmitted: (value) => value.isNotEmpty
                                ? _cb21_FocusNode.requestFocus()
                                : _cb13_FocusNode.requestFocus()),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextInputField(
                            controller: _cb21_Controller,
                            focusNode: _cb21_FocusNode,
                            isHideLable: true,
                            labelText: "CB21",
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,1}$')),
                            ],
                            onFieldSubmitted: (value) => value.isNotEmpty
                                ? _cb22_FocusNode.requestFocus()
                                : _cb21_FocusNode.requestFocus()),
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
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,1}$')),
                            ],
                            onFieldSubmitted: (value) => value.isNotEmpty
                                ? _cb23_FocusNode.requestFocus()
                                : _cb22_FocusNode.requestFocus()),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextInputField(
                            controller: _cb23_Controller,
                            focusNode: _cb23_FocusNode,
                            isHideLable: true,
                            labelText: "CB23",
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,1}$')),
                            ],
                            onFieldSubmitted: (value) => value.isNotEmpty
                                ? _cb31_FocusNode.requestFocus()
                                : _cb23_FocusNode.requestFocus()),
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
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,1}$')),
                            ],
                            onFieldSubmitted: (value) => value.isNotEmpty
                                ? _cb32_FocusNode.requestFocus()
                                : _cb31_FocusNode.requestFocus()),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextInputField(
                            controller: _cb32_Controller,
                            focusNode: _cb32_FocusNode,
                            isHideLable: true,
                            labelText: "CB32",
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,1}$')),
                            ],
                            onFieldSubmitted: (value) => value.isNotEmpty
                                ? _cb33_FocusNode.requestFocus()
                                : _cb32_FocusNode.requestFocus()),
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
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,1}$')),
                            ],
                            onFieldSubmitted: (value) => value.isNotEmpty
                                ? _of1_FocusNode.requestFocus()
                                : _cb33_FocusNode.requestFocus()),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextInputField(
                          controller: _of1_Controller,
                          focusNode: _of1_FocusNode,
                          isHideLable: true,
                          labelText: "OF1",
                          keyboardType: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}$')),
                          ],
                          onFieldSubmitted: (value) => value.isNotEmpty
                              ? _of2_FocusNode.requestFocus()
                              : _of1_FocusNode.requestFocus(),
                          validator: (value) {
                            if (value != null) {
                              double? of1Values = double.tryParse(value);
                              if (value.length >= 4) {
                                if (of1Values == null ||
                                    of1Values < 1.50 ||
                                    of1Values > 2.0) {
                                  _of1_FocusNode.requestFocus();

                                  return "value between 1.50 - 2.00 !";
                                } else {
                                  // _of2_FocusNode.requestFocus();
                                }
                              }
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
                            controller: _of2_Controller,
                            focusNode: _of2_FocusNode,
                            isHideLable: true,
                            labelText: "OF2",
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}$')),
                            ],
                            validator: (value) {
                              if (value != null) {
                                double? of1Values = double.tryParse(value);
                                if (value.length >= 4) {
                                  if (of1Values == null ||
                                      of1Values < 1.50 ||
                                      of1Values > 2.0) {
                                    _of2_FocusNode.requestFocus();

                                    return "value between 1.50 - 2.00 !";
                                  } else {
                                    // _of3_FocusNode.requestFocus();
                                  }
                                }
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) => value.isNotEmpty
                                ? _of3_FocusNode.requestFocus()
                                : _of2_FocusNode.requestFocus()),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextInputField(
                            controller: _of3_Controller,
                            focusNode: _of3_FocusNode,
                            isHideLable: true,
                            labelText: "OF3",
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}$')),
                            ],
                            validator: (value) {
                              if (value != null) {
                                double? of1Values = double.tryParse(value);
                                if (value.length >= 4) {
                                  if (of1Values == null ||
                                      of1Values < 1.50 ||
                                      of1Values > 2.0) {
                                    _of3_FocusNode.requestFocus();

                                    return "value between 1.50 - 2.00 !";
                                  } else {
                                    // _burnOff_FocusNode.requestFocus();
                                  }
                                }
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) => value.isNotEmpty
                                ? _burnOff_FocusNode.requestFocus()
                                : _of3_FocusNode.requestFocus()),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomTextInputField(
                            controller: _burnOff_Controller,
                            focusNode: _burnOff_FocusNode,
                            isHideLable: true,
                            maxLength: 2,
                            keyboardType: TextInputType.number,
                            labelText: "BURN OFF",
                            validator: (value) {
                              if (value != null) {
                                if (value.length == 2) {
                                  int? of1Values = int.tryParse(value);
                                  if (of1Values == null ||
                                      of1Values < 27 ||
                                      of1Values > 38) {
                                    _burnOff_Controller.clear();
                                    _burnOff_FocusNode.requestFocus();
                                    return 'input value between 27-38 !';
                                  } else {
                                    // _fs1_FocusNode.requestFocus();
                                  }
                                }
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) => value.isNotEmpty
                                ? _fs1_FocusNode.requestFocus()
                                : _burnOff_FocusNode.requestFocus()),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextInputField(
                          controller: _fs1_Controller,
                          focusNode: _fs1_FocusNode,
                          isHideLable: true,
                          labelText: "FS1",
                          keyboardType: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}$')),
                          ],
                          validator: (p0) {
                            if (p0 != null) {
                              if (p0.isEmpty) {
                                return "Please Entry Value";
                              }
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _fs2_FocusNode.requestFocus();
                            } else {
                              _fs1_FocusNode.requestFocus();
                            }
                          },
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
                          keyboardType: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}$')),
                          ],
                          validator: (p0) {
                            if (p0 != null) {
                              if (p0.isEmpty) {
                                return "Please Entry Value";
                              }
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _fs3_FocusNode.requestFocus();
                            } else {
                              _fs2_FocusNode.requestFocus();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextInputField(
                          controller: _fs3_Controller,
                          focusNode: _fs3_FocusNode,
                          isHideLable: true,
                          labelText: "FS3",
                          keyboardType: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}$')),
                          ],
                          validator: (p0) {
                            if (p0 != null) {
                              if (p0.isEmpty) {
                                return "Please Entry Value";
                              }
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _fs4_FocusNode.requestFocus();
                            } else {
                              _fs3_FocusNode.requestFocus();
                            }
                          },
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
                          keyboardType: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}$')),
                          ],
                          validator: (p0) {
                            if (p0 != null) {
                              if (p0.isEmpty) {
                                return "Please Entry Value";
                              }
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _grade_FocusNode.requestFocus();
                            } else {
                              _fs4_FocusNode.requestFocus();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextInputField(
                          controller: _grade_Controller,
                          focusNode: _grade_FocusNode,
                          isHideLable: true,
                          labelText: "FILM GRADE",
                          maxLength: 1,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z]')),
                          ],
                          validator: (p0) {
                            if (p0 != null) {
                              if (p0.isEmpty) {
                                return "Please Entry Value";
                              }
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _time_Press_FocusNode.requestFocus();
                            } else {
                              _grade_FocusNode.requestFocus();
                            }
                          },
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
                          keyboardType: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,1}$')),
                          ],
                          onFieldSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _time_Released_FocusNode.requestFocus();
                            } else {
                              _time_Press_FocusNode.requestFocus();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextInputField(
                          controller: _time_Released_Controller,
                          focusNode: _time_Released_FocusNode,
                          isHideLable: true,
                          labelText: "TIME RELASED",
                          keyboardType: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}$')),
                          ],
                          onFieldSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _heat_temp_FocusNode.requestFocus();
                            } else {
                              _time_Released_FocusNode.requestFocus();
                            }
                          },
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
                          keyboardType: TextInputType.number,
                          labelText: "HEAT TEMP",
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          onFieldSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _tension_FocusNode.requestFocus();
                            } else {
                              _heat_temp_FocusNode.requestFocus();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextInputField(
                          controller: _tension_Controller,
                          focusNode: _tension_FocusNode,
                          isHideLable: true,
                          labelText: "WINDING TENSION",
                          onFieldSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _nip_roll_press_FocusNode.requestFocus();
                            } else {
                              _tension_FocusNode.requestFocus();
                            }
                          },
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
                            if (isCheckConnection == 'Save') {
                              await _funcSave();
                              await _getHold();
                            } else if (isCheckConnection == 'Send') {
                              _sendApi();
                            }
                          },
                          child: Label(
                            '${isCheckConnection}',
                            color: COLOR_WHITE,
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  isCheckConnection == 'Send'
                                      ? COLOR_SUCESS
                                      : COLOR_BLUE_DARK)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
