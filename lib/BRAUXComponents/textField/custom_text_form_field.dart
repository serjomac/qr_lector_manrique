import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';

class CustomTextFormField extends StatelessWidget {
  final FocusNode focusNode;
  final VoidCallback? onTap;
  final String label;
  final String? hintText;
  final String? initialValue;
  final InkWell? suxffixIcon;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;
  final Function()? onEditingComplete;
  final TextEditingController? controller;
  final bool? obscureText;
  final bool isFLoatingLabelVisible;
  final double? verticalPadding;
  final TextStyle? textStyle;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final TextInputAction? textInputAction;
  final bool? readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final InputDecoration? inputDecoration;
  final bool? autocorect;
  final bool? enabled;
  const CustomTextFormField(
      {Key? key,
      required this.focusNode,
      this.onTap,
      required this.label,
      this.initialValue,
      this.suxffixIcon,
      required this.onChanged,
      this.obscureText,
      this.onEditingComplete,
      this.controller,
      this.isFLoatingLabelVisible = true,
      this.verticalPadding,
      this.textStyle,
      this.maxLength,
      this.inputFormatters,
      this.keyboardType,
      this.textAlign,
      this.textInputAction,
      this.readOnly = false,
      this.validator,
      this.inputDecoration,
      this.autocorect,
      this.enabled,
      this.hintText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      onEditingComplete: onEditingComplete,
      initialValue: initialValue,
      inputFormatters: inputFormatters,
      controller: controller,
      enabled: enabled,
      style: textStyle ??
          TextStyle(fontSize: 17, color: theme.own().primareyTextColor),
      cursorColor: theme.own().primareyTextColor,
      readOnly: readOnly ?? false,
      maxLength: maxLength,
      autocorrect: autocorect ?? true,
      keyboardType: keyboardType ?? TextInputType.text,
      focusNode: focusNode,
      textAlign: textAlign ?? TextAlign.start,
      onChanged: onChanged,
      onTap: onTap,
      textInputAction: textInputAction,
      validator: validator,
      obscureText: obscureText ?? false,
      decoration: inputDecoration ??
          decorationFormCard(
            labelText: label,
            theme: theme,
            focusNode: focusNode,
            suxffixIcon: suxffixIcon,
            isFLoatingLabelVisible: isFLoatingLabelVisible,
            verticalPadding: verticalPadding,
            hint: hintText,
          ),
    );
  }

  static InputDecoration decorationFormCard({
    required String labelText,
    required ThemeData theme,
    required FocusNode focusNode,
    TextStyle? labelStyle,
    InkWell? suxffixIcon,
    bool isFLoatingLabelVisible = false,
    double? verticalPadding,
    String? hint,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(
          vertical: (verticalPadding ?? 0), horizontal: 10.45),
      labelText: isFLoatingLabelVisible ? labelText : null,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintText: hint,
      hintStyle: TextStyle(color: theme.own().tertiaryTextColor!),
      labelStyle: labelStyle ??
          TextStyle(
              color: focusNode.hasFocus
                  ? theme.own().primareyTextColor
                  : theme.own().tertiaryTextColor),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
            color: theme.own().tertiaryTextColor!, style: BorderStyle.solid),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide:
            BorderSide(color: theme.own().tertiaryTextColor!, style: BorderStyle.solid),
      ),
      suffix: suxffixIcon ??
          const SizedBox(
            width: 0,
          ),
      counterText: '',
      errorStyle: TextStyle(
        color: theme.colorScheme.error,
        fontSize: 13,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w500,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
            color: theme.colorScheme.error, style: BorderStyle.solid),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
            color: theme.colorScheme.error, style: BorderStyle.solid),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide:
            BorderSide(color: theme.primaryColor, style: BorderStyle.solid),
      ),
    );
  }
}
