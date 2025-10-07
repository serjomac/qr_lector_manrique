// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';

// class TakePictureScreen extends StatefulWidget {
//   final CameraDescription camera;

//   const TakePictureScreen({required this.camera});

//   @override
//   TakePictureScreenState createState() => TakePictureScreenState();
// }

// class TakePictureScreenState extends State<TakePictureScreen> {
//   late CameraController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(
//       // Configura la cámara seleccionada
//       widget.camera,
//       // Define la resolución a utilizar
//       ResolutionPreset.medium,
//     );

//     // Inicializa el controlador
//     _controller.initialize().then((_) {
//       if (!mounted) return;
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_controller.value.isInitialized) {
//       return Container();
//     }
//     return Scaffold(
//       appBar: AppBar(title: Text('Toma una foto')),
//       // Usa un Stack para colocar el marco sobre la vista previa de la cámara
//       body: Stack(
//         alignment: Alignment.center,
//         children: <Widget>[
//           CameraPreview(_controller), // Vista previa de la cámara
//           // Aquí puedes agregar tu marco como un widget
//           Positioned(
//             top: 50,
//             child: Container(
//               width: 300,
//               height: 200,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.red, width: 2),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }