import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../auth/provider/UserState.dart';
import '../../home/model/NewsModel.dart';
// Make sure this import points to the correct location of your NewsDetails widget
import '../controller/NewsProvider.dart';
import 'NewsDetails.dart';

class NewsPage extends ConsumerStatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends ConsumerState<NewsPage> {
  String selectedCategory = 'All News';

  final Color readTimeColor = Color(0xFF92C9FF);

  @override
  Widget build(BuildContext context) {
    final newsAsyncValue = selectedCategory == 'All News'
        ? ref.watch(newsProvider)
        : ref.watch(newsByCategoryProvider(selectedCategory));
    final user = ref.watch(userProvider);
    final isAdmin = user?.role == 'admin' ?? false;

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () => _showAddNewsDialog(context, ref),
              child: Icon(Icons.add),
            )
          : null,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildChip('All News',
                          isSelected: selectedCategory == 'All News'),
                      _buildChip('Latest News',
                          isSelected: selectedCategory == 'Latest News'),
                      _buildChip('Community News',
                          isSelected: selectedCategory == 'Community News'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: newsAsyncValue.when(
                  data: (newsList) {
                    final DateTime today = DateTime.now();
                    final DateTime tenDaysAgo =
                        today.subtract(Duration(days: 10));

// Filter the news list for items within the last 10 days
                    final List<News> filteredNewsList = newsList
                        .where((news) =>
                            DateTime.parse(news.date).isAfter(tenDaysAgo))
                        .toList();
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          // Horizontal News Section
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.32,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: newsList.length,
                              itemBuilder: (context, index) {
                                final news = newsList[index];
                                return _buildHorizontalNewsCard(
                                    news.title,
                                    news.imagePath,
                                    news.readTime,
                                    news.date,
                                    context,
                                    news.content);
                              },
                            ),
                          ),
                          SizedBox(height: 16),

                          // Recent News Section Title
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recent News',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 8),

                          // Vertical News List Section
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: filteredNewsList.length,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            itemBuilder: (context, index) {
                              final news = filteredNewsList[index];
                              return _buildSmallNewsCard(
                                  news.title,
                                  news.imagePath,
                                  news.readTime,
                                  news.date,
                                  context,
                                  news.content,
                                  news.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = label;
          });
        },
        child: Chip(
          label: Text(label),
          backgroundColor: isSelected ? Colors.white12 : Colors.transparent,
          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey),
        ),
      ),
    );
  }

  Widget _buildHorizontalNewsCard(String title, String imagePath,
      String readTime, String date, BuildContext context, String content) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetails(
              title: title,
              imagePath: imagePath,
              readTime: readTime,
              date: date,
              content: content,
            ),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.25,
        child: Card(
          color: Colors.grey[900],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Image.network(
                  imagePath,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return SvgPicture.asset('assets/icons/newsP.svg',
                        height: 180, width: double.infinity, fit: BoxFit.cover);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            child: Text(readTime,
                                style: TextStyle(color: readTimeColor))),
                        Text(
                          formatDate(date), // Use the formatted date
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatDate(String date) {
    final DateTime dateTime =
        DateTime.parse(date); // Convert string to DateTime
    return DateFormat.yMMMd().format(
        dateTime); // Format date to a readable format (e.g., Jan 1, 2024)
  }

  Widget _buildSmallNewsCard(String title, String imagePath, String readTime,
      String date, BuildContext context, String content, String newsId) {
    final user = ref.watch(userProvider);
    final isAdmin = user?.role == "admin" ?? false;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetails(
              title: title,
              imagePath: imagePath,
              readTime: readTime,
              date: date,
              content: content,
            ),
          ),
        );
      },
      onLongPress: isAdmin // Only show delete option if the user is an admin
          ? () {
              _showDeleteConfirmationDialog(context, newsId);
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return SvgPicture.asset('assets/icons/newsP.svg',
                      width: 100, height: 100, fit: BoxFit.cover);
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(readTime, style: TextStyle(color: readTimeColor)),
                      Text(formatDate(date),
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String newsId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete News"),
          content: Text("Are you sure you want to delete this news item?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteNews(newsId, context);
                Navigator.of(context).pop(); // Close the dialog after deletion
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteNews(String newsId, BuildContext context) async {
    try {
      EasyLoading.show(status: 'Deleting...');

      // Delete the news from Firestore
      await ref.read(newsRepositoryProvider).deleteNews(newsId);
      final newValue = ref.refresh(newsProvider);
      print(newValue.value?.length);
      // Refresh the news list

      EasyLoading.dismiss();
      EasyLoading.showSuccess('News deleted');
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Failed to delete');
    }
  }

  void _showAddNewsDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController readTimeController = TextEditingController();
    final TextEditingController contentController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();

    String? _imageUrl;
    XFile? _pickedImage;
    final picker = ImagePicker();

    // Pick image from gallery
    Future<void> _pickImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _pickedImage = pickedFile;
        EasyLoading.show(status: 'Uploading image...');
        try {
          // Upload image to Firebase Storage
          final storageRef = FirebaseStorage.instance.ref().child(
              'news_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
          final uploadTask = await storageRef.putFile(File(_pickedImage!.path));
          _imageUrl = await uploadTask.ref.getDownloadURL();
          EasyLoading.showSuccess('Image uploaded!');
        } catch (e) {
          EasyLoading.showError('Image upload failed!');
        }
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900], // Dark background
          title: Text(
            'Add News',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Title field
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                // Image picker
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _pickedImage == null
                        ? Text(
                            'Pick an image',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[400]),
                          )
                        : Image.file(File(_pickedImage!.path)),
                  ),
                ),
                SizedBox(height: 10),
                // Read Time field
                TextField(
                  controller: readTimeController,
                  decoration: InputDecoration(
                    labelText: 'Read Time',
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                // Content field
                TextField(
                  controller: contentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                // Category field
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add', style: TextStyle(color: Colors.blue)),
              onPressed: () async {
                // Show loading indicator before processing
                EasyLoading.show(status: 'Processing...');

                // Check if the current user is an admin
                final user = ref.read(userProvider);
                final isAdmin = user?.role == 'admin' ?? false;

                if (isAdmin) {
                  if (_imageUrl == null) {
                    EasyLoading.dismiss(); // Dismiss loading indicator
                    EasyLoading.showError('Please upload an image');
                    return;
                  }

                  try {
                    // Create a News object
                    final news = News(
                      title: titleController.text,
                      imagePath: _imageUrl!, // Use the uploaded image URL
                      readTime: readTimeController.text,
                      date: DateTime.now().toIso8601String(),
                      content: contentController.text,
                      category: categoryController.text,
                      id: '',
                    );

                    // Add news to Firestore
                    await ref.read(newsRepositoryProvider).addNews(news);

                    // Refresh the news list
                    ref.refresh(newsProvider); // Refresh the news provider

                    // Show success message
                    EasyLoading.showSuccess('News added successfully!');
                  } catch (e) {
                    // Show error message if there's an issue
                    EasyLoading.showError('Failed to add news: $e');
                  } finally {
                    // Dismiss the loading indicator
                    EasyLoading.dismiss();
                  }

                  // Close the dialog
                  Navigator.of(context).pop();
                } else {
                  EasyLoading.dismiss(); // Dismiss loading indicator
                  EasyLoading.showError('You are not authorized to add news!');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
