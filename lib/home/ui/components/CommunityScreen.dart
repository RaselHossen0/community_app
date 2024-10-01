// lib/home/ui/components/CommunityScreen.dart
import 'dart:io';

import 'package:community_app/auth/provider/UserState.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/CommunityState.dart';
import 'Chat.dart';
import 'CommunityDetailsScreen.dart';

final bool isAdmin = true;

class CommunityScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communities = ref.watch(communityProvider);
    final user = ref.watch(userProvider.notifier);
    print('User: ${user.getUser()?.role}');
    print('Communities: $communities');

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Explore'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('My Community'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[900],
                  ),
                ),
                Spacer(),
                if (isAdmin)
                  ElevatedButton.icon(
                    onPressed: () {
                      _showCreateCommunityDialog(context, ref);
                      // Navigate to create community screen
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    label:
                        Text('Create', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF92C9FF),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: communities.map((community) {
                return CommunityListItem(
                  name: community['name'],
                  id: community['id'],
                  // Ensure that the members field is correctly parsed as a List<String>
                  members: List<String>.from(community['members'] ?? []),
                  subtitle: community['subtitle'],
                  imagePath:
                      community['imagePath'] ?? 'assets/images/avatar.png',
                  isAdmin: user.getUser()?.role == 'admin' ?? false,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateCommunityDialog(BuildContext context, WidgetRef ref) {
    final _nameController = TextEditingController();
    final _membersController = TextEditingController();
    final _subtitleController = TextEditingController();
    final ImagePicker _picker = ImagePicker();
    XFile? _pickedImage;

    Future<String?> _uploadImage(XFile image) async {
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('community_images/${image.name}');
        final uploadTask = storageRef.putFile(File(image.path));
        final snapshot = await uploadTask;
        return await snapshot.ref.getDownloadURL();
      } catch (e) {
        print('Error uploading image: $e');
        return null;
      }
    }

    Future<void> _pickImage() async {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        _pickedImage = pickedImage;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Create New Community"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Community Name'),
              ),
              TextField(
                controller: _membersController,
                decoration: InputDecoration(
                    labelText: 'Members (comma-separated UIDs)'),
              ),
              TextField(
                controller: _subtitleController,
                decoration: InputDecoration(labelText: 'Subtitle'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Create"),
              onPressed: () async {
                if (_nameController.text.isNotEmpty &&
                    _subtitleController.text.isNotEmpty) {
                  // Create the new community
                  await ref.read(communityProvider.notifier).createCommunity({
                    'name': _nameController.text,
                    'members': _membersController.text.split(','),
                    'subtitle': _subtitleController.text,
                    'imagePath': _pickedImage != null
                        ? await _uploadImage(_pickedImage!)
                        : null,
                  });

                  // Close the dialog
                  Navigator.of(context).pop();
                } else {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill all fields'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class CommunityListItem extends StatelessWidget {
  final String name;
  final List<String> members;
  final String subtitle;
  final String imagePath;
  final String id;
  final bool isAdmin;

  const CommunityListItem({
    Key? key,
    required this.name,
    required this.members,
    required this.subtitle,
    required this.imagePath,
    required this.isAdmin,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(imagePath),
      ),
      title: Text(name),
      subtitle: Text(subtitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people, color: Colors.grey),
          SizedBox(width: 5),
          Text(members.length.toString() ?? "0"),
        ],
      ),
      onTap: () {
        if (isAdmin) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Chat(
                communityId: id,
                name: name,
                subtitle: subtitle,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CommunityDetailsScreen(
                name: name,
                members: members,
                subtitle: subtitle,
                communityId: id,
              ),
            ),
          );
        }
      },
    );
  }
}
