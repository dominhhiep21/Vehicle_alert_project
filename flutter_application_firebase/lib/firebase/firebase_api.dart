import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StreamController<Map<String, String>> _messageStreamController = StreamController<Map<String, String>>.broadcast();

  Stream<Map<String, String>> get messages => _messageStreamController.stream;

  Future<void> initializeFCM() async {
    await _firebaseMessaging.requestPermission();
    await _firebaseMessaging.subscribeToTopic("start-device");
    await _firebaseMessaging.subscribeToTopic("high-accChange");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleIncomingMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleIncomingMessage(message);
    });

    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleIncomingMessage(initialMessage);
    }
  }

  void _handleIncomingMessage(RemoteMessage message) {
    final messageData = {
      "title": message.notification?.title ?? "No Title",
      "body": message.notification?.body ?? "No Body",
      "time": DateTime.now().toString(),
      "iconPath": message.data['iconPath']?.toString() ?? "No icon",
    };
    _messageStreamController.add(messageData);
    _saveMessageToFirestore(messageData);
  }

  Future<void> _saveMessageToFirestore(Map<String, String> messageData) async {
    await _firestore.collection('messages').add(messageData);
  }

  Future<List<Map<String, String>>> fetchMessages() async {
    final querySnapshot = await _firestore.collection('messages').get();
    return querySnapshot.docs.map((doc) {
      return {
        "title": (doc["title"] ?? "No Title").toString(),
        "body": (doc["body"] ?? "No Body").toString(),
        "time": (doc["time"] ?? "Unknown Time").toString(),
        "iconPath": (doc["iconPath"] ?? "No icon").toString(),
      };
    }).toList();
  }

  void dispose() {
    _messageStreamController.close();
  }
}
