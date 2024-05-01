import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart'; // Import the mailer package
import 'package:mailer/smtp_server.dart'; // Import the SMTP server class

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Enrollment',
      home: EventEnrollmentPage(),
    );
  }
}

class EventEnrollmentPage extends StatefulWidget {
  @override
  _EventEnrollmentPageState createState() => _EventEnrollmentPageState();
}

class _EventEnrollmentPageState extends State<EventEnrollmentPage> {
  final _emailController = TextEditingController();

  void _enrollInEvent() async {
    final email = _emailController.text;

    // Send the email notification
    final smtpServer = gmailSaslXoauth2(
      'your-gmail-email@gmail.com',
      'your-gmail-app-password',
    );
    final message = Message()
      ..from = Address('your-gmail-email@gmail.com', 'Event Organizer')
      ..recipients.add(email)
      ..subject = 'Event Enrollment Confirmation'
      ..text = 'You have successfully enrolled in the event!';

    try {
      await send(message, smtpServer);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enrollment successful! Check your email.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending email: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Enrollment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _enrollInEvent,
              child: Text('Enroll'),
            ),
          ],
        ),
      ),
    );
  }
}