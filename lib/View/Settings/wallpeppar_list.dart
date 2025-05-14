import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class CustomBackgroundScreen extends StatefulWidget {
  @override
  _CustomBackgroundScreenState createState() => _CustomBackgroundScreenState();
}

class _CustomBackgroundScreenState extends State<CustomBackgroundScreen> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];
  File? _backgroundImage;
  String? _savedImagePath;

  @override
  void initState() {
    super.initState();
    _loadSavedBackground();
  }

  Future<void> _loadSavedBackground() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _savedImagePath = prefs.getString('background_image');
    if (_savedImagePath != null && File(_savedImagePath!).existsSync()) {
      setState(() {
        _backgroundImage = File(_savedImagePath!);
      });
    }
  }

  Future<void> _pickImages() async {
    final List<XFile>? picked = await _picker.pickMultiImage();
    if (picked != null) {
      setState(() {
        _selectedImages = picked.map((xfile) => File(xfile.path)).toList();
      });
    }
  }

  Future<void> _setBackground(File image) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = basename(image.path);
    final savedImage = await image.copy('${appDir.path}/$fileName');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('background_image', savedImage.path);

    setState(() {
      _backgroundImage = savedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom App Background')),
      body: Container(
        decoration: _backgroundImage != null
            ? BoxDecoration(
                image: DecorationImage(
                  image: FileImage(_backgroundImage!),
                  fit: BoxFit.cover,
                ),
              )
            : null,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickImages,
              child: Text('Select Images'),
            ),
            Expanded(
              child: _selectedImages.isEmpty
                  ? Center(child: Text('No images selected'))
                  : GridView.builder(
                      padding: EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _setBackground(_selectedImages[index]),
                          child: Image.file(_selectedImages[index],
                              fit: BoxFit.cover),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
