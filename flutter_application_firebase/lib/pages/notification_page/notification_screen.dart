import 'package:flutter/material.dart';
import '../../firebase/firebase_api.dart';
import 'notification_detail/notification_item.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, String>> notifications = [];
  final FirebaseMessagingService _firebaseMessagingService = FirebaseMessagingService();

  @override
  void initState() {
    super.initState();
    _firebaseMessagingService.initializeFCM();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final messages = await _firebaseMessagingService.fetchMessages();
    setState(() {
      notifications.addAll(messages);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notification",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<Map<String, String>>(
        stream: _firebaseMessagingService.messages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
            final newNotification = snapshot.data!;
            if (notifications.length >= 15) {
              notifications.removeLast();
            }
            notifications.insert(0, newNotification);
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return MessageItem(
                title: notifications[index]['title']!,
                body: notifications[index]['body']!,
                time: notifications[index]['time']!,
                iconPath: notifications[index]['iconPath']!,
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _firebaseMessagingService.dispose();
    super.dispose();
  }
}
