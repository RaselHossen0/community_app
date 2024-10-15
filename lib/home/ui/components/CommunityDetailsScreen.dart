// lib/home/ui/components/CommunityDetailsScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/provider/UserState.dart';
import '../chat/controller/MessageController.dart';
import '../chat/model/MessageModel.dart';
import 'InfoScreen.dart';

class CommunityDetailsScreen extends ConsumerStatefulWidget {
  final String name;
  final List<String> members;
  final String subtitle;
  final String communityId;
  final String adminId;

  const CommunityDetailsScreen({
    Key? key,
    required this.name,
    required this.members,
    required this.subtitle,
    required this.communityId,
    required this.adminId,
  }) : super(key: key);

  @override
  _CommunityDetailsScreenState createState() => _CommunityDetailsScreenState();
}

class _CommunityDetailsScreenState
    extends ConsumerState<CommunityDetailsScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(messageProvider.notifier).loadMessages(widget.communityId);
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messageProvider);
    final isAdmin =
        ref.read(userProvider.notifier).getUser()?.uid == widget.adminId;

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
            Text(
              widget.name,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              widget.subtitle,
              style: TextStyle(color: Color(0xFF92C9FF), fontSize: 12),
            ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _buildMessageItem(message, isAdmin: isAdmin);
              },
            ),
          ),
          Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.people, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  '${widget.members.length} | Only Admin can send message',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Message message, {bool isAdmin = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isAdmin ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isAdmin ? Colors.blue : Colors.grey[800],
              borderRadius: BorderRadius.circular(16),
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
}
