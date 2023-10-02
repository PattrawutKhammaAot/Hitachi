import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/text/label.dart';

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
        body: Column(
          children: [],
        ));
  }
}
