import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/checkpackNo/check_pack_no_bloc.dart';
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
  int count = 144545;
  @override
  void initState() {
    // testCreateData();
    super.initState();
  }

  // void testCreateData() async {
  //   DatabaseHelper databaseHelper = DatabaseHelper();

  //   // สร้างฐานข้อมูล SQLite และตาราง my_table
  //   //await databaseHelper.initializeDatabase();

  //   // เขียนข้อมูลลงในฐานข้อมูล
  //   await databaseHelper.writeDataToSQLite("Aotza", 20);

  //   // await databaseHelper.deleteDataFromSQLite(3);
  //   // await databaseHelper.deleteDataFromSQLite(4);
  //   // await databaseHelper.deleteDataFromSQLite(5);
  //   // await databaseHelper.deleteDataFromSQLite(6);
  //   // await databaseHelper.deleteDataFromSQLite(7);
  //   // await databaseHelper.deleteDataFromSQLite(8);
  //   // await databaseHelper.deleteDataFromSQLite(9);
  //   // await databaseHelper.deleteDataFromSQLite(10);
  //   // await databaseHelper.deleteDataFromSQLite(11);
  //   // await databaseHelper.deleteDataFromSQLite(12);

  //   print("object");
  // }

  _getdata() {
    BlocProvider.of<CheckPackNoBloc>(context).add(GetCheckPackNoEvent(count));
  }

  @override
  Widget build(BuildContext context) {
    return BgWhite(
      isHidePreviour: false,
      textTitle: "LineElemnt Menu",
      body: Padding(
        padding:
            const EdgeInsets.only(top: 30, bottom: 10, right: 10, left: 10),
        child: Column(
          children: <Widget>[
            CardButton(
              text: "1.Line Element",
              onPress: () =>
                  Navigator.pushNamed(context, RouterList.LINE_ELEMENT_SCREEN),
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
    );
  }
}
