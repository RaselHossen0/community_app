import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class NewsDetails extends StatelessWidget {
  final String title;
  final String imagePath;
  final String readTime;
  final String date;
  final String content;

  const NewsDetails({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.readTime,
    required this.date,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    imagePath,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return SvgPicture.asset(
                        'assets/icons/newsP.svg',
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFF92C9FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            readTime,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          formatDate(date), // Use the formatted date
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      content,
                      style: TextStyle(color: Colors.white),
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
}

String formatDate(String date) {
  final DateTime dateTime = DateTime.parse(date); // Convert string to DateTime
  return DateFormat.yMMMd()
      .format(dateTime); // Format date to a readable format (e.g., Jan 1, 2024)
}
