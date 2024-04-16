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
    required String type,
    required String alumniId,
    required String alumniName,
    required String alumniDesignation,
    required String caption,
    required String description,
    String? imageURL,
    String? dpURL,
  }) {
    String unique = DateTime.now().toIso8601String();
    event_posts.doc('$alumniId$unique').set({
      'type': type,
      'alumniId': alumniId,
      'alumniName': alumniName,
      'alumniDesignation': alumniDesignation,
      'caption': caption,
      'description': description,
      'imageURL': imageURL,
      'dpURL': dpURL,
      'likes': [],
      'timestamp': Timestamp.now(),
    });

    //Adding post to alumni user data
    DocumentReference Event = event.doc(alumniId);
    return Event.collection('posts').doc('$alumniId$unique').set({
      'type': type,
      'alumniId': alumniId,
      'alumniName': alumniName,
      'alumniDesignation': alumniDesignation,
      'caption': caption,
      'description': description,
      'imageURL': imageURL,
      'timestamp': Timestamp.now(),
    });
  }
}