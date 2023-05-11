import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';

class ProcessFinishHoldScreen extends StatefulWidget {
  const ProcessFinishHoldScreen({super.key});

  @override
  State<ProcessFinishHoldScreen> createState() =>
      _ProcessFinishHoldScreenState();
}

class _ProcessFinishHoldScreenState extends State<ProcessFinishHoldScreen> {
  @override
  Widget build(BuildContext context) {
    return BgWhite(isHideAppBar: true, body: Column());
  }
}
