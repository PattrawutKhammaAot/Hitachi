import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      this.keyboardType,
      this.textInputFormatter,
      this.onChanged,
      this.maxLength,
      this.onEditingComplete});

  final String? labelText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final List<TextInputFormatter>? textInputFormatter;
  final bool readOnly;
  final String? Function(String?)? validator;
  final int? maxLines;
  final Widget? suffixIcon;
  final Widget? label;
  final String? hintText;
  final bool? isHideLable;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final int? maxLength;
  final Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        focusNode: focusNode,
        controller: controller,
        readOnly: readOnly,
        enabled: readOnly == false ? true : false,
        maxLines: maxLines ?? 1,
        keyboardType: keyboardType,
        onEditingComplete: onEditingComplete,
        maxLength: maxLength,
        inputFormatters: textInputFormatter,
        decoration: InputDecoration(
            counterText: '',
            focusedErrorBorder:
                OutlineInputBorder(borderSide: BorderSide(color: COLOR_RED)),
            errorStyle: TextStyle(color: COLOR_RED),
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
