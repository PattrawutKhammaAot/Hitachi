import 'package:flutter/material.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:hitachi/screens/lineElement/lineElementMenu_Screen.dart';
import 'package:hitachi/screens/lineElement/materialInput/materialInput_Screen.dart';
import 'package:hitachi/screens/lineElement/materialInput/materialInput_control_page.dart';
import 'package:hitachi/screens/lineElement/materialInput/materialInput_hold_Screen.dart';
import 'package:hitachi/screens/lineElement/processFinish/processFinish_screen.dart';
import 'package:hitachi/screens/lineElement/processStart/processStart_screen.dart';
import 'package:hitachi/screens/lineElement/reportRouteSheet/reportRouteSheet_main.dart';
import 'package:hitachi/screens/lineElement/treatmentFinish/treatmentFinish_screen.dart';
import 'package:hitachi/screens/lineElement/treatmentStart/treatmentStart_screen.dart';
import 'package:hitachi/screens/lineElement/windingFinish/hold/windingJobFinish_hold_screen.dart';
import 'package:hitachi/screens/lineElement/windingFinish/scan/windingjobFinish_screen.dart';
import 'package:hitachi/screens/lineElement/windingFinish/windingFinishControlPage.dart';
import 'package:hitachi/screens/lineElement/windingStart/Scan/windingjobstart_Scan_Screen.dart';
import 'package:hitachi/screens/lineElement/windingStart/hold/windingjobstart_Hold_Screen.dart';
import 'package:hitachi/screens/lineElement/windingStart/windingControllerPage.dart';
import 'package:hitachi/screens/mainMenu/MainMenu.dart';
import 'package:page_transition/page_transition.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print(settings.name);
    switch (settings.name) {
      case RouterList.MAIN_MENU:
        return PageTransition(
            settings: settings,
            child: MainMenu(),
            type: PageTransitionType.fade);

      ///LineElementMenu
      case RouterList.LINE_ELEMENT_SCREEN:
        return PageTransition(
            settings: settings,
            child: LineElementScreen(),
            type: PageTransitionType.leftToRight);
      //WindgJobStart - LineElement
      case RouterList.WindingJobStart_Control_Screen:
        return PageTransition(
            settings: settings,
            child: WindingJobStartControlPage(),
            type: PageTransitionType.leftToRight);

      //WindingJobFinish - LineElement
      case RouterList.WindingJobFinish_Control_Screen:
        return PageTransition(
            settings: settings,
            child: WindingFinishControlPage(),
            type: PageTransitionType.fade);

      //ProcessStart - LineElement
      case RouterList.ProcessStart_Control_Screen:
        return PageTransition(
            settings: settings,
            child: ProcessStartScreen(),
            type: PageTransitionType.fade);
      //ProcessFinish - LineElement
      case RouterList.ProcessStart_Control_Screen:
        return PageTransition(
            settings: settings,
            child: ProcessStartScreen(),
            type: PageTransitionType.fade);

      //TreatmentStart - LineElement
      case RouterList.TreatMentStart_controlScreen:
        return PageTransition(
            settings: settings,
            child: TreatMentStartScreen(),
            type: PageTransitionType.fade);
      //TreatmentFinish - LineElement
      case RouterList.TreatmentFinish_control_Screen:
        return PageTransition(
            settings: settings,
            child: TreatmentFinishScreen(),
            type: PageTransitionType.fade);
      //ReportRouteSheetScreen - LineElement
      case RouterList.ReportRouteSheet_control_Screen:
        return PageTransition(
            settings: settings,
            child: ReportRouteSheetScreen(),
            type: PageTransitionType.fade);
      //MaterialInputScreen - LineElement
      case RouterList.MaterialInput_control_Screen:
        return PageTransition(
            settings: settings,
            child: MaterialInputControlPage(),
            type: PageTransitionType.fade);
    }
    throw UnsupportedError('Unknow route : ${settings.name}');
  }
}
