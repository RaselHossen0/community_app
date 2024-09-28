import 'package:flutter/material.dart';
import 'Newsdetails.dart'; // Make sure this import points to the correct location of your NewsDetails widget

class News extends StatelessWidget {
  final Color readTimeColor = Color(0xFF92C9FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Info & News',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildChip('All News', isSelected: true),
                    _buildChip('Latest News'),
                    _buildChip('Community News'),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 300,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildHorizontalNewsCard(
                      'How Tax Policy Affects Real Estate Investment: Analyzing the Impact of Ta...',
                      'assets/images/image1.png',
                      '5 min read',
                      '9 OCT',
                      context,
                    ),
                    SizedBox(width: 16),
                    _buildHorizontalNewsCard(
                      'The Cons Taxes: Ur',
                      'assets/images/image2.png',
                      '5 min read',
                      '9 OCT',
                      context,
                    ),
                    // Add more horizontal cards as needed
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent News',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    'SEE ALL',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: [
                    _buildSmallNewsCard(
                      'What You Need to Know About State and Local Taxe...',
                      'assets/images/image3.png',
                      '5 min read',
                      '9 OCT',
                      context,
                    ),
                    _buildSmallNewsCard(
                      'Why Estate Taxes Are So Controversial: Examining t...',
                      'assets/images/image4.png',
                      '5 min read',
                      '9 OCT',
                      context,
                    ),
                    _buildSmallNewsCard(
                      'How Tax Credits Help Low-Income Families: An Exami...',
                      'assets/images/image5.png',
                      '5 min read',
                      '9 OCT',
                      context,
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

  Widget _buildChip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? Colors.white12 : Colors.transparent,
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey),
      ),
    );
  }

  Widget _buildHorizontalNewsCard(String title, String imagePath, String readTime, String date, BuildContext context) {
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
              content: 'This is a placeholder for the full news content. In a real app, you would fetch this content from your data source.',
            ),
          ),
        );
      },
      child: Container(
        width: 300,
        child: Card(
          color: Colors.grey[900],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover, height: 200),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(readTime, style: TextStyle(color: readTimeColor)),
                        Text(date, style: TextStyle(color: Colors.grey)),
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

  Widget _buildSmallNewsCard(String title, String imagePath, String readTime, String date, BuildContext context) {
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
              content: 'This is a placeholder for the full news content. In a real app, you would fetch this content from your data source.',
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(imagePath, width: 100, height: 100, fit: BoxFit.cover),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(readTime, style: TextStyle(color: readTimeColor)),
                      Text(date, style: TextStyle(color: Colors.grey)),
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
}