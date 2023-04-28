import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/text/label.dart';

class WindingJobStartHoldScreen extends StatefulWidget {
  const WindingJobStartHoldScreen({Key? key}) : super(key: key);

  @override
  State<WindingJobStartHoldScreen> createState() =>
      _WindingJobStartHoldScreenState();
}

class _WindingJobStartHoldScreenState extends State<WindingJobStartHoldScreen> {
  @override
  Widget build(BuildContext context) {
    return BgWhite(
      textTitle: "Winding job Start",
      body: Column(
        children: [
          Label("Test"),
        ],
      ),
    );
  }
}
