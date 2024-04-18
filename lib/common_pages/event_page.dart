import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edum_1/event_postcard.dart';
import 'package:edum_1/services/firestore.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final FirestoreService firestoreService = FirestoreService();

  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getEventPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          List EventPostList = snapshot.data!.docs;
          return ListView.builder(
            itemCount: EventPostList.length,
            itemBuilder: (context, index) {
              // Get each individual doc
              DocumentSnapshot document = EventPostList[index];
              // String docID = document.id;

              // Get note from each doc
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String EventTitle = data['eventTitle'];
              String moderatorId = data['moderatorId']; 
              String moderatorName = data['moderatorName'];
              String Date = data['date']; 
              String Venue = data['venue'];
              String otherDetails = data['otherDetails'];
              String? imageURL = data['imageURL'];
              String? dpURL = data['dpURL'];

              print(EventTitle);
              print(moderatorName);
              print(moderatorId);
              print(Date);
              print(Venue);
              print(otherDetails);
              print(imageURL);
              print(dpURL);

      

              // Display as a list title
              return EventPostCard(
  EventTitle: EventTitle,
  moderatorId: moderatorId,
  moderatorName: moderatorName,
  Date: Date,
  Venue: Venue,
  otherDetails: otherDetails,
  imageURL: imageURL ?? '',
  dpURL: '',
  postId: document.id,
  likes: List<String>.from(data['likes'] ?? []),
);
            },
          );
        },
      ),
    );}
}