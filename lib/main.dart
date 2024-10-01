import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_app/auth/ui/AuthCheker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/ThemeNotifier.dart';
import 'firebase_options.dart';

Future<void> insertSampleNewsData() async {
  final firestore = FirebaseFirestore.instance;
  final sampleNewsData = [
    {
      'title': 'How Tax Policy Affects Real Estate Investment',
      'imagePath': 'assets/images/image1.png',
      'readTime': '5 min read',
      'date': '9 OCT',
      'content':
          'Analyzing the Impact of Tax Policy on Real Estate Investment...',
      'category': 'Community News',
    },
    {
      'title': 'The Cons of Taxes: Understanding the Drawbacks',
      'imagePath': 'assets/images/image2.png',
      'readTime': '5 min read',
      'date': '9 OCT',
      'content': 'Exploring the negative aspects of tax policies...',
      'category': 'Latest News',
    },
    {
      'title': 'What You Need to Know About State and Local Taxes',
      'imagePath': 'assets/images/image3.png',
      'readTime': '5 min read',
      'date': '9 OCT',
      'content': 'A comprehensive guide to state and local taxes...',
      'category': 'Recent News',
    },
    {
      'title': 'Why Estate Taxes Are So Controversial',
      'imagePath': 'assets/images/image4.png',
      'readTime': '5 min read',
      'date': '9 OCT',
      'content': 'Examining the debate around estate taxes...',
      'category': 'Community News',
    },
    {
      'title': 'How Tax Credits Help Low-Income Families',
      'imagePath': 'assets/images/image5.png',
      'readTime': '5 min read',
      'date': '9 OCT',
      'content': 'An examination of tax credits for low-income families...',
      'category': 'Latest News',
    },
  ];

  for (var news in sampleNewsData) {
    try {
      await firestore.collection('news').add(news);
    } catch (e) {
      print('Error adding news: $e');
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(child: MyApp()));
  await insertSampleNewsData();
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(color: Colors.black),
      ),
      home: AuthChecker(),
    );
  }
}
