// import 'package:flutter/material.dart';

// class CustomTextField extends StatelessWidget {
//   final String value;
//   final Function(String) onChanged;
//   final Color borderColor;
//   final Color textColor;

//   const CustomTextField({
//     Key? key,
//     required this.value,
//     required this.onChanged,
//     this.borderColor = const Color(0xFF85736F),
//     this.textColor = const Color(0xFF534340),
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 45,
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: borderColor,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: TextFormField(
//         initialValue: value,
//         onChanged: onChanged,
//         style: TextStyle(
//           fontFamily: 'Inter',
//           fontSize: 14,
//           fontWeight: FontWeight.w400,
//           color: textColor,
//         ),
//         decoration: const InputDecoration(
//           contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }
// }
