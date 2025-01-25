import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({super.key});

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  bool _isUploading = false;
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  File? _imageFile;

  // Pick image method
  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      } else {
        // User canceled the picker
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No image selected")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image: $e")),
      );
    }
  }

  // Upload image method
  Future<void> uploadImage() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image to upload")),
      );
      return;
    }

    try {
      setState(() {
        _isUploading = true;
      });

      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final String filePath = 'uploads/$fileName.jpg';

      // Upload file to Supabase Storage
      final bytes = await _imageFile!.readAsBytes();
      final response = await _supabaseClient.storage
          .from('images')
          .uploadBinary(filePath, bytes);

      if (response.error == null) {
        final String publicUrl =
            _supabaseClient.storage.from('images').getPublicUrl(filePath);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image uploaded successfully: $publicUrl")),
        );
      } else {
        throw Exception(response.error!.message);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload image: $e")),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
            child: const Text(
          'Image Picker Example',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image preview
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    height: 500,
                    width: 300,
                    fit: BoxFit.cover,
                  )
                : const Text("No image selected"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Pick Image from Gallery"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUploading ? null : uploadImage,
              child: _isUploading
                  ? const CircularProgressIndicator()
                  : const Text("Upload Image"),
            ),
          ],
        ),
      ),
    );
  }
}

extension on String {
  get error => null;
}
