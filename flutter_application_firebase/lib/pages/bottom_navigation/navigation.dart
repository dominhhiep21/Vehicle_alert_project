import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebase/pages/location_page/location_screen.dart';
import 'package:flutter_application_firebase/pages/notification_page/notification_screen.dart';

class BottomNavigationCustom extends StatefulWidget {
  const BottomNavigationCustom({super.key
  });
  @override
  State<BottomNavigationCustom> createState() => _BottomNavigationCustomState();
}

class _BottomNavigationCustomState extends State<BottomNavigationCustom> {
  List<Widget> pages = [const NotificationPage(),const LocationPage()];
  int pageNumber = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageNumber],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageNumber,
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        elevation: 0,
        onTap: (index){
          setState(() {
            pageNumber = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bell),
            label: "Notification"
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.location),
            label: "Location"
          ),
        ]       
      ),
    );
  }
}