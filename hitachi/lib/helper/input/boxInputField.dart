import 'package:flutter/material.dart';
import 'package:hitachi/helper/text/label.dart';

class BoxInputField extends StatelessWidget {
  const BoxInputField(
      {Key? key, this.labelText, this.controller, this.height = 40})
      : super(key: key);

  final String? labelText;
  final TextEditingController? controller;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(labelText ?? ""),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: height,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}
