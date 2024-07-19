import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_services/keys.dart';

class Member {

  // Propriétés Stockées
  DocumentReference reference; // Chemin vers le document
  String id; // Id Unique du document
  Map<String, dynamic> map; // Champs

  // Constructeur
  Member({required this.reference, required this.id, required this.map});

  // Propriétés calculées
  String get name => map[nameKey] ?? "";
  String get surname => map[surnameKey] ?? "";
  String get profilePicture => map[profilePictureKey] ?? "";
  String get coverPicture => map[coverPicture] ?? "";
  String get description => map[description] ?? "";
  String get fullName => "$surname $name";
}