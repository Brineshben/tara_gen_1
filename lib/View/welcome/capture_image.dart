import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:ihub/Utils/api_constant.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';

class CaptureAndQrPage extends StatefulWidget {
  const CaptureAndQrPage({super.key});

  @override
  State<CaptureAndQrPage> createState() => _CaptureAndQrPageState();
}

class _CaptureAndQrPageState extends State<CaptureAndQrPage> {
  CameraController? _cameraController;
  XFile? _capturedImage;
  String? qrData;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras
        .firstWhere((cam) => cam.lensDirection == CameraLensDirection.front);

    _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
    await _cameraController!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    setState(() => isLoading = true);

    final image = await _cameraController!.takePicture();
    final compositeFile = await _createCompositeImage(File(image.path));
    await _uploadImage(compositeFile);
    _capturedImage = XFile(compositeFile.path);

    setState(() {
      _capturedImage = XFile(compositeFile.path);
      isLoading = false;
    });
  }

  Future<File> _createCompositeImage(File cameraImage) async {
    try {
      // Load the camera image
      final imageBytes = await cameraImage.readAsBytes();
      final ui.Image cameraUiImage = await decodeImageFromList(imageBytes);

      // Load the frame asset
      final ByteData frameData = await rootBundle.load('assets/frame.png');
      final Uint8List frameBytes = frameData.buffer.asUint8List();
      final ui.Image frameUiImage = await decodeImageFromList(frameBytes);

      // Create a canvas to composite the images
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      // Get the size for the composite (use camera image size)
      final Size canvasSize = Size(
        cameraUiImage.width.toDouble(),
        cameraUiImage.height.toDouble(),
      );

      // Draw the camera image first
      canvas.drawImage(cameraUiImage, Offset.zero, Paint());

      // Calculate frame scaling to match camera image size
      final double scaleX = canvasSize.width / frameUiImage.width;
      final double scaleY = canvasSize.height / frameUiImage.height;

      // Draw the frame overlay scaled to match camera image
      canvas.save();
      canvas.scale(scaleX, scaleY);
      canvas.drawImage(frameUiImage, Offset.zero, Paint());
      canvas.restore();

      // Convert to image
      final picture = recorder.endRecording();
      final ui.Image compositeImage = await picture.toImage(
        canvasSize.width.toInt(),
        canvasSize.height.toInt(),
      );

      // Convert to bytes
      final ByteData? pngBytes = await compositeImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (pngBytes == null) {
        throw Exception('Failed to convert composite image to bytes');
      }

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final compositeFile = File(
          '${tempDir.path}/composite_${DateTime.now().millisecondsSinceEpoch}.png');
      await compositeFile.writeAsBytes(pngBytes.buffer.asUint8List());

      return compositeFile;
    } catch (e) {
      print('Composite image creation error: $e');
      return cameraImage;
    }
  }

  Future<void> _uploadImage(File file) async {
    setState(() => isUploading = true);

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://50.19.192.156/image/"),
      );
      request.files.add(await http.MultipartFile.fromPath('image', file.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        final imageUrl =
            RegExp(r'"image"\s*:\s*"([^"]+)"').firstMatch(res.body)?.group(1) ??
                '';
        setState(() {
          qrData = imageUrl;
        });
      }
    } catch (e) {
      print('Upload error: $e');
    }

    setState(() => isUploading = false);
  }

  void _resetCamera() {
    setState(() {
      _capturedImage = null;
      qrData = null;
      isUploading = false;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  int _countdown = 0;

  bool isLoading = false;

  void _startCountdown() async {
    setState(() {
      _countdown = 5;
    });

    for (int i = 5; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        _countdown = i - 1;
      });
    }
    await _captureImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            _capturedImage == null ? _buildCameraView() : _buildCapturedView(),
      ),
    );
  }

  Widget _buildCameraView() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(
          child: CircularProgressIndicator(
        color: Colors.white,
      ));
    }

    return Stack(
      children: [
        // Full screen camera preview
        Positioned.fill(
          child: CameraPreview(_cameraController!),
        ),

        Positioned.fill(
          child: Image.asset(
            "assets/frame.png",
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          top: 16,
          left: 16,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.5),
              shape: const CircleBorder(),
            ),
          ),
        ),

        // Capture button
        Positioned(
          left: 80,
          top: 80,
          child: Center(
            child: GestureDetector(
              onTap: _startCountdown,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 4,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 40,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),

        if (_countdown > 0)
          Center(
            child: Text(
              '$_countdown',
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCapturedView() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF608878).withOpacity(0.2), // light green
                Color(0xFF18221E).withOpacity(0.2), // dark green
              ],
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                onPressed: _resetCamera,
                icon: const Icon(Icons.arrow_back),
              ),
              const Expanded(
                child: Text(
                  'Captured Image & QR',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
          child: Row(
            spacing: 30,
            children: [
              Expanded(
                flex: 2,
                child: BaseGlassmorphism(
                  padding: EdgeInsetsGeometry.all(10),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_capturedImage!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: BaseGlassmorphism(
                  child: Column(
                    spacing: 20,
                    children: [
                      _buildQrSection(),
                      InkWell(
                        onTap: () {
                          _resetCamera();
                        },
                        child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                                child: Text(
                              "Take Another",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ))),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          "Done",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQrSection() {
    if (isUploading) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: Colors.white,
          ),
          SizedBox(height: 16),
          Text(
            'Uploading image...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      );
    }

    if (qrData != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                QrImageView(
                  data: qrData!,
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: const Text(
                    "People can scan this  Qr Code with their smartphone camera to see this image",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.qr_code,
          size: 64,
          color: Colors.grey,
        ),
        SizedBox(height: 16),
        Text(
          'QR code will appear here',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
