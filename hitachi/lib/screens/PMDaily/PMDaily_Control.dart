import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/screens/zincthickness/hold/zincthicknessHold.dart';
import 'package:hitachi/screens/PMDaily/Scan/PMDaily_Scan_Sereen.dart';
import 'package:hitachi/screens/PMDaily/hold/PMDaily_Hold_Screen.dart';

class PMDailyControl extends StatefulWidget {
  const PMDailyControl({super.key});

  @override
  State<PMDailyControl> createState() => _PMDailyControlState();
}

class _PMDailyControlState extends State<PMDailyControl> {
  @override
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    Future.delayed(Duration(microseconds: 10), () {
      setState(() {
        setState(() {
          _selectedIndex = index;
        });
      });
    });
  }

  List<Widget> widgetOptions = [PMDaily_Screen(), PMdailyHold_Screen()];

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      textTitle: "PM Daily",
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.aod),
            label: 'Scan',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Hold',
            backgroundColor: Colors.green,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: COLOR_BLUE_DARK,
        onTap: _onItemTapped,
      ),
    );
  }
}
