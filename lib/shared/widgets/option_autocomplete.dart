import 'package:flutter/material.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';

class OptionAutocomplete<T> extends StatelessWidget {
  final List<T> options;
  final void Function(T) onSelected;
  final Widget listView;
  const OptionAutocomplete({
    Key? key,
    required this.options,
    required this.onSelected,
    required this.listView
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          width: MediaQuery.of(context).size.width *
              0.87,
          height: options.length * 60,
          constraints: BoxConstraints(maxHeight: 150),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  50)),
          child: listView
        ),
      ),
    );
  }
}
