import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFields extends StatefulWidget {
  final TextEditingController controller;
  final bool isObscure;
  final String hintText;
  final IconData? prefixIconData;
  final Widget? suffixIconData;
  final int maxLines;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged; // Add onChanged callback
  final TextInputType keyboard;
  final String? Function(String?)? validate;
  final bool autofocus;
  final bool autovalidate;
  final FocusNode? focusNode;

  const CustomTextFields({
    Key? key,
    required this.controller,
    this.hintText = '',
    this.maxLines = 1,
    this.prefixIconData,
    this.suffixIconData,
    this.onTap,
    this.keyboard = TextInputType.text,
    this.isObscure = false,
    this.validate,
    this.autofocus = false,
    this.autovalidate = false,
    this.focusNode,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomTextFields> createState() => _CustomTextFieldsState();
}

class _CustomTextFieldsState extends State<CustomTextFields> {
  bool _hasFocus = false;
  String? errorText;
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    if (widget.autovalidate) {
      isValid = widget.validate!(widget.controller.text) == null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textFieldHeight =
    errorText == null ? 50.0 * widget.maxLines : 70.0 * widget.maxLines;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        height: textFieldHeight.h,
        child: TextFormField(
          style: TextStyle(
            fontSize: 14.sp, // Adjust the font size as needed
            color: Color(0xFF383838), // Adjust the text color as needed
          ),
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          autovalidateMode: widget.autovalidate
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          keyboardType: widget.keyboard,
          controller: widget.controller,
          onChanged: widget.onChanged, // Pass onChanged callback
          decoration: InputDecoration(
            fillColor: Color(0xFFF9F9F9),
            suffixIcon:widget.suffixIconData,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            hintText: _hasFocus ? '' : widget.hintText,
            hintStyle: const TextStyle(color: Color(0xFF98A2B3)),
            errorText: errorText,
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFD0D5DD),
              ),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFD0D5DD),
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFD0D5DD),
              ),
            ),
          ),
          validator: widget.validate,
          maxLines: widget.maxLines,
          obscureText: widget.isObscure,
        ),
      ),
    );
  }
}
