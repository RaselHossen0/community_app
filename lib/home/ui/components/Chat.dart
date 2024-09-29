import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  final String name;
  final String subtitle;

  const Chat({
    Key? key,
    required this.name,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(color: Colors.white)),
            Text(subtitle, style: TextStyle(color: Colors.blue[300], fontSize: 14)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              // Add info action here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildSentMessage("Hi! I've completed the design for your landing page. Please check it out and let me know if any revisions are needed."),
                _buildReceivedMessage("Hi! I've completed the design for your landing page. Please check it out and let me know if any revisions are needed."),
                _buildMessageWithAttachments(),
              ],
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildSentMessage(String message) {
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Text(message, style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 4),
          Text(
            "9OCT | 22:53 PM",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildReceivedMessage(String message) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar.png'), // Replace with an actual asset
            radius: 16,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                    ),
                  ),
                  child: Text(message, style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 4),
                Text(
                  "9OCT | 22:53 PM",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageWithAttachments() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar.png'), // Replace with an actual asset
            radius: 16,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Here's the banner design for the campaign:",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "ATTACHMENTS",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      SizedBox(height: 8),
                      Column(
                        children: [
                          _buildAttachment("Design Banner 1.png", "assets/images/image1.png"),
                          SizedBox(height: 8),
                          _buildAttachment("Design Banner 2.png", "assets/images/image2.png"),
                          SizedBox(height: 8),
                          _buildAttachment("Design Banner 3.png", "assets/images/image3.png"), // Add more attachments here
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        "9OCT | 22:53 PM",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAttachment(String filename, String assetPath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 60,
            margin: EdgeInsets.all(8),
            child: Image.asset(
              assetPath,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Text(filename, style: TextStyle(color: Colors.white)),
          ),
          IconButton(
            icon: Icon(Icons.file_download, color: Colors.white),
            onPressed: () {
              // Add download functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.grey[900],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Send a message...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: Icon(Icons.sentiment_satisfied, color: Colors.grey),
            onPressed: () {
              // Add emoji picker functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.grey),
            onPressed: () {
              // Add file attachment functionality
            },
          ),
        ],
      ),
    );
  }
}
