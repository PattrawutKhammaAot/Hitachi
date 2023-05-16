import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/filmReceive/film_receive_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/filmReceiveModel/filmreceiveOutputModel.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class FilmReceiveScanScreen extends StatefulWidget {
  const FilmReceiveScanScreen({super.key});

  @override
  State<FilmReceiveScanScreen> createState() => _FilmReceiveScanScreenState();
}

class _FilmReceiveScanScreenState extends State<FilmReceiveScanScreen> {
  final TextEditingController _poNoController = TextEditingController();
  final TextEditingController _InvoiceNoController = TextEditingController();
  final TextEditingController _freightController = TextEditingController();
  final TextEditingController _IncomingDateController = TextEditingController();
  final TextEditingController _storeByController = TextEditingController();
  final TextEditingController _packNoController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();
  final TextEditingController _barCode1Controller = TextEditingController();
  final TextEditingController _barCode2Controller = TextEditingController();
  final TextEditingController _weight1Controller = TextEditingController();
  final TextEditingController _weight2Controller = TextEditingController();
  final TextEditingController _mfgDateController = TextEditingController();
  final TextEditingController _wrapGradeController = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();
  DateTime? _selectedDate;
  DateTime? _selectedDateMfg;
  String? dataFromBarcode1;

  List<String> itemList = ['sea', 'air'];

  void _checkValueController() {
    if (_poNoController.text.isNotEmpty &&
        _InvoiceNoController.text.isNotEmpty &&
        _freightController.text.isNotEmpty &&
        _IncomingDateController.text.isNotEmpty &&
        _storeByController.text.isNotEmpty &&
        _packNoController.text.isNotEmpty &&
        _rollNoController.text.isNotEmpty &&
        _barCode1Controller.text.isNotEmpty &&
        _barCode2Controller.text.isNotEmpty &&
        _weight1Controller.text.isNotEmpty &&
        _weight2Controller.text.isNotEmpty &&
        _mfgDateController.text.isNotEmpty &&
        _wrapGradeController.text.isNotEmpty) {}

    _sendData();
  }

  callFilmIn() async {
    switch (_wrapGradeController.text.trim()) {
      case "1":
        setState(() {
          _wrapGradeController.text = "A";
        });
        break;
      case "2":
        setState(() {
          _wrapGradeController.text = "B";
        });
        break;
      case "3":
        setState(() {
          _wrapGradeController.text = "C";
        });
        break;
      case "4":
        setState(() {
          _wrapGradeController.text = "D";
        });
        break;
      case "5":
        setState(() {
          _wrapGradeController.text = "E";
        });
        break;
      case "6":
        setState(() {
          _wrapGradeController.text = "F";
        });
        break;
      case "7":
        setState(() {
          _wrapGradeController.text = "G";
        });
        break;
      case "8":
        setState(() {
          _wrapGradeController.text = "H";
        });
        break;
      case "9":
        setState(() {
          _wrapGradeController.text = "I";
        });
        break;
      case "0":
        setState(() {
          _wrapGradeController.text = "J";
        });
        break;
      default:
        // กรณีไม่ตรงกับ case ใด ๆ ให้ไม่ทำอะไร
        break;
    }
    try {
      String? thickness;
      var sql = await databaseHelper.queryDataSelect(
          select1: 'PACK_NO',
          formTable: 'DATA_SHEET',
          where: 'PACK_NO',
          stringValue: _packNoController.text.trim());
      num? totalWeight;
      setState(() {
        num weight1 = num.tryParse(_weight1Controller.text.trim()) ?? 0;
        num weight2 = num.tryParse(_weight2Controller.text.trim()) ?? 0;
        totalWeight = weight1 + weight2;
        thickness = _packNoController.text.substring(0, 1);
      });
      if (sql.length <= 0) {
        await databaseHelper.insertSqlite('DATA_SHEET', {
          'PO_NO': _poNoController.text.trim(),
          'INVOICE': _InvoiceNoController.text.trim(),
          'FRIEGHT': _freightController.text.trim(),
          'INCOMING_DATE': _IncomingDateController.text.trim(),
          'STORE_BY': _storeByController.text.trim(),
          'PACK_NO': _packNoController.text.trim(),
          'STORE_DATE': DateTime.now().toString(),
          'STATUS': "S",
          'W1': _weight1Controller.text.trim(),
          'W2': _weight1Controller.text.trim(),
          'WEIGHT': totalWeight.toString(),
          'MFG_DATE': _mfgDateController.text.trim(),
          'THICKNESS1': _packNoController.text.substring(0, 1).trim(),
          'THICKNESS2': "",
          'WRAP_GRADE': _wrapGradeController.text.trim(),
          'ROLL_NO': _rollNoController.text.trim(),
          'checkComplete': ""
        });
      }
    } catch (e, s) {
      print("${e}${s}");
      EasyLoading.showError("Data Not Save");
    }
  }

  void _sendData() {
    num? totalWeight;
    setState(() {
      num weight1 = num.tryParse(_weight1Controller.text.trim()) ?? 0;
      num weight2 = num.tryParse(_weight2Controller.text.trim()) ?? 0;
      totalWeight = weight1 + weight2;
    });

    BlocProvider.of<FilmReceiveBloc>(context).add(
      FilmReceiveSendEvent(
        FilmReceiveOutputModel(
          PONO: _poNoController.text.trim(),
          INVOICE: _InvoiceNoController.text.trim(),
          FRIEGHT: _freightController.text.trim(),
          DATERECEIVE: _IncomingDateController.text.trim(),
          OPERATORNAME: int.tryParse(_storeByController.text.trim()),
          PACKNO: _packNoController.text.trim(),
          STATUS: 'S',
          WEIGHT1: num.tryParse(_weight1Controller.text.trim()),
          WEIGHT2: num.tryParse(_weight2Controller.text.trim()),
          MFGDATE: _mfgDateController.text.trim(),
          THICKNESS: totalWeight!.toString(),
          WRAPGRADE: _wrapGradeController.text.trim(),
          ROLL_NO: _rollNoController.text.trim(),
        ),
      ),
    );
  }

  void _checkMfgDate() {
    if (dataFromBarcode1!.length >= 11) {
      String dateStr = dataFromBarcode1!.substring(4, 6) +
          "/" +
          dataFromBarcode1!.substring(6, 8) +
          "/" +
          dataFromBarcode1!.substring(8, 10);
      DateTime selectedDate = DateFormat('dd/MM/yy').parse(dateStr);
      if (selectedDate != null) {
        setState(() {
          _selectedDateMfg = selectedDate;
          _mfgDateController.text = DateFormat('dd/MM/yy').format(selectedDate);
          DateTime incomingDate = selectedDate;
          DateTime mfgDate =
              DateFormat("dd/MM/yy").parse(_mfgDateController.text);
          Duration difference = incomingDate.difference(mfgDate);
          int differenceInDays = difference.inDays.abs();

          if (differenceInDays > 120) {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      backgroundColor: Colors.orange,
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                              child: Label(
                            "ฟิล์มหมดอายุแล้ว",
                            fontSize: 20,
                          )),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Label('OK'),
                        ),
                      ],
                    ));
          } else if (differenceInDays > 90) {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      backgroundColor: Colors.yellow,
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                              child: Label(
                            "ฟิล์มอายุ 91 - 120 วัน",
                            fontSize: 20,
                          )),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Label('OK'),
                        ),
                      ],
                    ));
          } else {}
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FilmReceiveBloc, FilmReceiveState>(
          listener: (context, state) {
            if (state is FilmReceiveLoadingState) {
              EasyLoading.show();
            } else if (state is FilmReceiveLoadedState) {
              EasyLoading.dismiss();

              if (state.item.RESULT == true) {
                EasyLoading.showSuccess("Send complete",
                    duration: Duration(seconds: 3));
              } else {
                callFilmIn();
              }
            }
            if (state is FilmReceiveErrorState) {
              EasyLoading.dismiss();
              callFilmIn();
              EasyLoading.showError("Can not send");
            }
          },
        )
      ],
      child: BgWhite(
          isHideAppBar: true,
          body: Container(
            padding: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BoxInputField(
                    labelText: "PO No.",
                    height: 30,
                    controller: _poNoController,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          labelText: "Invoice No.",
                          height: 30,
                          controller: _InvoiceNoController,
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 4,
                        child: SizedBox(
                          height: 40,
                          child: DropdownButtonFormField2(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            isExpanded: true,
                            hint: Center(
                              child: Text(
                                'Please Select',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            items: itemList
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Label(item),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              _freightController.text = value!;
                            },
                            buttonStyleData: const ButtonStyleData(
                              height: 50,
                              padding: EdgeInsets.only(left: 20, right: 10),
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black45,
                              ),
                              iconSize: 20,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: GestureDetector(
                          onTap: () async {
                            final DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2023),
                              lastDate: DateTime.now(),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                _selectedDate = selectedDate;
                                _IncomingDateController.text =
                                    DateFormat('dd/MM/yy').format(selectedDate);
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: BoxInputField(
                              labelText: "Incoming Date",
                              controller: _IncomingDateController,
                              type: TextInputType.datetime,
                              height: 30,
                              maxLength: 6,
                              textInputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          labelText: "Store By",
                          height: 30,
                          controller: _storeByController,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          labelText: "Pack No.",
                          height: 30,
                          controller: _packNoController,
                          maxLength: 8,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          labelText: "Roll No.",
                          height: 30,
                          controller: _rollNoController,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^(?!.*\d{8})[a-zA-Z0-9]+$'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          labelText: "BarCode 1",
                          height: 30,
                          controller: _barCode1Controller,
                          onChanged: (value) {
                            if (value.length > 10) {
                              setState(() {
                                dataFromBarcode1 = value;
                                String substringValue =
                                    value.substring(value.length - 3);
                                double parsedValue =
                                    double.parse(substringValue) / 100;
                                _weight1Controller.text =
                                    parsedValue.toStringAsFixed(2);
                              });
                            }
                          },
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          labelText: "BarCode 2",
                          height: 30,
                          controller: _barCode2Controller,
                          onChanged: (value) {
                            String substringValue =
                                value.substring(value.length - 3);
                            double parsedValue =
                                double.parse(substringValue) / 100;
                            _weight2Controller.text =
                                parsedValue.toStringAsFixed(2);
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          labelText: "Weight 1",
                          height: 30,
                          controller: _weight1Controller,
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          labelText: "Weight 2",
                          height: 30,
                          controller: _weight2Controller,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: GestureDetector(
                          onTap: () async {
                            _checkMfgDate();
                          },
                          child: AbsorbPointer(
                            child: BoxInputField(
                              labelText: "Mfg. Date",
                              controller: _mfgDateController,
                              type: TextInputType.datetime,
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 4,
                        child: BoxInputField(
                          labelText: "Wrap Grade",
                          height: 30,
                          controller: _wrapGradeController,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Button(
                    onPress: () {
                      _checkValueController();
                      // callFilmIn();
                    },
                    text: Label(
                      "Send",
                      color: COLOR_WHITE,
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
