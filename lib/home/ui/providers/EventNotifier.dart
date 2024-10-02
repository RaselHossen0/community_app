// lib/home/ui/providers/EventNotifier.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/EventModel.dart';

class EventNotifier extends StateNotifier<List<Event>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  EventNotifier() : super([]);

  Future<void> loadEvents() async {
    final querySnapshot = await _firestore.collection('events').get();
    state = querySnapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
  }

  Future<void> loadEventsForDate(DateTime date) async {
    final startOfDay =
        Timestamp.fromDate(DateTime(date.year, date.month, date.day));
    final endOfDay = Timestamp.fromDate(
        DateTime(date.year, date.month, date.day, 23, 59, 59));

    final querySnapshot = await _firestore
        .collection('events')
        .where('startTime', isGreaterThanOrEqualTo: startOfDay)
        .where('startTime', isLessThanOrEqualTo: endOfDay)
        .get();

    state = querySnapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
  }

  Future<void> insertEvent(Event event) async {
    await _firestore.collection('events').add(event.toMap());
    loadEvents();
  }

  List<Event> getEvents() {
    return state;
  }
}

final eventProvider = StateNotifierProvider<EventNotifier, List<Event>>((ref) {
  return EventNotifier();
});
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});
