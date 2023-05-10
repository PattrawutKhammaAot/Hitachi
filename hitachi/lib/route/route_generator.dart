import 'package:flutter/material.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:hitachi/screens/PMDaily/PMDaily_Sereen.dart';
import 'package:hitachi/screens/lineElement/lineElementMenu_Screen.dart';
import 'package:hitachi/screens/lineElement/materialInput/materialInput_Screen.dart';
import 'package:hitachi/screens/lineElement/materialInput/materialInput_hold_Screen.dart';
import 'package:hitachi/screens/lineElement/processFinish/processFinish_screen.dart';
import 'package:hitachi/screens/lineElement/processStart/processStart_screen.dart';
import 'package:hitachi/screens/lineElement/reportRouteSheet/reportRouteSheet_Screen.dart';
import 'package:hitachi/screens/lineElement/treatmentFinish/treatmentFinish_screen.dart';
import 'package:hitachi/screens/lineElement/treatmentStart/treatmentStart_screen.dart';
import 'package:hitachi/screens/lineElement/windingFinish/windingjobFinish_screen.dart';
import 'package:hitachi/screens/lineElement/windingStart/Scan/windingjobstart_Scan_Screen.dart';
import 'package:hitachi/screens/lineElement/windingStart/hold/windingjobstart_Hold_Screen.dart';
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
      case RouterList.WindingJobStart_Scan_Screen:
        return PageTransition(
            settings: settings,
            child: WindingJobStartScanScreen(),
            type: PageTransitionType.leftToRight);
      case RouterList.WindingJobStart_Hold_Screen:
        return PageTransition(
            settings: settings,
            child: WindingJobStartHoldScreen(),
            type: PageTransitionType.fade);
      //WindingJobFinish - LineElement
      case RouterList.WindingJobFinish_Screen:
        return PageTransition(
            settings: settings,
            child: WindingJobFinishScreen(),
            type: PageTransitionType.fade);
      //ProcessStart - LineElement
      case RouterList.ProcessStart_Screen:
        return PageTransition(
            settings: settings,
            child: ProcessStartScreen(),
            type: PageTransitionType.fade);
      //ProcessStart - LineElement
      case RouterList.ProcessFinish_Screen:
        return PageTransition(
            settings: settings,
            child: ProcessFinishScreen(),
            type: PageTransitionType.fade);
      //TreatmentStart - LineElement
      case RouterList.TreatMentStartScreen:
        return PageTransition(
            settings: settings,
            child: TreatMentStartScreen(),
            type: PageTransitionType.fade);
      case RouterList.TreatmentFinishScreen:
        return PageTransition(
            settings: settings,
            child: TreatmentFinishScreen(),
            type: PageTransitionType.fade);
      //ReportRouteSheetScreen - LineElement
      case RouterList.ReportRouteSheet_Screen:
        return PageTransition(
            settings: settings,
            child: ReportRouteSheetScreen(),
            type: PageTransitionType.fade);
      //MaterialInputScreen - LineElement
      case RouterList.MaterialInput_Screen:
        return PageTransition(
            settings: settings,
            child: MaterialInputScreen(),
            type: PageTransitionType.fade);
<<<<<<< HEAD
      //PMDaily - PMDaily
      case RouterList.PMPlan_Screen:
        return PageTransition(
            settings: settings,
            child: PMDaily_Screen(),
=======
      case RouterList.MaterialInput_Hold_Screen:
        return PageTransition(
            settings: settings,
            child: MaterialInputHoldScreen(),
>>>>>>> 61218967523c7a025f8e08841f8c7bb9fd5429ee
            type: PageTransitionType.fade);
    }
    throw UnsupportedError('Unknow route : ${settings.name}');
  }
}
