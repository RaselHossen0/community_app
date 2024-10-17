// lib/home/ui/components/EventsScreen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../auth/provider/UserState.dart';
import '../../home/model/EventModel.dart';
import '../controller/EventNotifier.dart';
import 'EventDetails.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(eventProvider.notifier).loadEventsForDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(eventProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, selectedDate, ref),
            _buildWeekView(ref),
            Expanded(child: _buildTimelineView(events, ref)),
          ],
        ),
      ),
      floatingActionButton:
          user?.role == 'admin' ? _buildAdminActionButton(context, ref) : null,
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

  Widget _buildTimelineView(List<Event> events, WidgetRef ref) {
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
                child: _buildEventForHour(hour, events, context, ref),
              ),
            ),
          ],
        );
      },
    );
  }
  // Header and WeekView remain the same...

  Widget _buildAdminActionButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        _showAddEventDialog(context, ref);
      },
      backgroundColor: Colors.teal,
      child: Icon(Icons.add),
    );
  }

  void _showAddEventDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? selectedStartTime;
    DateTime? selectedEndTime;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                'Add New Event',
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Event Name',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Event Description',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  _buildDateTimePicker(
                      context, 'Select Start Time', selectedStartTime,
                      (DateTime time) {
                    setState(() {
                      selectedStartTime = time;
                    });
                  }),
                  SizedBox(height: 12),
                  _buildDateTimePicker(
                      context, 'Select End Time', selectedEndTime,
                      (DateTime time) {
                    setState(() {
                      selectedEndTime = time;
                    });
                  }),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        selectedStartTime != null &&
                        selectedEndTime != null) {
                      _saveEvent(
                        ref,
                        nameController.text,
                        descriptionController.text,
                        selectedStartTime!,
                        selectedEndTime!,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  child: Text('Save Event'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDateTimePicker(BuildContext context, String label,
      DateTime? selectedDateTime, Function(DateTime) onSelected) {
    return GestureDetector(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          final pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (pickedTime != null) {
            final selectedDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
            onSelected(selectedDateTime);
          }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDateTime != null
                  ? DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime)
                  : label,
              style: TextStyle(color: Colors.white),
            ),
            Icon(Icons.calendar_today, color: Colors.teal),
          ],
        ),
      ),
    );
  }

  void _saveEvent(WidgetRef ref, String name, String description,
      DateTime startTime, DateTime endTime) async {
    EasyLoading.show(status: 'Saving event...');

    final event = Event(
      id: FirebaseFirestore.instance.collection('events').doc().id,
      name: name,
      description: description,
      startTime: Timestamp.fromDate(startTime),
      endTime: Timestamp.fromDate(endTime),
    );

    try {
      // Insert the event
      await ref.read(eventProvider.notifier).insertEvent(event);

      // Use the selected date state to reload events for the correct day
      final selectedDate = ref.read(selectedDateProvider.notifier).state;
      await ref.read(eventProvider.notifier).loadEventsForDate(selectedDate);

      EasyLoading.showSuccess('Event saved successfully');
    } catch (error) {
      EasyLoading.showError('Failed to save event');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, Event event, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Delete Event',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete this event?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteEvent(event, ref); // Call the delete function
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent(Event event, WidgetRef ref) async {
    try {
      final user = ref.read(userProvider);
      if (user?.role != "admin") {
        EasyLoading.showError('Only admins can delete events');
        return;
      }
      EasyLoading.show(status: 'Deleting...');
      await FirebaseFirestore.instance
          .collection('events')
          .doc(event.id)
          .delete(); // Delete event from Firestore

      // Remove event from the provider
      ref
          .read(eventProvider.notifier)
          .loadEventsForDate(event.startTime.toDate());

      // Refresh the events for the current date
      final selectedDate = ref.read(selectedDateProvider);
      ref.read(eventProvider.notifier).loadEventsForDate(selectedDate);

      EasyLoading.dismiss(); // Dismiss the loading indicator
      EasyLoading.showSuccess('Event deleted!');
    } catch (e) {
      EasyLoading.dismiss(); // Dismiss the loading indicator in case of error
      EasyLoading.showError('Failed to delete event');
    }
  }

  Widget _buildEventForHour(
      int hour, List<Event> events, BuildContext context, WidgetRef ref) {
    // print('Building events for hour $hour');
    // Filter the events that start within the current hour range
    final eventsForHour = events.where((event) {
      final eventStartHour = event.startTime.toDate().hour;
      print('Event start hour: $eventStartHour');
      return eventStartHour == hour; // Event falls within this hour
    }).toList();

    // If no events are found for the hour, return an empty space
    if (eventsForHour.isEmpty) {
      return SizedBox.shrink();
    }

    // Otherwise, show all events that occur during this hour
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: eventsForHour.map((event) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailsScreen(event: event),
              ),
            );
          },
          onLongPress: () {
            // Show confirmation dialog before deleting
            _showDeleteConfirmationDialog(context, event, ref);
          },
          child: Container(
            width: 100,
            height: 50,
            margin: EdgeInsets.only(
                left: 4, bottom: 8), // Add spacing for each event
            decoration: BoxDecoration(
              color: Colors.blue[300],
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              event.name,
              style: TextStyle(color: Colors.black),
              overflow: TextOverflow.ellipsis, // Handle long names
            ),
          ),
        );
      }).toList(),
    );
  }
}
