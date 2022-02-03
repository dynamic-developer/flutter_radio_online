import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {required this.obscureText,
      required this.hintText,
      required this.icon,
      required this.focusNode,
      required this.cursorColor,
      required this.keyboardType,
      required this.textInputAction,
      required this.onFieldSubmitted,
      required this.nextNode,
      required this.onChanged,
      required this.validator,
      required this.textEditingController})
      : super();

  final bool obscureText;
  final String hintText;
  final IconData icon;
  final FocusNode focusNode;
  final Color cursorColor;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String> onFieldSubmitted;
  final FormFieldValidator<String> validator;
  final FocusNode nextNode;
  final ValueChanged<String> onChanged;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        obscureText: obscureText,
        focusNode: focusNode,
        keyboardType: keyboardType,
        controller: textEditingController,
        onChanged: onChanged,
        cursorColor: cursorColor,
        onFieldSubmitted: onFieldSubmitted,
        textInputAction: textInputAction,
        validator: validator,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16),
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: 14,
                color: Color(0xFF414041),
                fontWeight: FontWeight.w500),
            prefixIcon: Icon(
              icon,
              size: 18,
              color: Color(0xFF6270A1),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            )),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6270A1).withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }
}
