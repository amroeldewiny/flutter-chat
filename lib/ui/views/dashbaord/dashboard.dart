import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:popart/core/widget/popdrawer.dart';
import 'package:popart/ui/views/dashbaord/chat.dart';

class Dashboard extends StatefulWidget {
  static const String page = 'DashboardPage';
  final String currentUserId;

  Dashboard({Key key, @required this.currentUserId}) : super(key: key);

  @override
  _DashboardState createState() =>
      _DashboardState(currentUserId: currentUserId);
}

class _DashboardState extends State<Dashboard> {
  _DashboardState({Key key, @required this.currentUserId});

  final String currentUserId;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseUser currentUser;
  bool loading = false;
  final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      Firestore.instance
          .collection('users')
          .document(currentUserId)
          .updateData({'pushToken': token});
    }).catchError((error) => print(error.message.toString()));
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        Platform.isAndroid ? 'com.nikkelart.popart' : 'com.nikkelart.popart',
        'Flutter Pop Art',
        'Your channel description',
        playSound: true,
        enableVibration: true,
        importance: Importance.Max,
        priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    print(message);

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: PopDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        title: Text('Dashboard'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _drawerKey.currentState.openDrawer();
            },
          ),
        ],
        leading: Container(),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: Icon(Icons.search),
        onPressed: () {},
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            Container(
              child: StreamBuilder(
                stream: Firestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) => _buildUsersList(
                          context, snapshot.data.documents[index]),
                      itemCount: snapshot.data.documents.length,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersList(BuildContext context, DocumentSnapshot document) {
    if (document['userId'] == currentUserId) {
      print('userId => ${currentUserId}');
      return Container();
    } else {
      return ListTile(
        /*leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl))*/
        leading: Icon(Icons.person),
        title: Text(document['name']),
        subtitle: Text(document['email']),
        trailing: Icon(Icons.chat),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Chat(
                chaterId: document.documentID,
                //peerAvatar: document['photoUrl'],
              ),
            ),
          );
        },
      );
    }
  } // End widget
}
