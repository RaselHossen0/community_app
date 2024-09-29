import 'package:flutter/material.dart';

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
                  Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
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
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                          date,
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),  // Adjust padding to match the size in the image
                side: BorderSide(color: Colors.white, width: 2),  // Add a white border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),  // Make the button rounded
                ),
              ),
              child: Text(
                'Back',
                style: TextStyle(color: Colors.white),  // White text color
              ),
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),  // Adjust padding to match the size in the image
                side: BorderSide(color: Colors.white, width: 2),  // Add a white border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),  // Make the button rounded
                ),
              ),
              child: Text(
                'Next',
                style: TextStyle(color: Colors.white),  // White text color
              ),
            ),
          ],
        ),

      ),
    );
  }
}