import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';

class WindingRecordHoldScreen extends StatefulWidget {
  const WindingRecordHoldScreen({super.key});

  @override
  State<WindingRecordHoldScreen> createState() =>
      _WindingRecordHoldScreenState();
}

class _WindingRecordHoldScreenState extends State<WindingRecordHoldScreen> {
  @override
  Widget build(BuildContext context) {
    return BgWhite(
        isHideAppBar: true,
        body: Column(
          children: [
            Container(
              color: COLOR_RED_LIGTHINS,
              child: Label("Hold"),
            )
          ],
        ));
  }
}
