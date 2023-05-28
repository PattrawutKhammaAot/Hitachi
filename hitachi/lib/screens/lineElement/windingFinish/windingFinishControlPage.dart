import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/screens/lineElement/windingFinish/hold/windingJobFinish_hold_screen.dart';
import 'package:hitachi/screens/lineElement/windingFinish/scan/windingjobFinish_screen.dart';
import 'package:hitachi/services/databaseHelper.dart';

import '../../../config.dart';

class WindingFinishControlPage extends StatefulWidget {
  const WindingFinishControlPage({super.key});

  @override
  State<WindingFinishControlPage> createState() =>
      _WindingFinishControlPageState();
}

class _WindingFinishControlPageState extends State<WindingFinishControlPage> {
  int _selectedIndex = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('WINDING_SHEET');
    setState(() {
      listHoldWindingFinish =
          sql.where((element) => element['checkComplete'] == 'E').toList();
    });
  }

  @override
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _getHold();
    });
  }

  void initState() {
    _getHold().then((value) => null);
    super.initState();
  }

  List<Widget> widgetOptions = [
    WindingJobFinishScreen(),
    WindingJobFinishHoldScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      textTitle: Padding(
        padding: const EdgeInsets.only(right: 45),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Label("Winding Finish"),
            SizedBox(
              width: 10,
            ),
            Label(
              "-${listHoldWindingFinish.length ?? 0}-",
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
