import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';

import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/cardButton.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/checkPackNo_Model.dart';
import 'package:hitachi/models/materialInput/materialOutputModel.dart';
import 'package:hitachi/models/reportRouteSheet/reportRouteSheetModel.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:hitachi/utils/build_info.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  FocusNode _node = FocusNode();
  DatabaseHelper databaseHelper = DatabaseHelper();
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  ReportRouteSheetModel? items;

  @override
  void initState() {
    _initPackageInfo();
    super.initState();
    _node.requestFocus();
    // _testInsertData();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _node,
      autofocus: true,
      onKey: (event) {
        if (event is RawKeyDownEvent) {
          String keyLabel = event.logicalKey.keyLabel;

          switch (keyLabel) {
            case '1':
              Navigator.pushNamed(context, RouterList.LINE_ELEMENT_SCREEN);
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              break;
            case '2':
              Navigator.pushNamed(
                  context, RouterList.Planwinding_control_Screen);
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              break;
            case '3':
              Navigator.pushNamed(
                  context, RouterList.MachineBreakDown_control_Screen);
              break;
            case '4':
              Navigator.pushNamed(context, RouterList.PMDaily_control_Screen);
              break;
            case '5':
              Navigator.pushNamed(
                  context, RouterList.FilmReceive_control_Screen);
              break;
            case '6':
              Navigator.pushNamed(context, RouterList.ZincThickness_control);
              break;
            case '7':
              Navigator.pushNamed(context, RouterList.DownloadMasterScreen);
              break;
            case '8':
              Navigator.pushNamed(context, RouterList.Setting_web);
              break;
            case '0':
              showExitPopup(context);
              break;
          }
        }

        // }
      },
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: BgWhite(
          isHidePreviour: true,
          textTitle: Label("Element : Main Menu"),
          body: Padding(
            padding:
                const EdgeInsets.only(top: 0, bottom: 10, right: 10, left: 10),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    CardButton(
                      text: "1.Line Element",
                      onPress: () => Navigator.pushNamed(
                          context, RouterList.LINE_ELEMENT_SCREEN),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CardButton(
                      text: "2.Plan Winding",
                      onPress: () => Navigator.pushNamed(
                          context, RouterList.Planwinding_control_Screen),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CardButton(
                      text: "3.Machine Breakdown",
                      onPress: () => Navigator.pushNamed(
                          context, RouterList.MachineBreakDown_control_Screen),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CardButton(
                      text: "4.PM Daily",
                      onPress: () => Navigator.pushNamed(
                          context, RouterList.PMDaily_control_Screen),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CardButton(
                      text: "5.Film Receive",
                      onPress: () => Navigator.pushNamed(
                          context, RouterList.FilmReceive_control_Screen),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CardButton(
                      text: "6.Zinc Thickness",
                      onPress: () => Navigator.pushNamed(
                          context, RouterList.ZincThickness_control),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CardButton(
                      color: COLOR_BLUE_DARK,
                      textAlign: TextAlign.center,
                      text: "7.Download Master",
                      colortext: COLOR_WHITE,
                      onPress: () => Navigator.pushNamed(
                          context, RouterList.DownloadMasterScreen),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CardButton(
                      color: COLOR_BLUE_DARK,
                      textAlign: TextAlign.center,
                      text: "8.Setting Web",
                      colortext: COLOR_WHITE,
                      onPress: () =>
                          Navigator.pushNamed(context, RouterList.Setting_web),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CardButton(
                      color: COLOR_RED,
                      text: "0.ExitApp",
                      onPress: () => showExitPopup(context),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Label(
                      "Version ${_packageInfo.version} (${_packageInfo.buildNumber}) ",
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                    Label(
                      "Date Modified : 17-March-2025",
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> showExitPopup(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Do you want to exit?"),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            print('yes selected');
                            exit(0);
                          },
                          child: Text("Yes"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade800),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          print('no selected');
                          Navigator.of(context).pop();
                        },
                        child:
                            Text("No", style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
