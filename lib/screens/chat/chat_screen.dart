class ChatScreen extends StatefulWidget {
  final String recipientId;
  final String recipientName;

  ChatScreen({required this.recipientId, required this.recipientName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot> _getMessages() {
    return _firestore
        .collection('chats')
        .doc(_getChatId())
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  String _getChatId() {
    // Create a unique chat ID by combining both user IDs
    return [_currentUserId, widget.recipientId]..sort().join('_');
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    await _firestore
        .collection('chats')
        .doc(_getChatId())
        .collection('messages')
        .add({
      'text': _messageController.text,
      'senderId': _currentUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.recipientName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final message = snapshot.data!.docs[index];
                    final isMe = message['senderId'] == _currentUserId;

                    return MessageBubble(
                      message: message['text'],
                      isMe: isMe,
                      timestamp: message['timestamp'],
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
