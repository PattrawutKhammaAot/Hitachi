import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/SendWds/SendWdsModel_Output.dart';
import 'package:hitachi/models/SendWds/sendWdsModel_input.dart';
import 'package:hitachi/route/router_list.dart';

class WindingJobStartScanScreen extends StatefulWidget {
  const WindingJobStartScanScreen({super.key});

  @override
  State<WindingJobStartScanScreen> createState() =>
      _WindingJobStartScanScreenState();
}

class _WindingJobStartScanScreenState extends State<WindingJobStartScanScreen> {
  final TextEditingController machineNo = TextEditingController();
  final TextEditingController operatorName = TextEditingController();
  final TextEditingController batchNo = TextEditingController();
  final TextEditingController product = TextEditingController();
  final TextEditingController filmPackNo = TextEditingController();
  final TextEditingController paperCodeLot = TextEditingController();
  final TextEditingController ppFilmLot = TextEditingController();
  final TextEditingController foilLot = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SendWindingStartModelInput? items;

  String text = "";

  void sendData() {
    setState(() {
      BlocProvider.of<LineElementBloc>(context).add(
        PostSendWindingStartEvent(
          SendWindingStartModelOutput(
            MACHINE_NO: machineNo.text.trim(),
            OPERATOR_NAME: int.tryParse(operatorName.text.trim()),
            BATCH_NO: int.tryParse(batchNo.text),
            PRODUCT: int.tryParse(product.text),
            FILM_PACK_NO: int.tryParse(filmPackNo.text.trim()),
            PAPER_CODE_LOT: paperCodeLot.text.trim(),
            PP_FILM_LOT: ppFilmLot.text.trim(),
            FOIL_LOT: foilLot.text.trim(),
          ),
        ),
      );
    });
  }

  void _checkValueController() {
    if (machineNo.text.isNotEmpty ||
        operatorName.text.isNotEmpty ||
        batchNo.text.isNotEmpty ||
        product.text.isNotEmpty ||
        filmPackNo.text.isNotEmpty ||
        paperCodeLot.text.isNotEmpty ||
        ppFilmLot.text.isNotEmpty ||
        foilLot.text.isNotEmpty) {
      sendData();
    } else {
      EasyLoading.showError("Invaild", duration: Duration(seconds: 5));
    }
  }

  void checkValueData() {}

  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: BgWhite(
        textTitle: "Winding Job Start (Scan)",
        body: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: MultiBlocListener(
              listeners: [
                BlocListener<LineElementBloc, LineElementState>(
                    listener: (context, state) {
                  if (state is PostSendWindingStartLoadingState) {
                    EasyLoading.show();
                  }
                  if (state is PostSendWindingStartLoadedState) {
                    EasyLoading.dismiss();
                    items = state.item;
                    if (items?.RESULT == false) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _popupWeight(items!.RESULT == true);
                          });
                    } else if (items?.RESULT == true) {
                    } else {
                      EasyLoading.showError("Load Data Failed",
                          duration: Duration(seconds: 3));
                    }
                  }
                  if (state is PostSendWindingStartErrorState) {
                    EasyLoading.showError("ไม่พบข้อมูล");
                  }
                })
              ],
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            BoxInputField(
                              labelText: "Machine No :",
                              controller: machineNo,
                              maxLength: 3,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            BoxInputField(
                              labelText: "Operator Name :",
                              controller: operatorName,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            BoxInputField(
                              labelText: "Batch No :",
                              controller: batchNo,
                              type: TextInputType.number,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            BoxInputField(
                              labelText: "Product",
                              controller: product,
                              maxLength: 5,
                              type: TextInputType.number,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            BoxInputField(
                              labelText: "Film Pack No :",
                              controller: filmPackNo,
                              type: TextInputType.number,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            BoxInputField(
                              labelText: "Paper Code Lot :",
                              controller: paperCodeLot,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            BoxInputField(
                              labelText: "PP Film Lot :",
                              controller: ppFilmLot,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            BoxInputField(
                              labelText: "Foil Lot:",
                              controller: foilLot,
                            ),
                            SizedBox(
                              height: 5,
                            ),

                            Container(
                              child: Row(
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
                                    onTap: () => Navigator.pushNamed(context,
                                        RouterList.WindingJobStart_Hold_Screen),
                                    child: Label(
                                      "Hold",
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            // Container(
                            //   child: Button(
                            //     text: Label("test"),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Button(
                      bgColor: _formKey.currentState == null
                          ? COLOR_BLUE_DARK
                          : COLOR_RED,
                      text: Label(
                        "Send",
                        color: COLOR_WHITE,
                      ),
                      onPress: () => _checkValueController(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _popupWeight(bool isCheckValue) {
    return isCheckValue == true
        ? AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(child: Label("Send complete.")),
              ],
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Center(
                        child: Button(
                          height: 30,
                          bgColor: COLOR_BLUE_DARK,
                          text: Label(
                            "OK",
                            color: COLOR_WHITE,
                          ),
                          onPress: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(child: Label("weight1 :")),
                    Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 40,
                          child: TextFormField(
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Label("weight2 :")),
                    Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 40,
                          child: TextFormField(
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                          ),
                        )),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Center(
                        child: Button(
                          height: 30,
                          bgColor: COLOR_RED,
                          text: Label(
                            "Cancel",
                            color: COLOR_WHITE,
                          ),
                          onPress: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Expanded(
                      child: Center(
                        child: Button(
                          height: 30,
                          bgColor: COLOR_BLUE_DARK,
                          text: Label(
                            "OK",
                            color: COLOR_WHITE,
                          ),
                          onPress: () => print("test"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
