import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social/firebase_services/auth_services.dart';
import 'package:flutter_social/firebase_services/firestore_service.dart';
import 'package:flutter_social/firebase_services/keys.dart';
import 'package:flutter_social/model/member.dart';
import 'package:flutter_social/ui/pages/update_profile_page.dart';
import 'package:flutter_social/ui/widgets/camera_button.dart';
import 'package:flutter_social/ui/widgets/circle_avatar.dart';

/*class ProfilePage extends StatelessWidget {

  final Member member;
  const ProfilePage({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreService().postForUser(member.id), 
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        final data = snapshot.data;
        final docs = data?.docs;
        final length = docs?.length ?? 0;
        final isMe = AuthServices().isMe(member.id);
        final indexToAdd = (isMe) ? 2 : 1;
        return ListView.builder(
          itemCount: length + indexToAdd,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  Container(
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                // Image
                                Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  child: (member.coverPicture.isEmpty)
                                  ? const Center()
                                  : Image.network(member.coverPicture, 
                                  fit: BoxFit.cover)
                                ),
                                // Button
                                (isMe)
                                ? CameraButton(
                                  type: coverPictureKey, 
                                  id: member.id)
                                : const Center()
                              ],
                            ),
                            const SizedBox(height: 25)
                          ],
                        ),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            // ImageCirculaire
                            Avatar(
                              radius: 75, 
                              url: member.profilePicture),
                            // Button
                            (isMe)
                            ? CameraButton(
                              type: profilePictureKey, 
                              id: member.id)
                            : const Center()
                          ],
                        ) 
                      ],
                    ),
                  ),
                  Text(member.fullName,
                  style: Theme.of(context).textTheme.titleLarge
                  ),
                  Text(member.description),
                  const Divider(),
                  (isMe)
                  ? OutlinedButton(
                    onPressed: () {
                      final page = UpdateProfilePage(member: member);
                      final route = MaterialPageRoute(builder: ((context) => page));
                      Navigator.of(context).push(route);
                    }, 
                    child: const Text("Modifier le profil"))
                    : const SizedBox(height: 0)
                ],
              );
            }
            return Container(
              child: Text(index.toString())
            );
          }
        );
      }
    );
  }
} */

class ProfilePage extends StatelessWidget {
  final Member member;
  const ProfilePage({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: FirestoreService().postForUser(member.id),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }

            final data = snapshot.data;
            final docs = data?.docs ?? [];
            final isMe = AuthServices().isMe(member.id);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: (member.coverPicture.isEmpty)
                            ? const Center()
                            : Image.network(
                                member.coverPicture,
                                fit: BoxFit.cover,
                              ),
                      ),
                      if (isMe)
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: CameraButton(type: coverPictureKey, id: member.id),
                        ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Avatar(radius: 75, url: member.profilePicture),
                        if (isMe)
                          CameraButton(type: profilePictureKey, id: member.id),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          member.fullName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 8),
                        Text(member.description),
                        SizedBox(height: 16),
                        if (isMe)
                          OutlinedButton(
                            onPressed: () {
                              final page = UpdateProfilePage(member: member);
                              final route = MaterialPageRoute(builder: (context) => page);
                              Navigator.of(context).push(route);
                            },
                            child: const Text("Modifier le profil"),
                          ),
                        Divider(),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      return ListTile(
                        title: Text(doc['title'] ?? ''),
                        subtitle: Text(doc['content'] ?? ''),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
