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
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
  final TextEditingController _tempIPE_Controller = TextEditingController();
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
  final _formKey = GlobalKey<FormState>();
  String isCheckConnection = 'Save';

  _getDataRecordFormPDA() async {
    try {
      var loadDataSend = await DatabaseHelper().queryWindingRecodeFormPda(
          'WINDING_RECORD_SEND_SERVER', [_batch_Controller.text.trim()]);
      var ipe = await DatabaseHelper()
          .queryIPESHEET('IPE_SHEET', [_batch_Controller.text.trim()]);
      var windingSheet = await DatabaseHelper()
          .queryIPESHEET('WINDING_SHEET', [_batch_Controller.text.trim()]);
      String ipeText = '';
      String _startTime = '';
      String _finishTime = '';

      if (ipe.isNotEmpty) {
        for (var itemIPE in ipe) {
          if (itemIPE['BatchNo'] == _batch_Controller.text.trim()) {
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
        _textselection(_thickness_Controller);

        setState(() {});
        EasyLoading.showSuccess("No data in Pda");
      }
    } catch (e, s) {
      EasyLoading.showError('$e', duration: Duration(seconds: 3));

      print(s);
    }
  }

  _setValueController(List<WindingRecordModelSqlite> temp, String ipe,
      String startTime, String endTime) async {
    for (var items in temp) {
      _startTime_Controller.text =
          (startTime.isEmpty ? items.START_TIME : startTime) ?? "";
      _finishTime_Controller.text =
          (endTime.isEmpty ? items.FINISH_TIME : endTime) ?? "";
      if (items.IPE_NO != null) {
        _ipeNo_Controller.text = items.IPE_NO.toString();
      } else {
        _ipeNo_Controller.text = ipe.isEmpty ? _tempIPE_Controller.text : ipe;
      }

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

  _textselection(TextEditingController text) {
    Future.delayed(Duration(microseconds: 500), () {
      text.selection =
          TextSelection(baseOffset: 0, extentOffset: text.text.length);
    });
  }

  _funcSave() async {
    var loadDataSend = await DatabaseHelper().queryWindingRecodeFormPda(
        'WINDING_RECORD_SEND_SERVER', [_batch_Controller.text.trim()]);
    if (loadDataSend.isEmpty) {
      await DatabaseHelper().insertRecordDB('WINDING_RECORD_SEND_SERVER', {
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
    String? startTime;
    String? finishTime;
    try {
      startTime = DateFormat('HH:mm:ss').format(DateTime.parse(
          items.START_DATE ?? items.START_TIME ?? DateTime.now().toString()));
      if (items.FINISH_TIME != null) {
        finishTime = DateFormat('HH:mm:ss').format(DateTime.parse(
            items.END_DATE ?? items.FINISH_TIME ?? DateTime.now().toString()));
      } else {
        finishTime = '';
      }
    } catch (e) {
      DateTime dateTime = DateFormat('M/d/yyyy h:mm:ss a').parse(
          items.START_TIME ?? items.START_DATE ?? DateTime.now().toString());
      if (items.FINISH_TIME != null) {
        DateTime dateTime2 = DateFormat('M/d/yyyy h:mm:ss a').parse(
            items.FINISH_TIME ?? items.END_DATE ?? DateTime.now().toString());
        finishTime = DateFormat('HH:mm:ss').format(dateTime2);
      } else {
        finishTime = '';
      }

      startTime = DateFormat('HH:mm:ss').format(dateTime);
    }

    _batch_Controller.text = items.BATCH_NO.toString();
    _startTime_Controller.text = startTime;
    _finishTime_Controller.text = finishTime;
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

  Future _setValuesControllerOffline() async {
    try {
      var loadDataSend = await DatabaseHelper().queryWindingRecodeFormPda(
          'WINDING_RECORD_SEND_SERVER', [_batch_Controller.text.trim()]);
      if (loadDataSend.isNotEmpty) {
        List<WindingRecordModelSqlite> temps = [];
        temps = loadDataSend
            .map((e) => WindingRecordModelSqlite.fromMap(e))
            .toList();
        for (var items in temps) {
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
          _width_L__Controller.text = items.WIDTH_L.toString();
          _width_R__Controller.text = items.WIDHT_R.toString();
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
          _burnOff_Controller.text = items.BURN_OFF.toString();
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
        setState(() {});
      } else {
        _errorDialog(
            text: Label("No data In PDA"),
            isHideCancle: false,
            onpressOk: () async {
              Navigator.pop(context);
              _clearController();
            });
      }
    } catch (e) {
      EasyLoading.showError("$e", duration: Duration(seconds: 3));
    }
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
      START_TIME: DateFormat('dd/MM/yyyy hh:mm:ss a').format(DateTime.now()),
      FINISH_TIME: _finishTime_Controller.text,
      OUTPUT: _output_Controller.text.isNotEmpty
          ? int.tryParse(_output_Controller.text)
          : null,
      IPE_NO: _ipeNo_Controller.text.isNotEmpty
          ? int.tryParse(_ipeNo_Controller.text)
          : null,
      THICKNESS: _thickness_Controller.text.trim(),
      PACK_NO: _packno_Controller.text.trim(),
      PPM_WEIGHT: _ppmweight_Controller.text.isNotEmpty
          ? num.tryParse(_ppmweight_Controller.text)
          : null,
      TURN: _turn_Controller.text.isNotEmpty
          ? int.tryParse(_turn_Controller.text)
          : null,
      DIAMETER: _diameter_Controller.text.isNotEmpty
          ? num.tryParse(_diameter_Controller.text)
          : null,
      CUSTOMER: _custommer_Controller.text.trim(),
      UF: _uf_Controller.text.isNotEmpty
          ? num.tryParse(_uf_Controller.text)
          : null,
      GROSS: _gross_Controller.text.isNotEmpty
          ? num.tryParse(_gross_Controller.text)
          : null,
      WIDTHL: _width_L__Controller.text.isNotEmpty
          ? num.tryParse(_width_L__Controller.text)
          : null,
      WIDTHR: _width_R__Controller.text.isNotEmpty
          ? num.tryParse(_width_R__Controller.text)
          : null,
      CB11: _cb11_Controller.text.isNotEmpty
          ? num.tryParse(_cb11_Controller.text)
          : null,
      CB12: _cb12_Controller.text.isNotEmpty
          ? num.tryParse(_cb12_Controller.text)
          : null,
      CB13: _cb13_Controller.text.isNotEmpty
          ? num.tryParse(_cb13_Controller.text)
          : null,
      CB21: _cb21_Controller.text.isNotEmpty
          ? num.tryParse(_cb21_Controller.text)
          : null,
      CB22: _cb22_Controller.text.isNotEmpty
          ? num.tryParse(_cb22_Controller.text)
          : null,
      CB23: _cb23_Controller.text.isNotEmpty
          ? num.tryParse(_cb23_Controller.text)
          : null,
      CB31: _cb31_Controller.text.isNotEmpty
          ? num.tryParse(_cb31_Controller.text)
          : null,
      CB32: _cb32_Controller.text.isNotEmpty
          ? num.tryParse(_cb32_Controller.text)
          : null,
      CB33: _cb33_Controller.text.isNotEmpty
          ? num.tryParse(_cb33_Controller.text)
          : null,
      OF1: _of1_Controller.text.isNotEmpty
          ? num.tryParse(_of1_Controller.text)
          : null,
      OF2: _of2_Controller.text.isNotEmpty
          ? num.tryParse(_of2_Controller.text)
          : null,
      OF3: _of3_Controller.text.isNotEmpty
          ? num.tryParse(_of3_Controller.text)
          : null,
      BURNOFF: _burnOff_Controller.text.isNotEmpty
          ? num.tryParse(_burnOff_Controller.text)
          : null,
      FS1: _fs1_Controller.text.isNotEmpty
          ? num.tryParse(_fs1_Controller.text)
          : null,
      FS2: _fs2_Controller.text.isNotEmpty
          ? num.tryParse(_fs2_Controller.text)
          : null,
      FS3: _fs3_Controller.text.isNotEmpty
          ? num.tryParse(_fs3_Controller.text)
          : null,
      FS4: _fs4_Controller.text.isNotEmpty
          ? num.tryParse(_fs4_Controller.text)
          : null,
      GRADE: _grade_Controller.text.trim(),
      TIME_PRESS: _time_Press_Controller.text.isNotEmpty
          ? num.tryParse(_time_Press_Controller.text)
          : null,
      TIME_RELEASED: _time_Released_Controller.text.isNotEmpty
          ? num.tryParse(_time_Released_Controller.text)
          : null,
      HEAT_TEMP: _heat_temp_Controller.text.isNotEmpty
          ? num.tryParse(_heat_temp_Controller.text)
          : null,
      TENSION: _tension_Controller.text.isNotEmpty
          ? int.tryParse(_tension_Controller.text)
          : null,
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
            EasyLoading.dismiss();
            if (state.item.MESSAGE != null || state.item.MESSAGE != '') {
              EasyLoading.showInfo(state.item.MESSAGE ?? "Success");
            }

            if (state.item.MESSAGE == 'No data in WindingRecord') {
              _startTime_Controller.text = DateFormat('HH:mm:ss').format(
                  DateTime.parse(state.item.START_TIME ??
                      state.item.START_DATE ??
                      DateTime.now().toString()));
              _ipeNo_Controller.text = state.item.IPE_NO.toString();
              _tempIPE_Controller.text = state.item.IPE_NO.toString();
              if (state.item.FINISH_TIME != null ||
                  state.item.END_DATE != null) {
                _finishTime_Controller.text = DateFormat('HH:mm:ss').format(
                    DateTime.parse(state.item.FINISH_TIME ??
                        state.item.END_DATE ??
                        DateTime.now().toString()));
              } else {
                _finishTime_Controller.text = '';
              }

              _ppmweight_Controller.text = state.item.PPM_WEIGHT.toString();
              _packno_Controller.text = state.item.PACK_NO.toString();
              _output_Controller.text = state.item.OUTPUT.toString();
              var loadDataSend = await DatabaseHelper()
                  .queryWindingRecodeFormPda('WINDING_RECORD_SEND_SERVER',
                      [_batch_Controller.text.trim()]);
              if (loadDataSend.isNotEmpty) {
                List<WindingRecordModelSqlite> temp = [];
                temp = loadDataSend
                    .map((e) => WindingRecordModelSqlite.fromMap(e))
                    .toList();
                for (var items in temp) {
                  _thickness_Controller.text = items.THICKNESS.toString();
                  _turn_Controller.text = items.TURN.toString();
                  _diameter_Controller.text = items.DIAMETER.toString();
                  _custommer_Controller.text = items.CUSTOMER.toString();
                  _uf_Controller.text = items.UF.toString();
                  _width_L__Controller.text = items.WIDTH_L.toString();
                  _width_R__Controller.text = items.WIDHT_R.toString();
                  _gross_Controller.text = items.GROSS.toString();
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
                  _burnOff_Controller.text = items.BURN_OFF.toString();
                  _fs1_Controller.text = items.FS1.toString();
                  _fs2_Controller.text = items.FS2.toString();
                  _fs3_Controller.text = items.FS3.toString();
                  _fs4_Controller.text = items.FS4.toString();
                  _grade_Controller.text = items.GRADE.toString();
                  _time_Press_Controller.text = items.TIME_PRESS.toString();
                  _time_Released_Controller.text =
                      items.TIME_RELEASED.toString();
                  _heat_temp_Controller.text = items.HEAT_TEMP.toString();
                  _tension_Controller.text = items.TENSION.toString();
                  _nip_roll_press_Controller.text = items.NIP_ROLL_PRESS ?? "";
                }

                EasyLoading.showSuccess("Load Data Success");
              }
              // if(PDA HAS DATA KEYIN) SETVALUES
              // await _getDataRecordFormPDA();
              setState(() {});

              EasyLoading.showInfo("${state.item.MESSAGE}");
              EasyLoading.dismiss();
              _thickness_FocusNode.requestFocus();
              _textselection(_thickness_Controller);
            } else if (state.item.MESSAGE == 'No data in WINDING_SHEET') {
              EasyLoading.showInfo("${state.item.MESSAGE}");
              await _getDataRecordFormPDA();
              _thickness_FocusNode.requestFocus();
            } else if (state.item.RESULT == true &&
                state.item.MESSAGE == null) {
              String? startTime;
              String? finishTime;
              String currentTime = DateTime.now().toString();
              try {
                startTime = DateFormat('HH:mm:ss').format(
                    DateTime.parse(state.item.START_DATE ?? currentTime));
                if (state.item.END_DATE != null) {
                  finishTime = DateFormat('HH:mm:ss').format(DateTime.parse(
                      state.item.END_DATE ?? DateTime.now().toString()));
                } else if (state.item.FINISH_TIME != null) {
                  DateTime dateTime = DateFormat('M/d/yyyy h:mm:ss a').parse(
                      state.item.FINISH_TIME ?? DateTime.now().toString());

                  finishTime = DateFormat('HH:mm:ss').format(dateTime);
                } else {
                  _finishTime_Controller.text = '';
                }
              } catch (e, s) {
                print(e);
                print(s);

                DateTime dateTime = DateFormat('M/d/yyyy h:mm:ss a').parse(
                    state.item.START_TIME ??
                        state.item.START_DATE ??
                        DateTime.now().toString());

                startTime = DateFormat('HH:mm:ss').format(dateTime);
                if (state.item.END_DATE != null) {
                  DateTime dateTime2 = DateFormat('M/d/yyyy HH:mm:ss a')
                      .parse(state.item.END_DATE ?? DateTime.now().toString());
                  finishTime = DateFormat('HH:mm:ss').format(dateTime2);
                } else {
                  _finishTime_Controller.text = '';
                }
              }

              EasyLoading.dismiss();
              itemWindingRecord = state.item;
              var loadDataSend = await DatabaseHelper()
                  .queryWindingRecodeFormPda('WINDING_RECORD_SEND_SERVER',
                      [_batch_Controller.text.trim()]);
              if (loadDataSend.isNotEmpty) {
                List<WindingRecordModelSqlite> temp = [];
                temp = loadDataSend
                    .map((e) => WindingRecordModelSqlite.fromMap(e))
                    .toList();
                for (var items in temp) {
                  _startTime_Controller.text = items.START_TIME == ''
                      ? startTime
                      : items.START_TIME ?? "";
                  _finishTime_Controller.text =
                      finishTime ?? items.FINISH_TIME ?? "";
                  _ipeNo_Controller.text = items.IPE_NO == ''
                      ? state.item.IPE_NO.toString()
                      : items.IPE_NO ?? "";
                  _ppmweight_Controller.text = items.PPM_WEIGHT == ''
                      ? state.item.PPM_WEIGHT.toString()
                      : items.PPM_WEIGHT ?? "";
                  _packno_Controller.text = items.PACK_NO == ''
                      ? state.item.PACK_NO ?? ""
                      : items.PACK_NO ?? "";
                  _output_Controller.text = items.OUTPUT == null ||
                          items.OUTPUT == 'null' ||
                          items.OUTPUT == ''
                      ? state.item.OUTPUT.toString()
                      : items.OUTPUT ?? "";
                  _thickness_Controller.text = items.THICKNESS == ''
                      ? state.item.THICKNESS ?? ""
                      : items.THICKNESS ?? "";
                  _turn_Controller.text = items.TURN == ''
                      ? state.item.TURN.toString()
                      : items.TURN ?? "";
                  _diameter_Controller.text = items.DIAMETER == ''
                      ? state.item.DIAMETER.toString()
                      : items.DIAMETER ?? "";
                  _custommer_Controller.text = items.CUSTOMER == ''
                      ? state.item.CUSTOMER ?? ""
                      : items.CUSTOMER ?? "";
                  _uf_Controller.text = items.UF == ''
                      ? state.item.UF.toString()
                      : items.UF ?? "";
                  _width_L__Controller.text = items.WIDTH_L == ''
                      ? state.item.WIDTHL.toString()
                      : items.WIDTH_L ?? "";
                  _width_R__Controller.text = items.WIDHT_R == ''
                      ? state.item.WIDTHR.toString()
                      : items.WIDHT_R ?? "";
                  _gross_Controller.text = items.GROSS == ''
                      ? state.item.GROSS.toString()
                      : items.GROSS ?? "";
                  _cb11_Controller.text = items.CB11 == ''
                      ? state.item.CB11.toString()
                      : items.CB11 ?? "";
                  _cb12_Controller.text = items.CB12 == ''
                      ? state.item.CB12.toString()
                      : items.CB12 ?? "";
                  _cb13_Controller.text = items.CB13 == ''
                      ? state.item.CB13.toString()
                      : items.CB13 ?? "";
                  _cb21_Controller.text = items.CB21 == ''
                      ? state.item.CB21.toString()
                      : items.CB21 ?? "";
                  _cb22_Controller.text = items.CB22 == ''
                      ? state.item.CB22.toString()
                      : items.CB22 ?? "";
                  _cb23_Controller.text = items.CB23 == ''
                      ? state.item.CB23.toString()
                      : items.CB23 ?? "";
                  _cb31_Controller.text = items.CB31 == ''
                      ? state.item.CB31.toString()
                      : items.CB31 ?? "";
                  _cb32_Controller.text = items.CB32 == ''
                      ? state.item.CB32.toString()
                      : items.CB32 ?? "";
                  _cb33_Controller.text = items.CB33 == ''
                      ? state.item.CB33.toString()
                      : items.CB33 ?? "";
                  _of1_Controller.text = items.OF1 == ''
                      ? state.item.OF1.toString()
                      : items.OF1 ?? "";
                  _of2_Controller.text = items.OF2 == ''
                      ? state.item.OF2.toString()
                      : items.OF2 ?? "";
                  _of3_Controller.text = items.OF3 == ''
                      ? state.item.OF3.toString()
                      : items.OF3 ?? "";
                  _burnOff_Controller.text = items.BURN_OFF == ''
                      ? state.item.BURNOFF.toString()
                      : items.BURN_OFF ?? "";
                  _fs1_Controller.text = items.FS1 == ''
                      ? state.item.FS1.toString()
                      : items.FS1 ?? "";
                  _fs2_Controller.text = items.FS2 == ''
                      ? state.item.FS2.toString()
                      : items.FS2 ?? "";
                  _fs3_Controller.text = items.FS3 == ''
                      ? state.item.FS3.toString()
                      : items.FS3 ?? "";
                  _fs4_Controller.text = items.FS4 == ''
                      ? state.item.FS4.toString()
                      : items.FS4 ?? "";
                  _grade_Controller.text = items.GRADE == ''
                      ? state.item.GRADE ?? ""
                      : items.GRADE ?? "";
                  _time_Press_Controller.text = items.TIME_PRESS == ''
                      ? state.item.TIME_PRESS.toString()
                      : items.TIME_PRESS ?? "";
                  _time_Released_Controller.text =
                      items.TIME_RELEASED.toString();
                  _heat_temp_Controller.text = items.HEAT_TEMP == ''
                      ? state.item.HEAT_TEMP.toString()
                      : items.HEAT_TEMP ?? "";
                  _tension_Controller.text = items.TENSION == ''
                      ? state.item.TENSION.toString()
                      : items.TENSION ?? "";
                  _nip_roll_press_Controller.text = items.NIP_ROLL_PRESS == ''
                      ? state.item.NIP_ROLL_PRESS ?? ""
                      : items.NIP_ROLL_PRESS ?? "";
                }
              } else {
                _getValuesFromServer(itemWindingRecord);
              }

              _thickness_FocusNode.requestFocus();
              _textselection(_thickness_Controller);
              setState(() {});
            }
          } else if (state is GetWindingRecordErrorState) {
            EasyLoading.dismiss();
            await _setValuesControllerOffline();
            _thickness_FocusNode.requestFocus();
            _textselection(_thickness_Controller);
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
            EasyLoading.show(status: "Loading ...");
          } else if (state is SendWindingRecordLoadedState) {
            if (state.item.RESULT == true) {
              await checkConditionIsNotEmtpy();
              EasyLoading.dismiss();
              _batch_Controller.clear();
              _clearController();
              _batch_FocusNode.requestFocus();
              _custommer_Controller.clear();
              EasyLoading.showSuccess("Send Success!");
              await _getHold();
            } else {
              EasyLoading.showError("${state.item.MESSAGE}");
              _batch_Controller.clear();
              _clearController();
              _batch_FocusNode.requestFocus();
            }
          } else if (state is SendWindingRecordErrorState) {
            EasyLoading.showError("Please Check Connection");
            // _errorDialog(
            //     text: Label(
            //         "Please Check Connection Internet \n Do you want to save data"),
            //     onpressOk: () async {
            //       await _funcSave();
            //       await _getHold();

            //       Navigator.pop(context);
            //     });
          }
        }),
      ],
      child: Form(
        key: _formKey,
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
                                return null;
                              } else if (value == null || value.length != 12) {
                                return 'Please input batch 12 digit';
                              }
                              return null;
                            },
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'))
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
                            readOnly: true,
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
                            readOnly: true,
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
                            readOnly: true,
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
                            keyboardType:
                                TextInputType.number, // รับค่าเป็นข้อความ
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(RegExp(
                                  r'^[\d\s-]*\.?\d{0,1}-?[\d\s-]*\.?\d{0,2}')),
                            ],
                            isHideLable: true,
                            labelText: "Thickness".toUpperCase(),
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _turn_FocusNode.requestFocus();
                                _textselection(_turn_Controller);
                              }
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
                                _textselection(_diameter_Controller);
                              } else {
                                _turn_FocusNode.requestFocus();
                              }
                            },
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'))
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
                                  RegExp(r'^\d+\.?\d{0,1}')),
                            ],
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _custommer_FocusNode.requestFocus();
                              } else {
                                _diameter_FocusNode.requestFocus();
                              }
                            },
                            validator: (value) {
                              try {
                                double parsedValue = double.parse(value!);

                                // แยกส่วนทศนิยม
                                String fractionalPart =
                                    parsedValue.toString().split(".")[1];
                                if (fractionalPart.length > 1) {
                                  return "decimal value with only 1 digit";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                // หากไม่สามารถแปลงเป็นทศนิยมได้
                                return null;
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
                                            fontSize: 14,
                                            color: COLOR_BLUE_DARK),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              _custommer_Controller.text = value!;
                              _uf_FocusNode.requestFocus();
                              _textselection(_uf_Controller);
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
                                  RegExp(r'^\d+\.?\d{0,1}')),
                            ],
                            isHideLable: true,
                            labelText: "uf".toUpperCase(),
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _width_R__FocusNode.requestFocus();
                                _textselection(_width_R__Controller);
                              } else {
                                _uf_FocusNode.requestFocus();
                              }
                            },
                            validator: (value) {
                              try {
                                double parsedValue = double.parse(value!);

                                // แยกส่วนทศนิยม
                                String fractionalPart =
                                    parsedValue.toString().split(".")[1];
                                if (fractionalPart.length > 1) {
                                  return "decimal value with only 1 digit";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                // หากไม่สามารถแปลงเป็นทศนิยมได้
                                return null;
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
                              readOnly: true,
                              labelText: "PPMWeight".toUpperCase(),
                              onFieldSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  _packno_FocusNode.requestFocus();
                                  _textselection(_ppmweight_Controller);
                                }
                              }),
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
                              readOnly: true,
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
                              readOnly: true,
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
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            onFieldSubmitted: (p0) {
                              if (p0.isNotEmpty) {
                                _width_L__FocusNode.requestFocus();
                                _textselection(_width_L__Controller);
                              }
                            },
                            validator: (value) {
                              try {
                                double parsedValue = double.parse(value!);

                                // แยกส่วนทศนิยม
                                String fractionalPart =
                                    parsedValue.toString().split(".")[1];
                                if (fractionalPart.length > 2) {
                                  return "decimal value with only 2 digit";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                // หากไม่สามารถแปลงเป็นทศนิยมได้
                                return null;
                              }
                            },
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
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _gross_FocusNode.requestFocus();
                                _textselection(_gross_Controller);
                              }
                            },
                            validator: (value) {
                              try {
                                double parsedValue = double.parse(value!);

                                // แยกส่วนทศนิยม
                                String fractionalPart =
                                    parsedValue.toString().split(".")[1];
                                if (fractionalPart.length > 2) {
                                  return "decimal value with only 2 digit";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                // หากไม่สามารถแปลงเป็นทศนิยมได้
                                return null;
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
                              focusNode: _gross_FocusNode,
                              controller: _gross_Controller,
                              isHideLable: true,
                              labelText: "GROSS WT",
                              onFieldSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  _cb11_FocusNode.requestFocus();
                                  _textselection(_cb11_Controller);
                                }
                              }),
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
                                  RegExp(r'^\d+\.?\d{0,1}')),
                            ],
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _cb12_FocusNode.requestFocus();
                                _textselection(_cb12_Controller);
                              }
                            },
                            validator: (value) {
                              try {
                                double parsedValue = double.parse(value!);

                                // แยกส่วนทศนิยม
                                String fractionalPart =
                                    parsedValue.toString().split(".")[1];
                                if (fractionalPart.length > 1) {
                                  return "decimal value with only 1 digit";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                // หากไม่สามารถแปลงเป็นทศนิยมได้
                                return null;
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
                            controller: _cb12_Controller,
                            focusNode: _cb12_FocusNode,
                            isHideLable: true,
                            labelText: "CB12",
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,1}')),
                            ],
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _cb13_FocusNode.requestFocus();
                                _textselection(_cb13_Controller);
                              }
                            },
                            validator: (value) {
                              try {
                                double parsedValue = double.parse(value!);

                                // แยกส่วนทศนิยม
                                String fractionalPart =
                                    parsedValue.toString().split(".")[1];
                                if (fractionalPart.length > 1) {
                                  return "decimal value with only 1 digit";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                // หากไม่สามารถแปลงเป็นทศนิยมได้
                                return null;
                              }
                            },
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
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,1}')),
                            ],
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _cb21_FocusNode.requestFocus();
                                _textselection(_cb21_Controller);
                              }
                            },
                            validator: (value) {
                              try {
                                double parsedValue = double.parse(value!);

                                // แยกส่วนทศนิยม
                                String fractionalPart =
                                    parsedValue.toString().split(".")[1];
                                if (fractionalPart.length > 1) {
                                  return "decimal value with only 1 digit";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                // หากไม่สามารถแปลงเป็นทศนิยมได้
                                return null;
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
                            controller: _cb21_Controller,
                            focusNode: _cb21_FocusNode,
                            isHideLable: true,
                            labelText: "CB21",
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,1}')),
                            ],
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _cb22_FocusNode.requestFocus();
                                _textselection(_cb22_Controller);
                              }
                            },
                            validator: (value) {
                              try {
                                double parsedValue = double.parse(value!);

                                // แยกส่วนทศนิยม
                                String fractionalPart =
                                    parsedValue.toString().split(".")[1];
                                if (fractionalPart.length > 1) {
                                  return "decimal value with only 1 digit";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                // หากไม่สามารถแปลงเป็นทศนิยมได้
                                return null;
                              }
                            },
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
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,1}')),
                            ],
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _cb23_FocusNode.requestFocus();
                                _textselection(_cb23_Controller);
                              }
                            },
                            validator: (value) {
                              try {
                                double parsedValue = double.parse(value!);

                                // แยกส่วนทศนิยม
                                String fractionalPart =
                                    parsedValue.toString().split(".")[1];
                                if (fractionalPart.length > 1) {
                                  return "decimal value with only 1 digit";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                // หากไม่สามารถแปลงเป็นทศนิยมได้
                                return null;
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
                            controller: _cb23_Controller,
                            focusNode: _cb23_FocusNode,
                            isHideLable: true,
                            labelText: "CB23",
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,1}')),
                            ],
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _cb31_FocusNode.requestFocus();
                                _textselection(_cb31_Controller);
                              }
                            },
                            validator: (value) {
                              try {
                                double parsedValue = double.parse(value!);

                                // แยกส่วนทศนิยม
                                String fractionalPart =
                                    parsedValue.toString().split(".")[1];
                                if (fractionalPart.length > 1) {
                                  return "decimal value with only 1 digit";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                // หากไม่สามารถแปลงเป็นทศนิยมได้
                                return null;
                              }
                            },
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
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,1}')),
                            ],
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _cb32_FocusNode.requestFocus();
                                _textselection(_cb32_Controller);
                              }
                            },
                            validator: (value) {
                              try {
                                double parsedValue = double.parse(value!);

                                // แยกส่วนทศนิยม
                                String fractionalPart =
                                    parsedValue.toString().split(".")[1];
                                if (fractionalPart.length > 1) {
                                  return "decimal value with only 1 digit";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                // หากไม่สามารถแปลงเป็นทศนิยมได้
                                return null;
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
                            controller: _cb32_Controller,
                            focusNode: _cb32_FocusNode,
                            isHideLable: true,
                            labelText: "CB32",
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,1}')),
                            ],
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _cb33_FocusNode.requestFocus();
                                _textselection(_cb33_Controller);
                              }
                            },
                            validator: (value) {
                              try {
                                double parsedValue = double.parse(value!);

                                // แยกส่วนทศนิยม
                                String fractionalPart =
                                    parsedValue.toString().split(".")[1];
                                if (fractionalPart.length > 1) {
                                  return "decimal value with only 1 digit";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                // หากไม่สามารถแปลงเป็นทศนิยมได้
                                return null;
                              }
                            },
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
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,1}')),
                            ],
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _of1_FocusNode.requestFocus();
                                _textselection(_of1_Controller);
                              }
                            },
                            validator: (value) {
                              try {
                                double parsedValue = double.parse(value!);

                                // แยกส่วนทศนิยม
                                String fractionalPart =
                                    parsedValue.toString().split(".")[1];
                                if (fractionalPart.length > 1) {
                                  return "decimal value with only 1 digit";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                // หากไม่สามารถแปลงเป็นทศนิยมได้
                                return null;
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
                            controller: _of1_Controller,
                            focusNode: _of1_FocusNode,
                            isHideLable: true,
                            labelText: "OF1",
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _of2_FocusNode.requestFocus();
                                _textselection(_of2_Controller);
                              }
                            },
                            validator: (value) {
                              try {
                                double? of1Values = double.tryParse(value!);
                                if (of1Values! < 1.50 || of1Values > 2.0) {
                                  return "Value 1.50 - 2.00 !";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                return null;
                              }
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
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            validator: (value) {
                              try {
                                double? of1Values = double.tryParse(value!);
                                if (of1Values! < 1.50 || of1Values > 2.0) {
                                  return "Value 1.50 - 2.00 !";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                return null;
                              }
                            },
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _of3_FocusNode.requestFocus();
                                _textselection(_of3_Controller);
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
                            controller: _of3_Controller,
                            focusNode: _of3_FocusNode,
                            isHideLable: true,
                            labelText: "OF3",
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            validator: (value) {
                              try {
                                double? of1Values = double.tryParse(value!);
                                if (of1Values! < 1.50 || of1Values > 2.0) {
                                  return "Value 1.50 - 2.00 !";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                return null;
                              }
                            },
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _burnOff_FocusNode.requestFocus();
                                _textselection(_burnOff_Controller);
                              }
                            },
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
                            maxLength: 2,
                            keyboardType: TextInputType.number,
                            labelText: "BURN OFF",
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            validator: (value) {
                              try {
                                int? of1Values = int.tryParse(value!);
                                if (of1Values! < 27 || of1Values > 38) {
                                  return 'Value 27-38 !';
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                return null;
                              }
                            },
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _fs1_FocusNode.requestFocus();
                                _textselection(_fs1_Controller);
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
                            controller: _fs1_Controller,
                            focusNode: _fs1_FocusNode,
                            isHideLable: true,
                            labelText: "FS1",
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            validator: (value) {
                              try {
                                double parsedValue = double.parse(value!);

                                // แยกส่วนทศนิยม
                                String fractionalPart =
                                    parsedValue.toString().split(".")[1];
                                if (fractionalPart.length > 2) {
                                  return "decimal value with only 2 digit";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                // หากไม่สามารถแปลงเป็นทศนิยมได้
                                return null;
                              }
                            },
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _fs2_FocusNode.requestFocus();
                                _textselection(_fs2_Controller);
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
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            validator: (value) {
                              try {
                                double parsedValue = double.parse(value!);

                                // แยกส่วนทศนิยม
                                String fractionalPart =
                                    parsedValue.toString().split(".")[1];
                                if (fractionalPart.length > 2) {
                                  return "decimal value with only 2 digit";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                // หากไม่สามารถแปลงเป็นทศนิยมได้
                                return null;
                              }
                            },
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _fs3_FocusNode.requestFocus();
                                _textselection(_fs3_Controller);
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
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            validator: (value) {
                              try {
                                double parsedValue = double.parse(value!);

                                // แยกส่วนทศนิยม
                                String fractionalPart =
                                    parsedValue.toString().split(".")[1];
                                if (fractionalPart.length > 2) {
                                  return "decimal value with only 2 digit";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                // หากไม่สามารถแปลงเป็นทศนิยมได้
                                return null;
                              }
                            },
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _fs4_FocusNode.requestFocus();
                                _textselection(_fs4_Controller);
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
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            validator: (value) {
                              try {
                                double parsedValue = double.parse(value!);

                                // แยกส่วนทศนิยม
                                String fractionalPart =
                                    parsedValue.toString().split(".")[1];
                                if (fractionalPart.length > 2) {
                                  return "decimal value with only 2 digit";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                // หากไม่สามารถแปลงเป็นทศนิยมได้
                                return null;
                              }
                            },
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _grade_FocusNode.requestFocus();
                                _textselection(_grade_Controller);
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
                            // validator: (p0) {
                            //   if (p0 != null) {
                            //     if (p0.isEmpty) {
                            //       return "Please Entry Value";
                            //     }
                            //   }
                            //   return null;
                            // },
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _time_Press_FocusNode.requestFocus();
                                _textselection(_time_Press_Controller);
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
                                  RegExp(r'^\d+\.?\d{0,1}')),
                            ],
                            validator: (value) {
                              try {
                                double? of1Values = double.tryParse(value!);
                                if (of1Values! < 0.1 || of1Values > 0.9) {
                                  return "Value 0.1 - 0.9 !";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                return null;
                              }
                            },
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _time_Released_FocusNode.requestFocus();
                                _textselection(_time_Released_Controller);
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
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _heat_temp_FocusNode.requestFocus();
                                _textselection(_heat_temp_Controller);
                              } else {
                                _time_Released_FocusNode.requestFocus();
                              }
                            },
                            validator: (value) {
                              try {
                                double parsedValue = double.parse(value!);

                                // แยกส่วนทศนิยม
                                String fractionalPart =
                                    parsedValue.toString().split(".")[1];
                                if (fractionalPart.length > 2) {
                                  return "decimal value with only 2 digit";
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                // หากไม่สามารถแปลงเป็นทศนิยมได้
                                return null;
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
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]')),
                            ],
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _tension_FocusNode.requestFocus();
                                _textselection(_tension_Controller);
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
                            keyboardType: TextInputType.number,
                            isHideLable: true,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]')),
                            ],
                            labelText: "WINDING TENSION",
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _nip_roll_press_FocusNode.requestFocus();
                                _textselection(_nip_roll_press_Controller);
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
                            maxLength: 10,
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
                                if (_batch_Controller.text.isNotEmpty) {
                                  await _sendApi();
                                } else {
                                  _batch_FocusNode.requestFocus();
                                }
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
      ),
    );
  }

  void _errorDialog(
      {Label? text,
      Function? onpressOk,
      Function? onpressCancel,
      bool isHideCancle = true}) async {
    // EasyLoading.showError("Error[03]", duration: Duration(seconds: 5));//if password
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('AlertDialog Title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: text,
            ),
          ],
        ),

        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: isHideCancle,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(COLOR_BLUE_DARK)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              Visibility(
                visible: isHideCancle,
                child: SizedBox(
                  width: 15,
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(COLOR_BLUE_DARK)),
                onPressed: () => onpressOk?.call(),
                child: const Text('OK'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future checkConditionIsNotEmtpy() async {
    if (_batch_Controller.text.isNotEmpty) {
      if (_thickness_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_turn_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_diameter_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_custommer_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_uf_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_width_R__Controller.text.isEmpty) {
        await _funcSave();
      } else if (_width_L__Controller.text.isEmpty) {
        await _funcSave();
      } else if (_gross_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_cb11_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_cb12_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_cb13_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_cb21_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_cb22_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_cb23_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_cb31_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_cb32_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_cb33_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_of1_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_of2_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_of3_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_burnOff_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_fs1_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_fs2_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_fs3_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_fs4_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_grade_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_time_Press_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_time_Released_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_heat_temp_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_tension_Controller.text.isEmpty) {
        await _funcSave();
      } else if (_nip_roll_press_Controller.text.isEmpty) {
        await _funcSave();
      } else {
        await DatabaseHelper().deleteRecordDB(
            'WINDING_RECORD_SEND_SERVER', [_batch_Controller.text.trim()]);
        await _getHold();
      }
    }
  }
}
