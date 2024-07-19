import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_social/firebase_services/firestore_service.dart';
import 'package:flutter_social/firebase_services/keys.dart';
import 'package:image_picker/image_picker.dart';

class CameraButton extends StatelessWidget {

  final String type;
  final String id;

  const CameraButton({super.key, required this.type, required this.id});


  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context, 
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Choisissez le Média"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _takePicture(ImageSource.camera, type);
                  }, 
                  child: const Text("Appareil photo")
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _takePicture(ImageSource.gallery, type);
                  }, 
                  child: const Text("Gallerie de photo")
                ),
              ],
            );
          }
        );
      }, 
      icon: const Icon(Icons.camera_alt)
    );
  }

  _takePicture(ImageSource source, String type) async {
    final XFile? xFile = await ImagePicker().pickImage(source: source, maxWidth: 500);
    if (xFile == null) return;
    final File file = File(xFile!.path);
    FirestoreService().updateImage(
      file: file, 
      folder: memberCollectionKey, 
      userId: id, 
      imageName: type);
  }
}