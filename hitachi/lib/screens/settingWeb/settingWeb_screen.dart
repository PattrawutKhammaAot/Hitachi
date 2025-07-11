import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/connection/testconnection_bloc.dart';
import 'package:hitachi/config.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingWebScreen extends StatefulWidget {
  const SettingWebScreen({super.key});

  @override
  State<SettingWebScreen> createState() => _SettingWebScreenState();
}

class _SettingWebScreenState extends State<SettingWebScreen> {
  final TextEditingController _urlController = TextEditingController();

  // String tempUrl = "https://dev.lvcap.th.hitachienergy.com/";
  String tempUrl = "https://lvcap.th.hitachienergy.com/";
  // String tempUrl = "http://10.10.60.115/API_Hitachi/";

  Color _isColorSuccess = Colors.grey;

  @override
  void initState() {
    _checkUrl();
    super.initState();
  }

  void _checkUrl() {
    setState(() {
      if (BASE_API_URL.isNotEmpty) {
        _urlController.text = BASE_API_URL;
      } else {
        _urlController.text = tempUrl;
      }
    });
  }

  void _sendApi() {
    setState(() {
      TEMP_API_URL = _urlController.text.trim();
    });
    BlocProvider.of<TestconnectionBloc>(context).add(Test_ConnectionEvent());
    print(TEMP_API_URL);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TestconnectionBloc, TestconnectionState>(
          listener: (context, state) {
            if (state is TestconnectionLoadingState) {
              EasyLoading.show();
            } else if (state is TestconnectionLoadedState) {
              EasyLoading.dismiss();
              if (state.item.RESULT == true) {
                EasyLoading.showSuccess("Connection Success");
                setState(() {
                  _isColorSuccess = COLOR_SUCESS;
                });
              } else {
                EasyLoading.showError("Connection Failed");
                setState(() {
                  _isColorSuccess = Colors.grey;
                });
              }
            }
            if (state is TestconnectionErrorState) {
              EasyLoading.showError("Please Check Connection");
            }
          },
        )
      ],
      child: BgWhite(
          textTitle: Label("Setting Web"),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 50),
              child: Column(
                children: [
                  Label(
                    "Connection to Server",
                    fontSize: 30,
                  ),
                  TextFormField(
                    controller: _urlController,
                    maxLines: 5,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    onEditingComplete: () {
                      _sendApi();
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Label(
                    "${BASE_API_URL}",
                    fontSize: 20,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Button(
                    text: Label(
                      "Test Connection",
                      color: COLOR_WHITE,
                    ),
                    onPress: () {
                      _sendApi();
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Button(
                          bgColor: _isColorSuccess,
                          onPress: () async {
                            SharedPreferences pre =
                                await SharedPreferences.getInstance();
                            setState(() {
                              BASE_API_URL = TEMP_API_URL;
                              pre.setString("API", BASE_API_URL);
                              BASE_API_URL = pre.getString("API").toString();
                            });

                            // print(saveStringToSharedPreferences(BASE_API_URL));
                            EasyLoading.showSuccess("Save Complete");
                          },
                          text: Label(
                            "OK",
                            color: COLOR_WHITE,
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 4,
                        child: Button(
                          onPress: () => Navigator.pop(context),
                          bgColor: COLOR_RED,
                          text: Label(
                            "Cancel",
                            color: COLOR_WHITE,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
