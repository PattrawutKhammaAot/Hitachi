import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hitachi/helper/text/label.dart';

class RowBoxInputField extends StatelessWidget {
  const RowBoxInputField({
    Key? key,
    this.labelText,
    this.controller,
    this.height = 50,
    this.type,
    this.maxLength,
    this.textInputFormatter,
    this.onChanged,
    this.validator,
    this.textColor = Colors.black,
    this.focusNode,
    this.onEditingComplete,
    this.enabled,
    // this.onFieldSubmitted
  }) : super(key: key);

  final String? labelText;
  final TextEditingController? controller;
  final double height;
  final TextInputType? type;
  final int? maxLength;
  final List<TextInputFormatter>? textInputFormatter;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Color textColor;
  final Function()? onEditingComplete;
  final FocusNode? focusNode;
  final bool? enabled;
  // final Function()? onFieldSubmitted;
  // final Function(String)? onChanged;

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
              focusNode: focusNode,
              onEditingComplete: () => onEditingComplete?.call(),
              validator: validator,
              onChanged: onChanged,
              controller: controller,
              style: TextStyle(color: textColor),
              maxLength: maxLength,
              keyboardType: type,
              enabled: enabled,
              // textInputAction: textInputAction,
              // onFieldSubmitted: () => onFieldSubmitted?.call(),
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
