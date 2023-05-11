import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/text/label.dart';

class MachineBreakDownHoldScreen extends StatefulWidget {
  const MachineBreakDownHoldScreen({super.key});

  @override
  State<MachineBreakDownHoldScreen> createState() =>
      _MachineBreakDownHoldScreenState();
}

class _MachineBreakDownHoldScreenState
    extends State<MachineBreakDownHoldScreen> {
  @override
  Widget build(BuildContext context) {
    return BgWhite(
        isHideAppBar: true,
        body: Column(
          children: [Label("MachineBreakDownHold")],
        ));
  }
}
