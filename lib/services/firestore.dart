import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
    // get collection of alumni_posts
  final CollectionReference event_posts =
      FirebaseFirestore.instance.collection('event_posts');
  // get collection of alumni_posts
  final CollectionReference event =
      FirebaseFirestore.instance.collection('event');


  // To add alumni post data from form to alumni and alumniPosts
  Future<void> addEventPosts({
    required String EventTitle,
    required String moderatorId,
    required String moderatorName,
    required String Date,
    required String Venue,
    required String otherDetails,
    String? imageURL,
    String? dpURL,
  }) {
    String unique = DateTime.now().toIso8601String();
    event_posts.doc('$moderatorId$unique').set({
      'eventTitle': EventTitle,
      'moderatorId': moderatorId,
      'moderatorName': moderatorName,
      'date': Date,
      'venue': Venue,
      'otherDetails': otherDetails,
      'imageURL': imageURL,
      'dpURL': dpURL,
      'likes': [],
      'timestamp': Timestamp.now(),
    });

    //Adding post to alumni user data
    DocumentReference Event = event.doc(moderatorId);
    return Event.collection('posts').doc('$moderatorId$unique').set({
      'eventTitle': EventTitle,
      'moderatorId': moderatorId,
      'moderatorName': moderatorName,
      'date': Date,
      'venue': Venue,
      'otherDetails': otherDetails,
      'imageURL': imageURL,
      'timestamp': Timestamp.now(),
    });
  }

  // To get the data for event posts
  Stream<QuerySnapshot> getEventPostsStream() {
    final alumniPostsStream =
        event_posts.orderBy('timestamp', descending: true).snapshots();
    return alumniPostsStream;
  }

  // Update/Edit post data
  List eventPostInstances({
    required String postId,
    required String moderatorId,
  }) {
    // Update the post in the alumni_posts collection
    DocumentReference eventRef = event_posts.doc(postId);

    // Update the post in the alumni user data
    DocumentReference eventPostRef =
        event.doc(moderatorId).collection('posts').doc(postId);

    return [eventRef, eventPostRef];
  }

}