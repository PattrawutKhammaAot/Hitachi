import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/route/router_list.dart';

class DownLoadMasterScreen extends StatefulWidget {
  const DownLoadMasterScreen({super.key});

  @override
  State<DownLoadMasterScreen> createState() => _DownLoadMasterScreenState();
}

class _DownLoadMasterScreenState extends State<DownLoadMasterScreen> {
  @override
  Widget build(BuildContext context) {
    return BgWhite(
        textTitle: Label("Download Master Menu"),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(COLOR_BLUE_DARK)),
                          onPressed: () => Navigator.pushNamed(
                              context, RouterList.productionSpecScreen),
                          child: Label(
                            "Production Spec.",
                            color: COLOR_WHITE,
                          )),
                    ),
                  ],
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(COLOR_BLUE_DARK)),
                          onPressed: () => Navigator.pushNamed(
                              context, RouterList.dropdownScreen),
                          child: Label(
                            "Dropdown",
                            color: COLOR_WHITE,
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
