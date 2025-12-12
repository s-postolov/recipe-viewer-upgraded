import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    //NotificationSettings settings = await _messaging.requestPermission();

    //log("Permission: ${settings.authorizationStatus}");

    String? token = await _messaging.getToken();
    //log("FCM Token = $token");

    if (token != null) {
      await FirebaseFirestore.instance
          .collection("tokens")
          .doc(token)
          .set({"token": token});

      //log("Token saved to Firestore");
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Received FCM message: ${message.notification?.title}");
    });
  }
}