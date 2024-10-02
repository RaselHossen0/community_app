// lib/home/ui/components/NewsletterScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/provider/UserState.dart';
import '../providers/NewsLetterProvider.dart';

class NewsletterScreen extends ConsumerWidget {
  NewsletterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSubscribed = ref.watch(newsletterProvider);
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All', isSelected: true),
                    _buildFilterChip('Latest'),
                    _buildFilterChip('Most viewed'),
                    _buildFilterChip('Popular'),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/subscribe.png',
                        width: 104,
                        height: 156,
                      ),
                      SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isSubscribed
                              ? null
                              : () async {
                                  await ref
                                      .read(newsletterProvider.notifier)
                                      .subscribe(user!);
                                },
                          child: Text(
                            isSubscribed
                                ? 'You are subscribed'
                                : 'Subscribe to newsletter',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFC1E0FF),
                              Color(0xFF92C9FF),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
        backgroundColor: isSelected ? Color(0x1B1B1B) : Colors.black,
      ),
    );
  }
}
