// lib/home/ui/components/Chat.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_app/auth/provider/UserState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../chat/controller/MessageController.dart';
import '../chat/model/MessageModel.dart';
import 'InfoScreen.dart';

class Chat extends ConsumerStatefulWidget {
  final String name;
  final String subtitle;
  final String communityId;
  final bool isAdmin;
  final String adminId;

  const Chat({
    Key? key,
    required this.name,
    required this.subtitle,
    required this.isAdmin,
    required this.communityId,
    required this.adminId,
  }) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends ConsumerState<Chat> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(messageProvider.notifier).loadMessages(widget.communityId);
  }

  void _sendMessage() async {
    print('Sending message');
    print(widget.isAdmin);
    final user = ref.read(userProvider.notifier).getUser();
    if (widget.isAdmin && _messageController.text.isNotEmpty) {
      final message = Message(
        id: '',
        communityId: widget.communityId,
        senderId: user!.uid,
        type: 'text',
        content: _messageController.text,
        timestamp: Timestamp.now(),
      );
      await ref.read(messageProvider.notifier).sendMessage(message);
      _messageController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Only admins can send messages')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messageProvider);
    print(messages.length);

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
            Text(widget.name, style: TextStyle(color: Colors.white)),
            Text(widget.subtitle,
                style: TextStyle(color: Colors.blue[300], fontSize: 14)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => InfoScreen(
                    communityId: widget.communityId,
                    adminId: widget.adminId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final user = ref.read(userProvider.notifier).getUser();
                if (message.senderId == user?.uid) {
                  return _buildSentMessage(message);
                } else {
                  return _buildReceivedMessage(message);
                }
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildSentMessage(Message message) {
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
            child: Text(message.content, style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 4),
          Text(
            "${message.timestamp.toDate().day} ${message.timestamp.toDate().month} | ${message.timestamp.toDate().hour}:${message.timestamp.toDate().minute} ${message.timestamp.toDate().hour >= 12 ? 'PM' : 'AM'}",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildReceivedMessage(Message message) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(
                'assets/images/avatar.png'), // Replace with an actual asset
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
                  child: Text(message.content,
                      style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 4),
                Text(
                  "${message.timestamp.toDate().day} ${message.timestamp.toDate().month} | ${message.timestamp.toDate().hour}:${message.timestamp.toDate().minute} ${message.timestamp.toDate().hour >= 12 ? 'PM' : 'AM'}",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
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
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Send a message...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          // IconButton(
          //   icon: Icon(Icons.sentiment_satisfied, color: Colors.grey),
          //   onPressed: () {
          //     // Add emoji picker functionality
          //   },
          // ),
          // IconButton(
          //   icon: Icon(Icons.attach_file, color: Colors.grey),
          //   onPressed: () {
          //     // Add file attachment functionality
          //   },
          // ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
