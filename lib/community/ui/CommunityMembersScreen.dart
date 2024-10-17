// lib/home/ui/screens/CommunityMembersScreen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommunityMembersScreen extends StatelessWidget {
  final String communityId;
  final String adminId;

  CommunityMembersScreen({required this.communityId, required this.adminId});

  Future<List<Map<String, dynamic>>> _fetchMembers(
      List<String> memberUids) async {
    print(memberUids);
    final firestore = FirebaseFirestore.instance;
    List<Map<String, dynamic>> members = [];

    for (var uid in memberUids) {
      try {
        final doc = await firestore.collection('users').doc(uid).get();
        print(doc.data());
        if (doc.exists) {
          members.add(doc.data() as Map<String, dynamic>);
        }
      } catch (e) {
        print(e);
      }
    }

    return members;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Community Members',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('communities')
            .doc(communityId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
                child: Text('No data found',
                    style: TextStyle(color: Colors.white)));
          }
          final community = snapshot.data!.data() as Map<String, dynamic>;
          final memberUids = List<String>.from(community['members'] ?? []);

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchMembers(memberUids),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(
                    child: Text('No members found',
                        style: TextStyle(color: Colors.white)));
              }
              final members = snapshot.data!;
              final user = FirebaseAuth.instance.currentUser;

              return ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  print(member);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(member['photoURL'] ??
                          'https://png.pngtree.com/png-vector/20191101/ourmid/pngtree-cartoon-color-simple-male-avatar-png-image_1934459.jpg'),
                    ),
                    title: Text(member['displayName'] ?? "N/A",
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(member['email'] ?? "N/A",
                        style: TextStyle(color: Colors.grey)),
                    trailing: Text(adminId == user!.uid ? 'Admin' : 'Member',
                        style: TextStyle(color: Colors.white)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
