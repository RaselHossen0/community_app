// lib/home/ui/components/CommunityScreen.dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_app/auth/provider/UserState.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/CommunityState.dart';
import 'Chat.dart';
import 'CommunityDetailsScreen.dart';

class CommunityScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communities = ref.watch(communityProvider);
    final user = ref.watch(userProvider.notifier);
    // print('User: ${user.getUser()?.role}');
    // print('Communities: $communities');

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(width: 8),
                Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    _showCreateCommunityDialog(context, ref);
                    // Navigate to create community screen
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  label: Text('Create', style: TextStyle(color: Colors.black)),
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
                  isAdmin: user.getUser()?.uid == community['admin'] ?? false,
                  adminId: community['admin'] ?? '',
                  onPress: () {
                    deleteCommunity(community['id'], ref);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  final _membersController = TextEditingController();

  void _showCreateCommunityDialog(BuildContext context, WidgetRef ref) {
    final _nameController = TextEditingController();
    final _subtitleController = TextEditingController();
    final ImagePicker _picker = ImagePicker();

    XFile? _pickedImage;

    Future<String?> _uploadImage(XFile image) async {
      try {
        EasyLoading.show(status: 'Uploading image...');
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('community_images/${image.name}');
        final uploadTask = storageRef.putFile(File(image.path));
        final snapshot = await uploadTask;
        EasyLoading.showSuccess('Image uploaded successfully');
        return await snapshot.ref.getDownloadURL();
      } catch (e) {
        EasyLoading.showError('Error uploading image');
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
          content: SingleChildScrollView(
            // To handle overflow in smaller screens
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Community Name'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    _showUserSelectionModal(context, ref);
                  },
                  child: Text('Select Members'),
                ),
                TextField(
                  controller: _subtitleController,
                  decoration: InputDecoration(labelText: 'Subtitle'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await _pickImage();
                    if (_pickedImage != null) {
                      EasyLoading.showToast('Image selected');
                    }
                  },
                  child: Text('Pick Community Image'),
                ),
              ],
            ),
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
                  EasyLoading.show(status: 'Creating community...');
                  try {
                    if (_membersController.text.isEmpty) {
                      _membersController.text = ref
                          .read(userProvider.notifier)
                          .getUser()!
                          .uid; // Set the current user as the only member
                    }

                    // Create the new community
                    await ref.read(communityProvider.notifier).createCommunity({
                      'name': _nameController.text,
                      'members': _membersController.text.split(','),
                      'subtitle': _subtitleController.text,
                      'imagePath': _pickedImage != null
                          ? await _uploadImage(_pickedImage!)
                          : null,
                      "admin": ref.read(userProvider.notifier).getUser()?.uid,
                    });
                    EasyLoading.showSuccess('Community created successfully');
                    // Close the dialog
                    Navigator.of(context).pop();
                  } catch (e) {
                    EasyLoading.showError('Failed to create community');
                  } finally {
                    EasyLoading.dismiss();
                  }
                } else {
                  // Show error message
                  EasyLoading.showError('Please fill all fields');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showUserSelectionModal(BuildContext context, WidgetRef ref) {
    final selectedUsers = <String>{}; // Set to hold selected user UIDs
    final usersStream =
        FirebaseFirestore.instance.collection('users').snapshots();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Members',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  StreamBuilder<QuerySnapshot>(
                    stream: usersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                            child: Text("No users found",
                                style: TextStyle(color: Colors.white)));
                      }

                      final users = snapshot.data!.docs;
                      print('Users: $users');
                      for (final user in users) {
                        print('User: ${user.data()}');
                      }

                      return Expanded(
                        child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            print('User11: $user');
                            final userName =
                                user['displayName'] ?? 'Unnamed User';
                            final userEmail = user['email'] ?? '';
                            final userUID = user.id;

                            return ListTile(
                              onTap: () {
                                setState(() {
                                  if (selectedUsers.contains(userUID)) {
                                    selectedUsers.remove(userUID);
                                  } else {
                                    selectedUsers.add(userUID);
                                  }
                                });
                              },
                              leading: CircleAvatar(
                                backgroundImage: user['photoURL'] != null
                                    ? NetworkImage(user['photoURL'])
                                    : null,
                                backgroundColor: Colors.grey,
                                child: user['photoURL'] == null
                                    ? Icon(Icons.person, color: Colors.white)
                                    : null,
                              ),
                              title: Text(userName,
                                  style: TextStyle(color: Colors.white)),
                              subtitle: Text(userEmail,
                                  style: TextStyle(color: Colors.grey)),
                              trailing: Icon(
                                selectedUsers.contains(userUID)
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: selectedUsers.contains(userUID)
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(selectedUsers
                          .toList()); // Return selected users on button press
                    },
                    child: Text('Confirm Selection'),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((selectedMembers) {
      if (selectedMembers != null && selectedMembers.isNotEmpty) {
        // Update the members controller or selected members variable
        _membersController.text = selectedMembers
            .join(', '); // Update the TextField with selected UIDs
      }
    });
  }

  void deleteCommunity(String id, WidgetRef ref) async {
    try {
      final user = ref.read(userProvider.notifier).getUser();
      if (user?.role != 'admin') {
        EasyLoading.showError('Only admins can delete communities');
        return;
      }
      EasyLoading.show(status: 'Deleting community...');
      await ref.read(communityProvider.notifier).deleteCommunity(id);
      EasyLoading.showSuccess('Community deleted successfully');
    } catch (e) {
      EasyLoading.showError('Failed to delete community');
    } finally {
      EasyLoading.dismiss();
    }
  }
}

class CommunityListItem extends StatelessWidget {
  final String name;
  final List<String> members;
  final String subtitle;
  final String imagePath;
  final String id;
  final bool isAdmin;
  final String adminId;
  final Function onPress;
  void _showDeleteCommunityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Community"),
          content: Text("Are you sure you want to delete this community?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                onPress();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  const CommunityListItem({
    Key? key,
    required this.name,
    required this.members,
    required this.subtitle,
    required this.imagePath,
    required this.isAdmin,
    required this.adminId,
    required this.id,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _showDeleteCommunityDialog(context);
      },
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.group);
              },
            ),
          ),
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
                  isAdmin: isAdmin,
                  adminId: adminId,
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
                  adminId: adminId,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
