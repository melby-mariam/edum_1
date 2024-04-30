import 'package:edum_1/event/event_newpost.dart';
import 'package:edum_1/event/event_posted.dart';
import 'package:edum_1/event/notification.dart';
import 'package:edum_1/common_pages/event_page.dart';
import 'package:flutter/material.dart';

class EventDashboard extends StatefulWidget {
  const EventDashboard({super.key});

  @override
  State<EventDashboard> createState() => _EventDashboardState();
}

class _EventDashboardState extends State<EventDashboard> {
    int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    eventPage(),
    EventNewPostPage(),
    // PostedEvent(),
    NotificationPage()
  ];
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      // appBar: AppBar(
      //   title: Text('Bottom Navigation Bar Example'),
      // ),
      body: Center(
        child: IndexedStack(index: _selectedIndex,children: _widgetOptions,),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Post',
          ),BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Event Posted',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
        ],
      ),
    );
  }
}







