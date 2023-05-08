import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/cardButton.dart';
import 'package:hitachi/models/checkPackNo_Model.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:hitachi/services/databaseHelper.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    testCreateData();
    super.initState();
  }

  void testCreateData() async {
    // สร้างฐานข้อมูล SQLite และตาราง my_table
    await databaseHelper.initializeDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      isHidePreviour: false,
      textTitle: "LineElemnt Menu",
      body: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 10, right: 10, left: 10),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                CardButton(
                  text: "1.Line Element",
                  onPress: () => Navigator.pushNamed(
                      context, RouterList.LINE_ELEMENT_SCREEN),
                ),
                SizedBox(
                  height: 15,
                ),
                CardButton(
                  text: "2.Plan Winding",
                  onPress: () => print("test2"),
                ),
                SizedBox(
                  height: 15,
                ),
                CardButton(
                  text: "3.Machine Breakdown",
                  onPress: () => print("test2"),
                ),
                SizedBox(
                  height: 15,
                ),
                CardButton(
                  text: "4.PM Daily",
                  onPress: () => print("test2"),
                ),
                SizedBox(
                  height: 15,
                ),
                CardButton(
                  text: "5.Film Receive",
                  onPress: () => print("test2"),
                ),
                SizedBox(
                  height: 15,
                ),
                CardButton(
                  text: "6.Zinc Thickness",
                  onPress: () => print("test2"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
