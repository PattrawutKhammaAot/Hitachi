import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:hitachi/screens/PMDaily/PMDaily_Control.dart';
import 'package:hitachi/screens/filmreceive/filmreceive_control.dart';
import 'package:hitachi/screens/lineElement/lineElementMenu_Screen.dart';

import 'package:hitachi/screens/lineElement/materialInput/materialInput_control_page.dart';

import 'package:hitachi/screens/lineElement/materialtrace/materialTrace_control.dart';
import 'package:hitachi/screens/lineElement/processFinish/processFinish_control_.dart';

import 'package:hitachi/screens/lineElement/processStart/processStart_Control.dart';

import 'package:hitachi/screens/lineElement/reportRouteSheet/reportRouteSheet_main.dart';

import 'package:hitachi/screens/lineElement/treatmentFinish/treatmentFinish_control_page.dart';

import 'package:hitachi/screens/lineElement/treatmentStart/treatmentStart_control_page.dart';

import 'package:hitachi/screens/lineElement/windingFinish/windingFinishControlPage.dart';

import 'package:hitachi/screens/lineElement/windingStart/windingStart_Control.dart';
import 'package:hitachi/screens/lineElement/windingrecord/windingrecord_control.dart';
import 'package:hitachi/screens/machinebreackdown/mbd_control.dart';
import 'package:hitachi/screens/mainMenu/Homepage.dart';
import 'package:hitachi/screens/planWinding/PlanWinding_Control.dart';

import 'package:hitachi/screens/settingWeb/settingWeb_screen.dart';
import 'package:hitachi/screens/zincthickness/zthnControl.dart';
import 'package:page_transition/page_transition.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print(settings.name);
    switch (settings.name) {
      ///MainMenu
      case RouterList.MAIN_MENU:
        return PageTransition(
            settings: settings,
            child: MainMenuScreen(),
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

      //WindingRecord - LineElement
      case RouterList.WindingRecord_Control_Screen:
        return PageTransition(
            settings: settings,
            child: WindingRecordControl(),
            type: PageTransitionType.fade);
      //MaterialTrace - LineElement
      case RouterList.Material_Trace_Control_Screen:
        return PageTransition(
            settings: settings,
            child: MaterialTraceControl(),
            type: PageTransitionType.fade);

      //ProcessStart - LineElement
      case RouterList.ProcessStart_Control_Screen:
        return PageTransition(
            settings: settings,
            child: ProcessStartControlPage(),
            type: PageTransitionType.fade);
      //ProcessFinish - LineElement
      case RouterList.ProcessFinish_control_Screen:
        return PageTransition(
            settings: settings,
            child: ProcessFinishControlPage(),
            type: PageTransitionType.fade);

      //TreatmentStart - LineElement
      case RouterList.TreatMentStart_control_Screen:
        return PageTransition(
            settings: settings,
            child: TreatmentStartControlPage(),
            type: PageTransitionType.fade);
      //TreatmentFinish - LineElement
      case RouterList.TreatmentFinish_control_Screen:
        return PageTransition(
            settings: settings,
            child: TreatmentFinishControlPage(),
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
      //PlanWinding
      case RouterList.Planwinding_control_Screen:
        return PageTransition(
            settings: settings,
            child: PlanWindingControl(),
            type: PageTransitionType.fade);
      //MachineBreakDown
      case RouterList.MachineBreakDown_control_Screen:
        return PageTransition(
            settings: settings,
            child: MachineBreackDownControl(),
            type: PageTransitionType.fade);
      //FilmReceive
      case RouterList.FilmReceive_control_Screen:
        return PageTransition(
            settings: settings,
            child: FilmReceiveControlPage(),
            type: PageTransitionType.fade);
      //ZincThickness
      case RouterList.ZincThickness_control:
        return PageTransition(
            settings: settings,
            child: ZincThicknessControl(),
            type: PageTransitionType.fade);
      //DownloadMaster
      case RouterList.DownloadMasterScreen:
        return PageTransition(
            settings: settings,
            child: SizedBox(),
            type: PageTransitionType.fade);
      //SettingWeb
      case RouterList.Setting_web:
        return PageTransition(
            settings: settings,
            child: SettingWebScreen(),
            type: PageTransitionType.fade);

      //PMDaily
      case RouterList.PMDaily_control_Screen:
        return PageTransition(
            settings: settings,
            child: PMDailyControl(),
            type: PageTransitionType.fade);
    }
    throw UnsupportedError('Unknow route : ${settings.name}');
  }
}
