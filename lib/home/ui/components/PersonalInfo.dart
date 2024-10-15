// lib/home/ui/components/PersonalInfo.dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../auth/provider/UserState.dart';

class PersonalInfo extends ConsumerStatefulWidget {
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends ConsumerState<PersonalInfo> {
  bool isEditing = false;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    nameController = TextEditingController(text: user?.displayName ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Personal Information',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (isEditing) {
                _saveChanges();
              }
              setState(() {
                isEditing = !isEditing;
              });
            },
            child: Text(
              isEditing ? 'Save' : 'Edit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfilePicture(user?.photoURL ?? ""),
                _buildInfoItem(
                    "Full Name", user?.displayName ?? "N/A", nameController),
                Divider(color: Colors.grey[800], height: 1),
                _buildInfoItem("Email", user?.email ?? "N/A", emailController),
                Divider(color: Colors.grey[800], height: 1),
                _buildInfoItem("Password", "********************",
                    isEditing ? passwordController : null),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture(String imageUrl) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: _pickedImage != null
                ? FileImage(File(_pickedImage!.path))
                : (imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : AssetImage('assets/images/default_avatar.png'))
                    as ImageProvider,
          ),
          if (isEditing)
            TextButton(
              onPressed: _pickImage,
              child:
                  Text('Change Photo', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
      String title, String value, TextEditingController? controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          isEditing && controller != null
              ? TextField(
                  controller: controller,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: Color(0xFF2C2C2E),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                )
              : Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = pickedImage;
    });
  }

  void _saveChanges() async {
    final user = ref.read(userProvider)!;
    final updatedUser = user.copyWith(
      displayName: nameController.text,
      email: emailController.text,
    );

    try {
      // Show loading indicator
      EasyLoading.show(status: 'Updating...');

      // Update email and password in Firebase Auth
      if (emailController.text.isNotEmpty) {
        await FirebaseAuth.instance.currentUser!
            .updateEmail(emailController.text);
      }

      if (passwordController.text.isNotEmpty) {
        await FirebaseAuth.instance.currentUser!
            .updatePassword(passwordController.text);
      }

      // Upload the new profile picture to Firebase Storage
      if (_pickedImage != null) {
        final storageRef =
            FirebaseStorage.instance.ref().child('user_photos/${user.uid}.jpg');
        await storageRef.putFile(File(_pickedImage!.path));
        final newPhotoUrl = await storageRef.getDownloadURL();

        // Update the photo URL in Firebase Auth
        await FirebaseAuth.instance.currentUser!.updatePhotoURL(newPhotoUrl);

        // Update the user document in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          if (nameController.text.isNotEmpty)
            'displayName': nameController.text,
          if (emailController.text.isNotEmpty) 'email': emailController.text,
          if (newPhotoUrl.isNotEmpty) 'photoURL': newPhotoUrl,
        });

        // Update the local state with the new photoURL
        final updatedUserWithPhoto =
            updatedUser.copyWith(photoURL: newPhotoUrl);
        ref.read(userProvider.notifier).updateUser(updatedUserWithPhoto);
        ref.read(userProvider.notifier).getUser();
      } else {
        // Update Firestore info without a new photo
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          if (nameController.text.isNotEmpty)
            'displayName': nameController.text,
          if (emailController.text.isNotEmpty) 'email': emailController.text,
        });
        ref.read(userProvider.notifier).getUser();
      }

      // Dismiss loading and show success message
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("User information updated successfully"),
      ));
    } catch (e) {
      // Dismiss loading and show error message
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error updating information: ${e.toString()}"),
      ));
    }
  }
}
