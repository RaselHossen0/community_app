import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/NewsProvider.dart';
import 'Newsdetails.dart'; // Make sure this import points to the correct location of your NewsDetails widget

class News extends ConsumerStatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends ConsumerState<News> {
  String selectedCategory = 'All News';

  final Color readTimeColor = Color(0xFF92C9FF);

  @override
  Widget build(BuildContext context) {
    final newsAsyncValue = selectedCategory == 'All News'
        ? ref.watch(newsProvider)
        : ref.watch(newsByCategoryProvider(selectedCategory));

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.653,
                child: newsAsyncValue.when(
                  data: (newsList) => Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.32,
                        child: ListView.builder(
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
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent News',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            'SEE ALL',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: newsList.length,
                          itemBuilder: (context, index) {
                            final news = newsList[index];
                            return _buildSmallNewsCard(
                              news.title,
                              news.imagePath,
                              news.readTime,
                              news.date,
                              context,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
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
      String readTime, String date, BuildContext context) {
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
              content:
                  'This is a placeholder for the full news content. In a real app, you would fetch this content from your data source.',
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
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: 200,
                width: MediaQuery.of(context).size.width * 0.8,
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

  Widget _buildSmallNewsCard(String title, String imagePath, String readTime,
      String date, BuildContext context) {
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
              content:
                  'This is a placeholder for the full news content. In a real app, you would fetch this content from your data source.',
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
              child: Image.asset(imagePath,
                  width: 100, height: 100, fit: BoxFit.cover),
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
