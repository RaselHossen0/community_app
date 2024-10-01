// lib/home/ui/screens/InfoScreen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/data/UserService.dart';
import '../../../auth/models/User.dart';
import '../../../auth/provider/UserState.dart';
import '../providers/CommunityState.dart';
import 'CommunityMembersScreen.dart';

class InfoScreen extends ConsumerWidget {
  final String communityId;

  InfoScreen({required this.communityId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider.notifier).getUser();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Info',
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
      body: Column(
        children: [
          ListTile(
            title: Text(
              'See Community Members',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CommunityMembersScreen(communityId: communityId),
                ),
              );
            },
          ),
          Divider(color: Colors.grey[800], height: 1),
          ListTile(
            title: Text(
              'Leave Community',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(Icons.logout, color: Colors.white),
            onTap: () async {
              if (user != null) {
                await ref
                    .read(communityProvider.notifier)
                    .leaveCommunity(communityId, user.uid);
                Navigator.of(context).pop();
              }
            },
          ),
          if (user != null && user.uid == 'admin')
            Column(
              children: [
                Divider(color: Colors.grey[800], height: 1),
                ListTile(
                  title: Text(
                    'Delete Community',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Icon(Icons.delete, color: Colors.white),
                  onTap: () async {
                    await ref
                        .read(communityProvider.notifier)
                        .deleteCommunity(communityId);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          Divider(color: Colors.grey[800], height: 1),
          ListTile(
            title: Text(
              'Add Members',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              _showAddMemberDialog(context, ref);
            },
          ),
          Divider(color: Colors.grey[800], height: 1),
        ],
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context, WidgetRef ref) {
    final userService = UserService();
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 600,
          child: CupertinoAlertDialog(
            title: Text("Add Members"),
            content: FutureBuilder<List<User>>(
              future: userService.getAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text('No users found'));
                }
                final users = snapshot.data!;
                return Container(
                  height: 300, // Fixed height
                  child: ScrollConfiguration(
                    behavior: ScrollBehavior().copyWith(overscroll: false),
                    child: GlowingOverscrollIndicator(
                      axisDirection: AxisDirection.down,
                      color: Colors.transparent,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return Material(
                            // Wrap with Material
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(user.photoURL ??
                                    'https://via.placeholder.com/150'),
                              ),
                              title: Text(user.displayName ?? 'No Name'),
                              subtitle: Text(user.email ?? 'No Email'),
                              trailing: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () async {
                                  await ref
                                      .read(communityProvider.notifier)
                                      .addMember(communityId, user.uid);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            actions: [
              CupertinoDialogAction(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
