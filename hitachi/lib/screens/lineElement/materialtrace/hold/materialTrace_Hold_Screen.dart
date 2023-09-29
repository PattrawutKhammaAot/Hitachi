import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';

class MaterialTraceHoldScreen extends StatefulWidget {
  const MaterialTraceHoldScreen({super.key});

  @override
  State<MaterialTraceHoldScreen> createState() =>
      _MaterialTraceHoldScreenState();
}

class _MaterialTraceHoldScreenState extends State<MaterialTraceHoldScreen> {
  @override
  Widget build(BuildContext context) {
    return BgWhite(
        isHideAppBar: true,
        body: Column(
          children: [
            Container(
              color: COLOR_SUCESS,
              child: Label("HOLD"),
            )
          ],
        ));
  }
}
