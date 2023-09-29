import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/cardButton2.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/route/router_list.dart';

class LineElementScreen extends StatefulWidget {
  const LineElementScreen({super.key});

  @override
  State<LineElementScreen> createState() => _LineElementScreenState();
}

class _LineElementScreenState extends State<LineElementScreen> {
  FocusNode _node = FocusNode();
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
              Navigator.pushNamed(
                  context, RouterList.WindingJobStart_Control_Screen);
              break;
            case '2':
              Navigator.pushNamed(
                  context, RouterList.WindingJobFinish_Control_Screen);
              break;
            case '3':
              Navigator.pushNamed(
                  context, RouterList.ProcessStart_Control_Screen);
              break;
            case '4':
              Navigator.pushNamed(
                  context, RouterList.ProcessFinish_control_Screen);
              break;
            case '5':
              Navigator.pushNamed(
                  context, RouterList.TreatMentStart_control_Screen);
              break;
            case '6':
              Navigator.pushNamed(
                  context, RouterList.TreatmentFinish_control_Screen);
              break;
            case '7':
              Navigator.pushNamed(
                  context, RouterList.ReportRouteSheet_control_Screen);
              break;
            case '8':
              Navigator.pushNamed(
                  context, RouterList.MaterialInput_control_Screen);
              break;
          }
        }
      },
      child: BgWhite(
        isHideTitle: false,
        textTitle: Label("Line Element : Menu"),
        body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            CardButton2(
              text: "1.Winding\nStart",
              onPress: () => Navigator.pushNamed(
                  context, RouterList.WindingJobStart_Control_Screen),
            ),
            CardButton2(
              text: "2.Winding\nFinish",
              onPress: () => Navigator.pushNamed(
                  context, RouterList.WindingJobFinish_Control_Screen),
            ),
            CardButton2(
              text: "3.Winding\nRecord",
              onPress: () => Navigator.pushNamed(
                  context, RouterList.WindingRecord_Control_Screen),
            ),
            CardButton2(
              text: "4.Material\nTrace",
              onPress: () => Navigator.pushNamed(
                  context, RouterList.Material_Trace_Control_Screen),
            ),
            CardButton2(
              text: "5.Process\nStart",
              onPress: () => Navigator.pushNamed(
                  context, RouterList.ProcessStart_Control_Screen),
            ),
            CardButton2(
              text: "6.Process\nFinish",
              onPress: () => Navigator.pushNamed(
                  context, RouterList.ProcessFinish_control_Screen),
            ),
            CardButton2(
              text: "7.Treatment\nStart",
              onPress: () => Navigator.pushNamed(
                  context, RouterList.TreatMentStart_control_Screen),
            ),
            CardButton2(
              text: "8.Treatment\nFinish",
              onPress: () => Navigator.pushNamed(
                  context, RouterList.TreatmentFinish_control_Screen),
            ),
            CardButton2(
              text: "9.Report Route Sheet",
              onPress: () => Navigator.pushNamed(
                  context, RouterList.ReportRouteSheet_control_Screen),
            ),
            CardButton2(
              text: "10.Material\nInput",
              onPress: () => Navigator.pushNamed(
                  context, RouterList.MaterialInput_control_Screen),
            ),
          ],
        ),
      ),
    );
  }
}
