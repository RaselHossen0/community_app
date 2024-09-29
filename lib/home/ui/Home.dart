import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'components/News.dart';
import 'components/CommunityScreen.dart';  // Correct import here
import 'components/NewsletterScreen.dart';
import 'components/EventsScreen.dart';
import 'components/EventDetailsScreen.dart';

class Home extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  int _currentIndex = 0;  // Keeps track of the current tab index

  // List of screens that correspond to each tab
  final List<Widget> _children = [
    News(),   // Screen for 'News & Info' tab
    CommunityScreen(),     // Screen for 'Community' tab
    NewsletterScreen(),    // Screen for 'Newsletter' tab
     EventsScreen(),        // Screen for 'Events' tab
    //EventDetailsScreen()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;  // Update the current index and rebuild the UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/News.svg',
              width: 24.0,
              height: 24.0,
              color: _currentIndex == 0 ? Color(0xFF92C9FF) : Colors.grey,
            ),
            label: 'News & Info',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Events.svg',
              width: 24.0,
              height: 24.0,
              color: _currentIndex == 1 ? Color(0xFF92C9FF) : Colors.grey,
            ),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Letter.svg',
              width: 24.0,
              height: 24.0,
              color: _currentIndex == 2 ? Color(0xFF92C9FF) : Colors.grey,
            ),
            label: 'Newsletter',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Community.svg',
              width: 24.0,
              height: 24.0,
              color: _currentIndex == 3 ? Color(0xFF92C9FF) : Colors.grey,
            ),
            label: 'Events',
          ),
        ],
        selectedItemColor: Color(0xFF92C9FF),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black87,
        selectedLabelStyle: TextStyle(
          color: Color(0xFF92C9FF),
        ),
        unselectedLabelStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}
