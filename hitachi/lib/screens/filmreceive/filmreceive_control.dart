import 'package:flutter/material.dart';
import 'package:hitachi/config.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/screens/filmreceive/hold/filmReceive_hold_screen.dart';
import 'package:hitachi/screens/filmreceive/scan/filmReceive_scan_screen.dart';
import 'package:hitachi/services/databaseHelper.dart';

class FilmReceiveControlPage extends StatefulWidget {
  const FilmReceiveControlPage({super.key});

  @override
  State<FilmReceiveControlPage> createState() => _FilmReceiveControlPageState();
}

class _FilmReceiveControlPageState extends State<FilmReceiveControlPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    Future.delayed(Duration(microseconds: 10), () {
      setState(() {
        setState(() {
          _selectedIndex = index;
          _getHold();
        });
      });
    });
  }

  List<Widget> widgetOptions = [
    FilmReceiveScanScreen(),
    FilmReceiveHoldScreen()
  ];
  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('DATA_SHEET');
    setState(() {
      listHoldFilmReceive = sql;
    });
  }

  @override
  void initState() {
    _getHold().then((value) => null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      textTitle: Padding(
        padding: const EdgeInsets.only(right: 45),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Label("Film Receive"),
            SizedBox(
              width: 10,
            ),
            Label(
              "-${listHoldFilmReceive.length ?? 0}-",
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
