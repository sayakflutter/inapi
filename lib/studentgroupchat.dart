// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class GroupChatScreen extends StatefulWidget {
//   final String sessionId;
//   final String userId;
//   final String userName;

//   GroupChatScreen({
//     required this.sessionId,
//     required this.userId,
//     required this.userName,
//   });

//   @override
//   _GroupChatScreenState createState() => _GroupChatScreenState();
// }

// class _GroupChatScreenState extends State<GroupChatScreen> {
//   final TextEditingController _messageController = TextEditingController();

//   void _sendMessage() {
//     if (_messageController.text.isNotEmpty) {
//       ChatService.sendMessage(
//         widget.sessionId,
//         widget.userId,
//         widget.userName,
//         _messageController.text,
//       );
//       _messageController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Group Chat'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<List<Map<String, dynamic>>>(
//               stream: ChatService.getChatMessages(widget.sessionId),
//               builder: (ctx, chatSnapshot) {
//                 if (chatSnapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 final chatDocs = chatSnapshot.data ?? [];
//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: chatDocs.length,
//                   itemBuilder: (ctx, index) => MessageBubble(
//                     chatDocs[index]['message'],
//                     chatDocs[index]['userName'],
//                     chatDocs[index]['userId'] == widget.userId,
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(labelText: 'Send a message...'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MessageBubble extends StatelessWidget {
//   final String message;
//   final String userName;
//   final bool isMe;

//   MessageBubble(this.message, this.userName, this.isMe);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//       children: [
//         if (!isMe)
//           CircleAvatar(
//             child: Text(userName[0]),
//           ),
//         Container(
//           decoration: BoxDecoration(
//             color: isMe ? Colors.blue : Colors.grey[300],
//             borderRadius: BorderRadius.circular(12),
//           ),
//           width: 200,
//           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//           margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//           child: Column(
//             crossAxisAlignment:
//                 isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//             children: [
//               if (!isMe)
//                 Text(
//                   userName,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: isMe ? Colors.white : Colors.black,
//                   ),
//                 ),
//               Text(
//                 message,
//                 style: TextStyle(
//                   color: isMe ? Colors.white : Colors.black,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         if (isMe)
//           CircleAvatar(
//             child: Text(userName[0]),
//           ),
//       ],
//     );
//   }
// }

// class ChatService {
//   static Future<void> sendMessage(
//       String sessionId, String userId, String userName, String message) async {
//     final ref = FirebaseFirestore.instance
//         .collection("meetings")
//         .doc(sessionId)
//         .collection("chats");

//     await ref.add({
//       'userId': userId,
//       'userName': userName,
//       'message': message,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   static Stream<List<Map<String, dynamic>>> getChatMessages(String sessionId) {
//     final ref = FirebaseFirestore.instance
//         .collection("meetings")
//         .doc(sessionId)
//         .collection("chats")
//         .orderBy('timestamp', descending: true);

//     return ref.snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) {
//         return {
//           'userId': doc['userId'],
//           'userName': doc['userName'],
//           'message': doc['message'],
//           'timestamp': doc['timestamp'],
//         };
//       }).toList();
//     });
//   }
// }
