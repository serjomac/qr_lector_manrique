import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextInputType keyBoardType;
  final bool isOscured;
  final String hintText;
  final IconData icono;
  final VoidCallback? onTapIcon;
  final bool autocorect;
  final Function onChange;
  final Function validator;
  const CustomInput({Key? key, required this.keyBoardType, required this.isOscured, required this.hintText, required this.icono, required this.autocorect, required this.onChange, required this.validator, this.onTapIcon }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        validator(value);
      },
      onSaved: (value) {
        onChange(value);
      },
      autocorrect: autocorect,
      obscureText: isOscured,
      keyboardType: keyBoardType,
      style: const TextStyle(color: Color(0xFF191B2D)),
      decoration: inputDecoration(hintText, icono),
    );
  }


  InputDecoration inputDecoration(String hintText, IconData icono) {
    return InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(45.0)),
        enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Colors.grey, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(45.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(45.0)),
        hintText: hintText,
        suffixIcon: GestureDetector(
          onTap: onTapIcon ?? (){},
          child: Icon(icono, color: const Color(0xFF181A2C),),
        ));
  }
}