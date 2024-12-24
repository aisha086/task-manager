import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;
  final String otherUserName;

  ChatScreen({
    required this.currentUserId,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  String getChatId() {
    // Generate chat ID by combining user IDs
    List<String> ids = [widget.currentUserId, widget.otherUserId];
    ids.sort(); // Ensure order is consistent
    return ids.join("_");
  }

  void sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    FirebaseFirestore.instance
        .collection('chats')
        .doc(getChatId())
        .collection('messages')
        .add({
      'senderId': widget.currentUserId,
      'receiverId': widget.otherUserId,
      'text': messageText,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Access the current theme
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUserName),
        backgroundColor: theme.appBarTheme.backgroundColor, // AppBar color based on theme
        foregroundColor: theme.appBarTheme.foregroundColor, // AppBar text color based on theme
      ),
      body: Column(
        children: [
          // Display Messages
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(getChatId())
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message['senderId'] == widget.currentUserId;

                    return Align(
                      alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: isMe
                              ? theme.cardColor // Current user's message bubble color based on theme
                              : theme.cardColor, // Other user's message bubble color based on theme
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message['text'],
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.textTheme.bodyLarge?.color, // Text color based on theme
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Message Input Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: theme.canvasColor, // Input field background color based on theme
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: theme.iconTheme.color), // Send button color based on theme
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
