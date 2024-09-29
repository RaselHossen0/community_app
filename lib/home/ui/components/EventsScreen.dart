import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildWeekView(),
            Expanded(child: _buildTimelineView()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Events',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Text(
                'August',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.white),
              SizedBox(width: 16),
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/avatar.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekView() {
    final days = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final dates = [9, 10, 10, 11, 12, 13, 14, 15];

    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        itemBuilder: (context, index) {
          final isSelected = index == 1;
          return Container(
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
                  days[index],
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  '${dates[index]}',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimelineView() {
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
                child: _buildEventForHour(hour),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEventForHour(int hour) {
    if (hour == 10) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 100,
          height: 50,
          margin: EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            color: Colors.blue[300],
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text('Event 1', style: TextStyle(color: Colors.black)),
        ),
      );
    } else if (hour == 13) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 100,
          height: 50,
          margin: EdgeInsets.only(left: 54),
          decoration: BoxDecoration(
            color: Colors.green[300],
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text('Event Name\nThis', style: TextStyle(color: Colors.black), textAlign: TextAlign.center),
        ),
      );
    } else if (hour == 14) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 100,
          height: 50,
          margin: EdgeInsets.only(left: 104),
          decoration: BoxDecoration(
            color: Colors.orange[300],
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text('Event Name\nThis', style: TextStyle(color: Colors.black), textAlign: TextAlign.center),
        ),
      );
    }
    return SizedBox.shrink();
  }
}