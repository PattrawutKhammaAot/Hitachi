import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/text/label.dart';

class MachineBreakDownScanScreen extends StatefulWidget {
  const MachineBreakDownScanScreen({super.key});

  @override
  State<MachineBreakDownScanScreen> createState() =>
      _MachineBreakDownScanScreenState();
}

class _MachineBreakDownScanScreenState
    extends State<MachineBreakDownScanScreen> {
  @override
  Widget build(BuildContext context) {
    return BgWhite(
        isHideAppBar: true,
        body: Column(
          children: [Label("MachineBreakDownScan")],
        ));
  }
}
