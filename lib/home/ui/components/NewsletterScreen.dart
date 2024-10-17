import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/provider/UserState.dart';
import '../../../newsletter/controller/NewsLetterProvider.dart';
import '../../../newsletter/ui/NewsLetter.dart';

final newslettersProvider = StreamProvider<List<Newsletter>>((ref) {
  return FirebaseFirestore.instance
      .collection('newsletters')
      .orderBy('date', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Newsletter.fromFirestore(doc)).toList());
});

class NewsletterScreen extends ConsumerStatefulWidget {
  const NewsletterScreen({super.key});

  @override
  ConsumerState<NewsletterScreen> createState() => _NewsletterScreenState();
}

class _NewsletterScreenState extends ConsumerState<NewsletterScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref
        .read(newsletterProvider.notifier)
        .checkSubscription(ref.read(userProvider.notifier).getUser()!);
  }

  @override
  Widget build(BuildContext context) {
    final isSubscribed = ref.watch(newsletterProvider);
    final newslettersAsync = ref.watch(newslettersProvider);
    final user = ref.watch(userProvider);

    return isSubscribed
        ? Scaffold(
            body: newslettersAsync.when(
              data: (newsletters) {
                if (newsletters.isEmpty) {
                  return Center(child: Text('No newsletters available.'));
                }
                return ListView.builder(
                  itemCount: newsletters.length,
                  itemBuilder: (context, index) {
                    final newsletter = newsletters[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(newsletter.title),
                        subtitle: Text(newsletter.description),
                        trailing: Text(
                          '${newsletter.date.day}/${newsletter.date.month}/${newsletter.date.year}',
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
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
}
