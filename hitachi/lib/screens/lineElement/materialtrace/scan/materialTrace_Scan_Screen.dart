import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';

class MaterialTraceScanScreen extends StatefulWidget {
  const MaterialTraceScanScreen({super.key});

  @override
  State<MaterialTraceScanScreen> createState() =>
      _MaterialTraceScanScreenState();
}

class _MaterialTraceScanScreenState extends State<MaterialTraceScanScreen> {
  @override
  Widget build(BuildContext context) {
    return BgWhite(
        isHideAppBar: true,
        body: Column(
          children: [
            Container(
              color: COLOR_SUCESS,
              child: Label("SCAN"),
            )
          ],
        ));
  }
}
