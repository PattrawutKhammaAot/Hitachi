import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/cardButton2.dart';
import 'package:hitachi/route/router_list.dart';

class LineElementScreen extends StatefulWidget {
  const LineElementScreen({super.key});

  @override
  State<LineElementScreen> createState() => _LineElementScreenState();
}

class _LineElementScreenState extends State<LineElementScreen> {
  @override
  Widget build(BuildContext context) {
    return BgWhite(
      isHideTitle: false,
      textTitle: "Line Element : Menu",
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CardButton2(
                      text: "Winding Start",
                      onPress: () => Navigator.pushNamed(
                          context, RouterList.WindingJobStart_Scan_Screen),
                    ),
                    CardButton2(
                      text: "Winding Finish",
                      onPress: () => Navigator.pushNamed(
                          context, RouterList.WindingJobFinish_Screen),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CardButton2(
                      text: "Process Start",
                      // onPress: () => Navigator.pushNamed(
                      //     context, RouterList.MAIN_MENU),
                    ),
                    CardButton2(
                      text: "Process Finish",
                      onPress: () => print("test2"),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CardButton2(
                      text: "Treatment Start",
                      // onPress: () => Navigator.pushNamed(
                      //     context, RouterList.MAIN_MENU),
                    ),
                    CardButton2(
                      text: "Treatment Finish",
                      onPress: () => print("test2"),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CardButton2(
                      text: "Report Route Sheet",
                      onPress: () => Navigator.pushNamed(
                          context, RouterList.ReportRouteSheet_Screen),
                    ),
                    CardButton2(
                      text: "Material Input",
                      onPress: () => Navigator.pushNamed(
                          context, RouterList.MaterialInput_Screen),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
