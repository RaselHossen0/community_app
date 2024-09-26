import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ThemeNotifier.dart';

class NewsletterScreen extends ConsumerWidget {
  final List<Map<String, dynamic>> articles = [
    {
      'title': 'What You Need to Know About State and Local Taxes',
      'readTime': '5 min read',
      'date': '9 OCT',
      'image': 'assets/images/img.png',
    },
    {
      'title': 'Why Estate Taxes Are So Controversial',
      'readTime': '5 min read',
      'date': '9 OCT',
      'image': 'assets/images/img.png',
    },
    {
      'title': 'How Tax Credits Help Low-Income Families',
      'readTime': '5 min read',
      'date': '9 OCT',
      'image': 'assets/images/img.png',
    },
    // Add more articles here
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeNotifier = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text('Newsletter'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Switch(
            value: themeNotifier.isDarkMode,
            onChanged: (value) {
              ref.read(themeNotifierProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tabs for filtering (All, Latest, Most viewed, Popular)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTabButton(context, 'All'),
                _buildTabButton(context, 'Latest'),
                _buildTabButton(context, 'Most viewed'),
                _buildTabButton(context, 'Popular'),
              ],
            ),
            SizedBox(height: 16),
            // List of articles
            Expanded(
              child: ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return _buildArticleCard(context, article);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String label) {
    return GestureDetector(
      onTap: () {
        // Add filtering logic based on the label
      },
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context)
              .textTheme
              .displayMedium
              ?.color
              ?.withOpacity(0.7),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, Map<String, dynamic> article) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              article['image'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
            Text(
              article['title'],
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  article['readTime'],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode ? Colors.grey : Colors.black54,
                      ),
                ),
                Text(
                  article['date'],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode ? Colors.grey : Colors.black54,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
