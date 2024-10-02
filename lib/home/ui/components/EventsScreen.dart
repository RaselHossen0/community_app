// lib/home/ui/components/EventsScreen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../model/EventModel.dart';
import '../providers/EventNotifier.dart';
import 'EventDetails.dart';

class EventsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, selectedDate, ref),
            _buildWeekView(ref),
            Expanded(child: _buildTimelineView(events)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, DateTime selectedDate, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                DateFormat('MMMM').format(selectedDate),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              IconButton(
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != selectedDate) {
                    ref.read(selectedDateProvider.notifier).state = pickedDate;
                    ref
                        .read(eventProvider.notifier)
                        .loadEventsForDate(pickedDate);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekView(WidgetRef ref) {
    final days = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final now = DateTime.now();
    final dates =
        List.generate(7, (index) => now.add(Duration(days: index)).day);

    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final isSelected =
              ref.watch(selectedDateProvider.notifier).state.day ==
                  now.add(Duration(days: index)).day;
          return GestureDetector(
            onTap: () {
              final newSelectedDate = now.add(Duration(days: index));
              ref.read(selectedDateProvider.notifier).state = newSelectedDate;
              ref
                  .read(eventProvider.notifier)
                  .loadEventsForDate(newSelectedDate);
            },
            child: Container(
              width: 50,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF92C9FF) : Colors.grey[800],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    days[(now.weekday + index) % 7],
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${dates[index]}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimelineView(List<Event> events) {
    return ListView.builder(
      itemCount: 9,
      itemBuilder: (context, index) {
        final hour = index + 10;
        return Row(
          children: [
            SizedBox(
              width: 50,
              child: Text(
                '$hour:00',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey[800]!),
                  ),
                ),
                child: _buildEventForHour(hour, events, context),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEventForHour(
      int hour, List<Event> events, BuildContext context) {
    final event = events.firstWhere(
      (event) => event.startTime.toDate().hour == hour,
      orElse: () => Event(
          id: '',
          name: '',
          description: '',
          startTime: Timestamp.now(),
          endTime: Timestamp.now()),
    );

    if (event.name.isNotEmpty) {
      return Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailsScreen(event: event),
              ),
            );
          },
          child: Container(
            width: 100,
            height: 50,
            margin: EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              color: Colors.blue[300],
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(event.name, style: TextStyle(color: Colors.black)),
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }
}
