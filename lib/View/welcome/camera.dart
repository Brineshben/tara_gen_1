// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';

// class CameraWithFrame extends StatefulWidget {
//   const CameraWithFrame({super.key});

//   @override
//   State<CameraWithFrame> createState() => _CameraWithFrameState();
// }

// class _CameraWithFrameState extends State<CameraWithFrame> {
//   CameraController? _controller;
//   List<CameraDescription>? _cameras;
//   bool _isInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _initCamera();
//   }

//   Future<void> _initCamera() async {
//     _cameras = await availableCameras();
//     _controller = CameraController(_cameras![0], ResolutionPreset.high);
//     await _controller!.initialize();
//     if (mounted) {
//       setState(() => _isInitialized = true);
//     }
//   }

//   Future<void> _takePicture() async {
//     if (!_controller!.value.isInitialized) return;

//     final picture = await _controller!.takePicture();
//     print("Image saved at: ${picture.path}");
//     // You can now upload this image and generate QR code with its URL
//     // 1.33 /image/   /image/get/
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isInitialized
//           ? Stack(
//               children: [
//                 // 📷 Camera preview
//                 CameraPreview(_controller!),

//                 // 🔲 Overlay Frame
//                 Center(
//                   child: Container(
//                     width: 250,
//                     height: 250,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.green, width: 3),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                 ),

//                 // 📸 Capture Button
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: FloatingActionButton(
//                       onPressed: _takePicture,
//                       child: const Icon(Icons.camera),
//                     ),
//                   ),
//                 )
//               ],
//             )
//           : const Center(child: CircularProgressIndicator()),
//     );
//   }
// }
