import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hitachi/helper/text/label.dart';

class BoxInputField extends StatelessWidget {
  const BoxInputField(
      {Key? key,
      this.labelText,
      this.controller,
      this.height = 40,
      this.type,
      this.maxLength,
      this.textInputFormatter,
      this.onChanged,
      this.validator,
      this.maxLines})
      : super(key: key);

  final String? labelText;
  final TextEditingController? controller;
  final double height;
  final TextInputType? type;
  final int? maxLength;
  final List<TextInputFormatter>? textInputFormatter;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final int? maxLines;

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
            validator: validator,
            onChanged: onChanged,
            controller: controller,
            maxLength: maxLength,
            keyboardType: type,
            // maxLines: maxLines,
            decoration: InputDecoration(
              counterText: "",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            inputFormatters: textInputFormatter,
          ),
        ),
      ],
    );
  }
}
