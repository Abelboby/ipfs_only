import 'package:flutter/material.dart';

class UploadButtonWidget extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onUpload;

  UploadButtonWidget({required this.imagePath, required this.onUpload});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: imagePath != null ? onUpload : null,
      child: Text('Upload to Pinata'),
    );
  }
}