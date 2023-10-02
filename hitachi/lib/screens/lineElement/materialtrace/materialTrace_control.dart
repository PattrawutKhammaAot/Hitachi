import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/screens/lineElement/materialtrace/hold/materialTrace_Hold_Screen.dart';
import 'package:hitachi/screens/lineElement/materialtrace/scan/materialTrace_Scan_Screen.dart';
import 'package:hitachi/screens/lineElement/processFinish/hold/processFinish_hold_screen.dart';
import 'package:hitachi/screens/lineElement/processFinish/scan/processFinish_scan_screen.dart';

class MaterialTraceControl extends StatefulWidget {
  const MaterialTraceControl({super.key});

  @override
  State<MaterialTraceControl> createState() => _MaterialTraceControlState();
}

class _MaterialTraceControlState extends State<MaterialTraceControl> {
  @override
  List<Map<String, dynamic>> listHoldProcessEnd = [];
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = [
      MaterialTraceScanScreen(),
      MaterialTraceHoldScreen()
    ];
    return BgWhite(
      textTitle: Padding(
        padding: const EdgeInsets.only(right: 45),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Label("Material Trace"),
            SizedBox(
              width: 10,
            ),
            Label(
              "-${listHoldProcessEnd.length ?? 0}-",
              color: COLOR_RED,
            )
          ],
        ),
      ),
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