// lib/home/ui/screens/CommunityMembersScreen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommunityMembersScreen extends StatelessWidget {
  final String communityId;

  CommunityMembersScreen({required this.communityId});

  Future<List<Map<String, dynamic>>> _fetchMembers(
      List<String> memberUids) async {
    final firestore = FirebaseFirestore.instance;
    final members = await Future.wait(memberUids.map((uid) async {
      final doc = await firestore.collection('users').doc(uid).get();
      return doc.data()!;
    }).toList());
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

              return ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(member['image'] ??
                          'https://png.pngtree.com/png-vector/20191101/ourmid/pngtree-cartoon-color-simple-male-avatar-png-image_1934459.jpg'),
                    ),
                    title: Text(member['displayName'] ?? "N/A",
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(member['email'] ?? "N/A",
                        style: TextStyle(color: Colors.grey)),
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
