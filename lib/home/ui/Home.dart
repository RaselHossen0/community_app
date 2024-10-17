import 'package:community_app/auth/ui/SignUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../auth/provider/AuthProvider.dart';
import '../../auth/provider/UserState.dart';
import '../../community/ui/CommunityScreen.dart';
import '../../events/ui/EventsScreen.dart';
import '../../news/ui/News.dart';
import 'components/ContactInfoScreen.dart';
import 'components/NewsletterScreen.dart';
import 'components/PersonalInfo.dart';
import 'components/PrivacyPolicy.dart';
import 'components/TermsAndServices.dart';

final bottomNavProvider = StateProvider<int>((ref) => 0);

class Home extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<Home> {
  final List<Widget> _children = [
    NewsPage(),
    CommunityScreen(),
    NewsletterScreen(),
    EventsScreen(),
  ];
  final List<String> _titles = [
    'News & Info',
    'Community',
    'Newsletter',
    'Events',
  ];
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavProvider);
    final user = ref.watch(userProvider); // Watch for changes to user

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[currentIndex]),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PersonalInfo();
              }));
              // Handle profile tap
            },
            child: CircleAvatar(
              radius: 20.0,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : AssetImage('assets/default_profile.png')
                      as ImageProvider, // Default image if photoURL is null
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display user's profile picture
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : AssetImage('assets/default_profile.png')
                            as ImageProvider, // Default image if photoURL is null
                    backgroundColor: Colors.white,
                    onBackgroundImageError: (exception, stackTrace) {
                      print('Error loading image: $exception');
                    },
                    // Background color for the avatar
                  ),
                  SizedBox(height: 10),
                  // Display user's name
                  Text(
                    user?.displayName ?? 'Guest',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  // Display user's email
                  Text(
                    user?.email ?? 'guest@example.com',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PersonalInfo();
                }));
                // Handle profile tap
              },
            ),

            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Contact Us'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ContactInfoScreen();
                }));
                // Handle settings tap
              },
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Terms & Conditions'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TermsAndServices();
                }));
                // Handle settings tap
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Privacy Policy'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PrivacyPolicy();
                }));
                // Handle settings tap
              },
            ),
            //Logout button
            ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                // lib/home/ui/Home.dart

                onTap: () async {
                  EasyLoading.show(status: 'Logging out...');
                  try {
                    ref.read(authProvider.notifier).signOut();
                    ref.read(userProvider.notifier).clearUser();
                    EasyLoading.showSuccess('Logout successful');
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return SignUpScreen();
                    }), (route) => false);
                  } catch (e) {
                    EasyLoading.showError('Logout failed');
                  } finally {
                    EasyLoading.dismiss();
                  }
                }),
          ],
        ),
      ),
      body: _children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(bottomNavProvider.notifier).state = index;
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/News.svg',
              width: 24.0,
              height: 24.0,
              color: currentIndex == 0 ? Color(0xFF92C9FF) : Colors.grey,
            ),
            label: 'News & Info',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Events.svg',
              width: 24.0,
              height: 24.0,
              color: currentIndex == 1 ? Color(0xFF92C9FF) : Colors.grey,
            ),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Letter.svg',
              width: 24.0,
              height: 24.0,
              color: currentIndex == 2 ? Color(0xFF92C9FF) : Colors.grey,
            ),
            label: 'Newsletter',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Community.svg',
              width: 24.0,
              height: 24.0,
              color: currentIndex == 3 ? Color(0xFF92C9FF) : Colors.grey,
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
