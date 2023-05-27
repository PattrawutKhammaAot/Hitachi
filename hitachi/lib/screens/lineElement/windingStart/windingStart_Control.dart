import 'package:flutter/material.dart';
import 'package:hitachi/config.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/screens/lineElement/windingStart/Scan/windingjobstart_Scan_Screen.dart';
import 'package:hitachi/screens/lineElement/windingStart/hold/windingjobstart_Hold_Screen.dart';
import 'package:hitachi/services/databaseHelper.dart';

class WindingJobStartControlPage extends StatefulWidget {
  const WindingJobStartControlPage({super.key});

  @override
  State<WindingJobStartControlPage> createState() =>
      _WindingJobStartControlPageState();
}

class _WindingJobStartControlPageState
    extends State<WindingJobStartControlPage> {
  int _selectedIndex = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _getHold();
    });
  }

  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('WINDING_SHEET');
    setState(() {
      listHoldWindingStart =
          sql.where((element) => element['Status'] == 'P').toList();
    });
  }

  @override
  void initState() {
    _getHold().then((value) => null);
    super.initState();
  }

  List<Widget> widgetOptions = [
    WindingJobStartScanScreen(),
    WindingJobStartHoldScreen()
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
            Label("Winding Start"),
            SizedBox(
              width: 10,
            ),
            Label(
              "-${listHoldWindingStart.length ?? 0}-",
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
