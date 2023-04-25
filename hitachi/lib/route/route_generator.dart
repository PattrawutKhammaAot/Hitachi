import 'package:flutter/material.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:hitachi/screens/testScreen.dart';
import 'package:page_transition/page_transition.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print(settings.name);
    switch (settings.name) {
      // case RouterList.TEST_SCREEN:
      //   return PageTransition(
      //       settings: settings,
      //       child: TestScreen(),
      //       type: PageTransitionType.bottomToTop);
      // case RouterList.TEST_SCREEN:
      //   return PageTransition(
      //       settings: settings,
      //       child: TestScreen(),
      //       type: PageTransitionType.leftToRight);
      case RouterList.PLAN_WINDING_PAGE:
        return PageTransition(
            settings: settings,
            child: TestScreen(),
            type: PageTransitionType.fade);
    }
    throw UnsupportedError('Unknow route : ${settings.name}');
  }
}
