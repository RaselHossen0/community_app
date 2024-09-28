import 'package:flutter/material.dart';



class CommunityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Community Screen',
      theme: ThemeData.dark(),
      home: CommunityScreenFinal(),
    );
  }
}

class CommunityScreenFinal extends StatelessWidget {
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
                  icon: Icon(Icons.add),
                  label: Text('Create'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
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
                  imagePath: 'assets/images/avatar.png',
                ),
                CommunityListItem(
                  name: 'Meme Shecholck',
                  members: '1200+',
                  imagePath: 'assets/images/image1.png',
                ),
                CommunityListItem(
                  name: 'Corporate shits',
                  members: '9.8k+',
                  imagePath: 'assets/images/image2.png',
                ),
                CommunityListItem(
                  name: 'Funny Trolls 18',
                  members: '200+',
                  imagePath: 'assets/images/image3.png',
                ),
                CommunityListItem(
                  name: 'Houston Fun memes',
                  members: '200+',
                  imagePath: 'assets/images/image4.png',
                ),
                CommunityListItem(
                  name: 'Art Club',
                  members: '200+',
                  imagePath: 'assets/images/image5.png',
                ),
                CommunityListItem(
                  name: 'Inner peach',
                  members: '200+',
                  imagePath: 'assets/images/image1.png',
                ),
                CommunityListItem(
                  name: 'Nigga 20',
                  members: '200+',
                  imagePath: 'assets/images/image2.png',
                ),
                CommunityListItem(
                  name: 'Secrets',
                  members: '200+',
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
  final String imagePath;

  const CommunityListItem({
    Key? key,
    required this.name,
    required this.members,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(imagePath),
      ),
      title: Text(name),
      subtitle: Text('Web Development'),
      trailing: Text(members),
    );
  }
}