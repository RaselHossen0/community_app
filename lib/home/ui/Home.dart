import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'components/News.dart';

class Home extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  int _currentIndex = 0;  // Keeps track of the current tab index

  // List of screens that correspond to each tab
  final List<Widget> _children = [
    News(),   // Screen for 'News & Info' tab
    //CommunityScreen(),     // Screen for 'Community' tab
   // NewsletterScreen(),    // Screen for 'Newsletter' tab
   // EventsScreen(),        // Screen for 'Events' tab
  ];

  // When a tab is tapped, this method is called to update the screen
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;  // Update the current index and rebuild the UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Display the screen corresponding to the current tab index
      body: _children[_currentIndex],
      // Bottom navigation bar with SVG icons
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,  // The current selected tab
        onTap: onTabTapped,  // Call onTabTapped when a tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/News.svg', // Path to your SVG file
              width: 24.0,
              height: 24.0,
              color: _currentIndex == 0 ? Color(0xFF92C9FF) : Colors.grey, // Set color dynamically
            ),
            label: 'News & Info',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Community.svg', // Path to your SVG file
              width: 24.0,
              height: 24.0,
              color: _currentIndex == 1 ? Color(0xFF92C9FF) : Colors.grey, // Set color dynamically
            ),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Letter.svg', // Path to your SVG file
              width: 24.0,
              height: 24.0,
              color: _currentIndex == 2 ? Color(0xFF92C9FF) : Colors.grey, // Set color dynamically
            ),
            label: 'Newsletter',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Events.svg', // Path to your SVG file
              width: 24.0,
              height: 24.0,
              color: _currentIndex == 3 ? Color(0xFF92C9FF) : Colors.grey, // Set color dynamically
            ),
            label: 'Events',
          ),
        ],
        selectedItemColor: Color(0xFF92C9FF), // Color for selected items
        unselectedItemColor: Colors.grey, // Color for unselected items
        backgroundColor: Colors.black87, // Dark mode background color
        selectedLabelStyle: TextStyle(
          color: Color(0xFF92C9FF), // Color for selected label
        ),
        unselectedLabelStyle: TextStyle(
          color: Colors.grey, // Color for unselected labels
        ),
      ),
    );
  }
}

// Placeholder screens for each tab
class NewsAndInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('News & Info Screen', style: TextStyle(color: Colors.white)),
    );
  }
}

class CommunityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Community Screen', style: TextStyle(color: Colors.white)),
    );
  }
}

class NewsletterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Newsletter Screen', style: TextStyle(color: Colors.white)),
    );
  }
}

class EventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Events Screen', style: TextStyle(color: Colors.white)),
    );
  }
}
