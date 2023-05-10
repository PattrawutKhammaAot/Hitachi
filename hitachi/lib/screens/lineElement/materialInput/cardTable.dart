import 'package:flutter/material.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/materialtraceModel.dart';

class CardTable extends StatelessWidget {
  const CardTable({super.key, this.items});
  final MaterialTraceModel? items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Label("Material Type"), Label("Material Type")],
    );
  }
}
