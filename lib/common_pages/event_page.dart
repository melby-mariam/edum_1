import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edum_1/event/event_postcard.dart';
import 'package:edum_1/services/firestore.dart';
import 'package:flutter/material.dart';

class eventPage extends StatefulWidget {
  const eventPage({super.key});
  @override
  State<eventPage> createState() => _eventPageState();
}

class _eventPageState extends State<eventPage> {
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

          List eventPostList = snapshot.data!.docs;
          return ListView.builder(
            itemCount: eventPostList.length,
            itemBuilder: (context, index) {
              // Get each individual doc
              DocumentSnapshot document = eventPostList[index];
              // String docID = document.id;

              // Get note from each doc
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              print('Data For the Event Posts ::: \n$data');

              // Display as a list title
              return EventPostCard(
                date: '21/21/2121',
                venue: 'Ooty',
                moderatorId: '',
                moderatorName: '',
                otherDetails: 'Details of the post is here',
                dpURL: 'https://png.pngtree.com/thumb_back/fh260/background/20230611/pngtree-two-cute-egg-cupids-sitting-in-sunlight-next-to-each-other-image_2914931.jpg',
                postId: '',
                imageURL: 'https://png.pngtree.com/thumb_back/fh260/background/20230611/pngtree-two-cute-egg-cupids-sitting-in-sunlight-next-to-each-other-image_2914931.jpg',
                eventTitle: 'This is Event title',
                likes: [],
              );
            },
          );
        },
      ),
    );
  }
}
