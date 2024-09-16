import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Topic {
  final String id;
  final String title;
  final String description;

  Topic({required this.id, required this.title, required this.description});

  factory Topic.fromDocument(DocumentSnapshot doc) {
    return Topic(
      id: doc.id,
      title: doc['title'],
      description: doc['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }
}

class TopicListPage extends StatefulWidget {
  const TopicListPage({super.key});

  @override
  State<TopicListPage> createState() => _TopicListPageState();
}

class _TopicListPageState extends State<TopicListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topics'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('topics').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading topics'));
          }

          final topics = snapshot.data?.docs
                  .map((doc) => Topic.fromDocument(doc))
                  .toList() ??
              [];

          return ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(topics[index].title),
                subtitle: Text(topics[index].description),
              );
            },
          );
        },
      ),
    );
  }
}
