import 'package:flutter/material.dart';

class PostedEvent extends StatefulWidget {
  const PostedEvent({super.key});

  @override
  State<PostedEvent> createState() => _PostedEventState();
}

class _PostedEventState extends State<PostedEvent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Posted Events')),
    );
  }
}
