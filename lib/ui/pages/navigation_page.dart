import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social/firebase_services/auth_services.dart';
import 'package:flutter_social/firebase_services/firestore_service.dart';
import 'package:flutter_social/model/member.dart';
import 'package:flutter_social/ui/pages/profile_page.dart';
import 'package:flutter_social/ui/widgets/empty_widgets.dart';

class NavigationPage extends StatefulWidget {

  const NavigationPage({super.key});

  @override
  NavigationState createState() => NavigationState();

}

class NavigationState extends State<NavigationPage> {

  int index = 0;

  @override
  Widget build(BuildContext context) {

    final memberId = AuthServices().myId;

    return (memberId == null)
    ? const EmptyScaffold()
    : StreamBuilder<DocumentSnapshot>(
      stream: FirestoreService().specificUser(memberId), 
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          final Member member = Member(
            reference: data.reference, 
            id: data.id, 
            map: data.data() as Map<String, dynamic>
          );
          List<Widget> bodies = [
            const Center(child: Text("Accueil")),
            const Center(child: Text("Membres")),
            const Center(child: Text("Nouveau post")),
            const Center(child: Text("Notifications")),
            ProfilePage(member: member),
          ];
          return Scaffold(
            appBar: AppBar(
              title: Text(member.fullName),
            ),
            bottomNavigationBar: NavigationBar(
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              selectedIndex: index,
              onDestinationSelected: (int newValue) {
                setState(() {
                  index = newValue;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home), 
                  label: "Accueil"),
                NavigationDestination(
                  icon: Icon(Icons.group), 
                  label: "Membres"),
                NavigationDestination(
                  icon: Icon(Icons.border_color), 
                  label: "Nouveau"),
                NavigationDestination(
                  icon: Icon(Icons.notifications), 
                  label: "Notifications"),
                NavigationDestination(
                  icon: Icon(Icons.person), 
                  label: "Profil"),
              ],
            ),
            body: bodies[index],
          );
        } else {
          return const EmptyScaffold();
        }
      }
    );
  }
}