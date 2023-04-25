import 'package:flutter/material.dart';
import 'package:hitachi/helper/text/label.dart';

class BoxInputField extends StatelessWidget {
  const BoxInputField({Key? key, this.labelText, this.controller})
      : super(key: key);

  final String? labelText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(labelText ?? ""),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
