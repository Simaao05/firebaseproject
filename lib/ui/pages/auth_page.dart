import 'package:flutter/material.dart';
import 'package:flutter_social/firebase_services/auth_services.dart';
import 'package:flutter_social/ui/widgets/column_spacing.dart';
import 'package:flutter_social/ui/widgets/text_field_style.dart';

class AuthPage extends StatefulWidget {

  const AuthPage({super.key});

  @override
  AuthState createState() => AuthState();

}

class AuthState extends State<AuthPage> {

  bool accountExists = false;

  late TextEditingController mailController;
  late TextEditingController passwordController;
  late TextEditingController surnameController;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    mailController = TextEditingController();
    passwordController = TextEditingController();
    surnameController = TextEditingController();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    mailController.dispose();
    passwordController.dispose();
    surnameController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlutterLogo(
              size: MediaQuery.of(context).size.width - 100,
              style: FlutterLogoStyle.horizontal,
            ),
            SegmentedButton<bool>(
              segments: const <ButtonSegment<bool>>[
                ButtonSegment(
                  value: false,
                  label: Text("Créer un compte"),
                  icon: Icon(Icons.add_circle)),
                  ButtonSegment(
                    value: true,
                    label: Text("Se connecter"),
                    icon: Icon(Icons.add_circle))
              ], 
              selected: <bool> {accountExists},
              onSelectionChanged: _onSelectionChanged),
              Card(
                elevation: 8,
                margin: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          TextField(
                            controller: mailController,
                            decoration: const TextFieldStyle(hint: "Adresse mail"),
                          ),
                          const ColumnSpacing(),
                          TextField(
                            controller: passwordController,
                            decoration: const TextFieldStyle(hint: "Mot de passe"),
                            obscureText: true,
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      (accountExists)
                      ? const SizedBox(height: 0)
                      : Column(
                        children: [
                          TextField(
                            controller: surnameController,
                            decoration: const TextFieldStyle(hint: "Prénom"),
                          ),
                          const ColumnSpacing(),
                          TextField(
                            controller: nameController,
                            decoration: const TextFieldStyle(hint: "Nom"),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ),
              ElevatedButton(
                onPressed: () {
                  _handleHauth().then((value) {
                    final SnackBar snackBar = SnackBar(content: Text(value ?? ""));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                }, 
                child: const Text("C'est parti !"))
          ],
        ),
      ),)
    );
  }

  Future<String?> _handleHauth() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final result = (accountExists)
    ? await AuthServices().signIn
    (email: mailController.text, 
    password: passwordController.text)
    : await AuthServices().createAccount(
      email: mailController.text, 
      password: passwordController.text, 
      surname: surnameController.text, 
      name: nameController.text
    );
    return result;
  }

  _onSelectionChanged(Set<bool> newValue) {
    setState(() {
      accountExists = newValue.first;
    });
  }
}