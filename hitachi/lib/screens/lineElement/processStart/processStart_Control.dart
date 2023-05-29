import 'package:flutter/material.dart';
import 'package:hitachi/config.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/screens/lineElement/processStart/hold/precessStart_hold_screen.dart';
import 'package:hitachi/screens/lineElement/processStart/scan/processStart_scan_screen.dart';
import 'package:hitachi/services/databaseHelper.dart';

class ProcessStartControlPage extends StatefulWidget {
  const ProcessStartControlPage({super.key});

  @override
  State<ProcessStartControlPage> createState() =>
      _ProcessStartControlPageState();
}

class _ProcessStartControlPageState extends State<ProcessStartControlPage> {
  @override
  int _selectedIndex = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('PROCESS_SHEET');
    //.queryAllRows('WINDING_SHEET');
    setState(() {
      listHoldProcessStart =
          sql.where((element) => element['StartEnd'] == 'S').toList();
    });
  }

  @override
  void initState() {
    _getHold().then((value) => null);
    super.initState();
  }

  List<Widget> widgetOptions = [
    ProcessStartScanScreen(),
    ProcessStartHoldScreen()
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
            Label("Process Start"),
            SizedBox(
              width: 10,
            ),
            Label(
              "-${listHoldProcessStart.length ?? 0}-",
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
