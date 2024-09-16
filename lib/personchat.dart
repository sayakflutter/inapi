// import 'package:abc/getx.dart';
// import 'package:abc/messageui.dart';
// import 'package:abc/widget/models/modelClass.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_rx/get_rx.dart';

// class PersonChat extends StatefulWidget {
//   final String sessionId;
//   final String userid;
//   PersonChat({super.key, required this.sessionId, required this.userid}) {
//     print(sessionId);
//   }

//   @override
//   State<PersonChat> createState() => _PersonChatState();
// }

// class _PersonChatState extends State<PersonChat> {
//   Getx getx = Get.put(Getx());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Expanded(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//                 stream: MeetingService.getMeetingUsers(widget.sessionId),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   if (snapshot.hasError) {
//                     return const Center(child: Text('Error loading users'));
//                   }

//                   if (!snapshot.hasData || !snapshot.data!.exists) {
//                     return const Center(
//                         child: Text('No users in this meeting'));
//                   }
// // Assume this is within a function or a widget that has access to the snapshot

// // Check if the snapshot has data and initialize users
//                   RxList<dynamic> users =
//                       (snapshot.data?.data()?['users'] as List<dynamic>? ??
//                               <dynamic>[])
//                           .obs;

// // Convert and filter the users list to get only those with the role of 'teacher'
//                   List<UserDetails> filteredUsers = users
//                       .map((user) =>
//                           UserDetails.fromJson(user as Map<String, dynamic>))
//                       .where((userDetails) => userDetails.role == 'Teacher')
//                       .toList();

// // Assign the filtered list to the GetX variable
//                   getx.userDetails.assignAll(filteredUsers);

//                   // print(userDetailsList[0].name);
//                   return SizedBox(
//                     height: 400,
//                     child: Obx(
//                       () => getx.userDetails.isNotEmpty
//                           ? ListView.builder(
//                               itemCount: getx.userDetails.length,
//                               itemBuilder: (context, index) {
//                                 final user = getx.userDetails[index];

//                                 return ListTile(
//                                   onTap: () {
//                                     print(users);
//                                     Get.to(
//                                         () => MessageUi(user, widget.userid));
//                                   },
//                                   title: Text(user.name),
//                                   subtitle: Text(user.userid),
//                                 );
//                               },
//                             )
//                           : Text(
//                               'No Data',
//                               style:
//                                   TextStyle(fontSize: 25, color: Colors.white),
//                             ),
//                     ),
//                   );
//                 },
//               ),
//               // You can add a chat input here or other widgets below the user list
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
