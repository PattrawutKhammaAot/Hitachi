import 'package:flutter/material.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:hitachi/screens/lineElement/Scan/windingjobstart_Scan_Screen.dart';
import 'package:hitachi/screens/lineElement/lineElementMenu_Screen.dart';
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
            type: PageTransitionType.leftToRight);

      ///LineElementMenu
      case RouterList.LINE_ELEMENT_SCREEN:
        return PageTransition(
            settings: settings,
            child: LineElementScreen(),
            type: PageTransitionType.leftToRight);
      case RouterList.WindingJobStart_Scan_Screen:
        return PageTransition(
            settings: settings,
            child: WindingJobStartScanScreen(),
            type: PageTransitionType.leftToRight);
    }
    throw UnsupportedError('Unknow route : ${settings.name}');
  }
}
