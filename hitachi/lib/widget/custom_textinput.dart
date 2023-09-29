import 'package:flutter/material.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';

class CustomTextInputField extends StatelessWidget {
  const CustomTextInputField(
      {super.key,
      this.labelText,
      this.focusNode,
      this.controller,
      this.readOnly = false,
      this.validator,
      this.maxLines,
      this.suffixIcon,
      this.hintText,
      this.label,
      this.isHideLable = false,
      this.onFieldSubmitted,
      this.onChanged});

  final String? labelText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool readOnly;
  final String? Function(String?)? validator;
  final int? maxLines;
  final Widget? suffixIcon;
  final Widget? label;
  final String? hintText;
  final bool? isHideLable;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        focusNode: focusNode,
        controller: controller,
        readOnly: readOnly,
        enabled: readOnly == false ? true : false,
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.only(left: 10),
            filled: true,
            fillColor: Colors.white,
            label: isHideLable == true
                ? Label(
                    "${labelText}",
                    color: COLOR_BLUE_DARK,
                    fontSize: 16,
                  )
                : null,
            border: OutlineInputBorder()),
      ),
    );
  }
}
