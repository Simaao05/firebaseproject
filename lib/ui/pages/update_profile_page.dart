import 'package:flutter/material.dart';
import 'package:flutter_social/firebase_services/auth_services.dart';
import 'package:flutter_social/firebase_services/firestore_service.dart';
import 'package:flutter_social/firebase_services/keys.dart';
import 'package:flutter_social/model/member.dart';
import 'package:flutter_social/ui/widgets/column_spacing.dart';
import 'package:flutter_social/ui/widgets/text_field_style.dart';

class UpdateProfilePage extends StatefulWidget {

  final Member member;
  const UpdateProfilePage({super.key, required this.member});

  @override
  UpdateState createState() => UpdateState();

}

class UpdateState extends State<UpdateProfilePage> {

  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.member.name);
    surnameController = TextEditingController(text: widget.member.surname);
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier le profil"),
        actions: [
          TextButton(
            onPressed: () {
              _onValidate();
              Navigator.pop(context);
            }, 
            child: const Text("valider"))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            children: [
              const ColumnSpacing(),
              TextField(
                controller: surnameController,
                decoration: const TextFieldStyle(hint: "Prénom"),
              ),
              const ColumnSpacing(),
              TextField(
                controller: nameController,
                decoration: const TextFieldStyle(hint: "Nom"),
              ),
              const ColumnSpacing(),
              TextField(
                controller: descriptionController,
                decoration: const TextFieldStyle(hint: "Description"),
              ),
              const ColumnSpacing(),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context, 
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Etes vous sur de vouloir vous déconnecter ?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              AuthServices().signOut().then((value) => Navigator.pop(context));
                            }, 
                            child: const Text("OUI")),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            }, 
                            child: const Text("NON")),
                        ],
                      );
                    });
                }, 
                child: const Text("Se déconnecter"))
            ],
          ),
        ),
      ),
    );
  }

  _onValidate() {
    FocusScope.of(context).requestFocus(FocusNode());
    Map<String, dynamic> map = {};
    final member = widget.member;
    if (nameController.text.isNotEmpty && nameController.text != member.name) {
      map[nameKey] = nameController.text;
    }
    if (surnameController.text.isNotEmpty && surnameController.text != member.surname) {
      map[surnameKey] = surnameController.text;
    }
    if (descriptionController.text.isEmpty && descriptionController.text != member.description) {
      map[descriptionKey] = descriptionController.text;
    }
    FirestoreService().updateUser(id:member.id, data: map);
  }

}