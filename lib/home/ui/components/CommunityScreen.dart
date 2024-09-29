import 'package:flutter/material.dart';
import 'CommunityDetailsScreen.dart';

class CommunityScreen  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar.png'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Explore'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('My Community'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[900],
                  ),
                ),
                Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.add,color: Colors.black,),
                  label: Text('Create', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF92C9FF),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                CommunityListItem(
                  name: 'Mechanic Club',
                  members: '200+',
                  subtitle: 'Web Development',
                  imagePath: 'assets/images/avatar.png',
                ),
                CommunityListItem(
                  name: 'Meme Shecholck',
                  members: '1200+',
                  subtitle: 'Web Development',
                  imagePath: 'assets/images/image1.png',
                ),
                CommunityListItem(
                  name: 'Corporate ',
                  members: '9.8k+',
                  subtitle: 'Web Development',
                  imagePath: 'assets/images/image2.png',
                ),
                CommunityListItem(
                  name: 'Funny Trolls 18',
                  members: '200+',
                  subtitle: 'Web Development',
                  imagePath: 'assets/images/image3.png',
                ),
                CommunityListItem(
                  name: 'Houston Fun memes',
                  members: '200+',
                  subtitle: 'Web Development',
                  imagePath: 'assets/images/image4.png',
                ),
                CommunityListItem(
                  name: 'Art Club',
                  members: '200+',
                  subtitle: 'Web Development',
                  imagePath: 'assets/images/image5.png',
                ),
                CommunityListItem(
                  name: 'Inner peach',
                  members: '200+',
                  subtitle: 'Web Development',
                  imagePath: 'assets/images/image1.png',
                ),
                CommunityListItem(
                  name: 'Ni 20',
                  members: '200+',
                  subtitle: 'Web Development',
                  imagePath: 'assets/images/image2.png',
                ),
                CommunityListItem(
                  name: 'Secrets',
                  members: '200+',
                  subtitle: 'Web Development',
                  imagePath: 'assets/images/image3.png',

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommunityListItem extends StatelessWidget {
  final String name;
  final String members;
  final String subtitle;
  final String imagePath;

  const CommunityListItem({
    Key? key,
    required this.name,
    required this.members,
    required this.subtitle,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(imagePath),
      ),
      title: Text(name),
    subtitle: Text(subtitle),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,  // Ensures the row takes up only as much space as needed
        children: [
          Icon(Icons.people, color: Colors.grey),  // Icon next to members count
          SizedBox(width: 5),  // A little spacing between the icon and the text
          Text(members),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommunityDetailsScreen(
              name: name,
              members: members,
              subtitle: subtitle,
            ),
          ),
        );
      },
    );
  }
}