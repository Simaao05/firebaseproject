import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_social/firebase_services/keys.dart';
import 'package:flutter_social/firebase_services/storage_service.dart';

class FirestoreService {

  // accès à la Base de Données
  static final instance = FirebaseFirestore.instance;

  // accès spécifique collection
  final firestoreUser = instance.collection(memberCollectionKey);
  final firestorePost = instance.collection(postCollectionKey);

  // Streams
  specificUser(String id) => firestoreUser.doc(id).snapshots();
  postForUser(String id) => firestorePost.where(memberIdKey, isEqualTo: id).snapshots();

  // ajouter un utilisateur
  addUser({required String id, required Map<String, dynamic> data}) {
    firestoreUser.doc(id).set(data);
  }

  // Modifier user
  updateUser({required String id, required Map<String, dynamic> data}) {
    firestoreUser.doc(id).update(data);
  }

  // AddImage
  updateImage({required File file, required String folder, required String userId, required String imageName}) {
    StorageService().addImage(file: file, folder: folder, userId: userId, imageName: imageName).then((imageUrl) {
      updateUser(id: userId, data: {imageName: imageUrl});
    });
  }
}