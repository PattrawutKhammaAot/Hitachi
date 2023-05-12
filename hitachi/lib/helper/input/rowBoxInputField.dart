import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hitachi/helper/text/label.dart';

class RowBoxInputField extends StatelessWidget {
  const RowBoxInputField(
      {Key? key,
      this.labelText,
      this.controller,
      this.height = 50,
      this.type,
      this.maxLength,
      this.textInputFormatter,
      this.onChanged,
      this.validator})
      : super(key: key);

  final String? labelText;
  final TextEditingController? controller;
  final double height;
  final TextInputType? type;
  final int? maxLength;
  final List<TextInputFormatter>? textInputFormatter;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Label(labelText ?? ""),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: height,
            child: TextFormField(
              validator: validator,
              onChanged: onChanged,
              controller: controller,
              maxLength: maxLength,
              keyboardType: type,
              decoration: InputDecoration(
                counterText: "",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
              inputFormatters: textInputFormatter,
            ),
          ),
        ),
      ],
    );
  }
}
