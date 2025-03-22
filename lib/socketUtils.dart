import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketUtils {
  // local host server se connect hone me problem aati hai ....
  //phle server ko deploy kiya hai then url pass ki hai connectUrl me
  static  String _serverIP = Platform.isIOS ? 'http://192.168.55.21:3000' : 'http://192.168.55.21:3000';
  static const int SERVER_PORT = 5000;
  static String _connectUrl = /*'https://real-chat-node.onrender.com/'*/ /*'http://192.168.55.21:3000'*/ 'https://socket-io-bb16.onrender.com/';
  static const String ON_MESSAGE_RECEIVED = 'receive_message';
  static const String SUB_EVENT_MESSAGE_SENT = 'message_sent_to_user';
  static const String IS_USER_CONNECTED_EVENT = 'is_user_connected';
  static const String ALERT_MESSAGE_EVENT = 'alertMessage';
  static const String LISTEN_ALERT_MESSAGE_EVENT = 'receiveAlert';
  static const String IS_USER_ONLINE_EVENT = 'check_online';
  static const String SUB_EVENT_MESSAGE_FROM_SERVER = 'message_from_server';

  static const int STATUS_MESSAGE_NOT_SENT = 10001;
  static const int STATUS_MESSAGE_SENT = 10002;
  static const int STATUS_MESSAGE_DELIVERED = 10003;
  static const int STATUS_MESSAGE_READ = 10004;

  static const String SINGLE_CHAT = 'single_chat';


  IO.Socket? _socket;

  initSocket() async {
    await _init();
  }

  _init() async {
    _socket = IO.io(_connectUrl,
      socketOptions(),
    );
  }

  Map<String, dynamic> socketOptions(){
    final Map<String, String> userMap = {
      // "from":_fromUser!.id.toString()
    };
    return {
      'transports': ['websocket'],
      'autoConnect': false,
      // 'query': userMap
    };
  }

  sendAlertMessage(data){
    debugPrint("alert message : $data");
    if (_socket == null) {
      debugPrint("Socket is Null, Cannot send message");
      return;
    }
    _socket!.emit(ALERT_MESSAGE_EVENT, [jsonEncode(data)]);
  }

  setOnMessageBackFromServer(Function onMessageBackFromServer) {
    _socket!.on(SUB_EVENT_MESSAGE_FROM_SERVER, (data) {
      onMessageBackFromServer(data);
    });
  }

  setOnAlertMessageFromServer(Function onMessageBackFromServer) {
    _socket!.on(LISTEN_ALERT_MESSAGE_EVENT, (data) {
      onMessageBackFromServer(data);
    });
  }

  checkOnline( sendMessageModel) {
    debugPrint('Checking Online: ${sendMessageModel.to}');
    if (null == _socket) {
      debugPrint("Socket is Null, Cannot send message");
      return;
    }
    _socket!.emit(IS_USER_ONLINE_EVENT, [sendMessageModel.toJson()]);
  }

  connectToSocket() {
    if (null == _socket) {
      debugPrint("Socket is Null");
      return;
    }
    debugPrint("Connecting to socket...");
    _socket!.connect();
  }

  setConnectListener(Function onConnect) {
    _socket!.onConnect((data) {
      onConnect(data);
    });
  }

  setOnConnectionErrorListener(Function onConnectError) {
    _socket!.onConnectError((data) {
      onConnectError(data);
    });
  }


  setOnErrorListener(Function onError) {
    _socket!.onError((error) {
      onError(error);
    });
  }

  setOnDisconnectListener(Function onDisconnect) {
    _socket!.onDisconnect((data) {
      debugPrint("onDisconnect $data");
      onDisconnect(data);
    });
  }

  setOnChatMessageReceivedListener(Function onChatMessageReceived) {
    _socket!.on(ON_MESSAGE_RECEIVED, (data) {
      debugPrint("Received $data");
      onChatMessageReceived(data);
    });
  }

  setOnMessageSentToChatUserListener(Function onMessageSentListener) {
    _socket!.on(SUB_EVENT_MESSAGE_SENT, (data) {
      debugPrint("onMessageSentListener $data");
      onMessageSentListener(data);
    });
  }

  setOnUserConnectionStatusListener(Function onUserConnectionStatus) {
    _socket!.on(IS_USER_CONNECTED_EVENT, (data) {
      onUserConnectionStatus(data);
    });
  }

  closeConnection() {
    if (null != _socket) {
      debugPrint("Close Connection");
      _socket!.close();
    }
  }
}

/*const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
// const {initializeApp, applicationDefault} = require('firebase-admin/app');
// const { getMessaging } = require('firebase-admin/messaging');
const cors = require('cors');
const admin = require('firebase-admin');
var mysql = require('mysql');
const FCM = require("fcm-node");
//fcm server key
const serverKey = "AAAA7wCQWoY:APA91bH1Kzy4sffZE9ftswfmDkOLu5tjI_sObnKghbmmgx8fkkFBQ3z2qU5W96V3DG2zOHhI37WoNMq_0_QIUPQlOa1S0cDO_01czA2IJ1hBIw8k55sC82-z0awd1uRwnRy6Y5EkMkas";
const fcm = new FCM(serverKey);
const app = express();
app.use(express.json());
app.use(
  cors({
    origin: "*",
  })
);
const server = http.createServer(app);
const io = socketIo(server);
app.use(express.static('public'));
const GOOGLE_APPLICATION_CREDENTIALS=require("./google-services.json")
//prenotificatiion
// const message = {
//   notification: {
//     title: "Notif",
//     body: 'This is a Test Notification'
//   },
//   // tokens: nearestDeviceTokens
//   to : "fs06mAxAT8C4ovHnezlxlX:APA91bFgRpdc_EkJjRHKQckHk1rAlDOHm3-Jfibxl9xzfR4ns_zJ3ubUlzN8rkG7qZjZ5qI1O8V_OwwxDuoI6GHcZCuYIbJOo-xc6_9OXcgSELz4zofrkqUGuXNpLYaNi_UyJtp2Dn5X"
// };
// fcm.send(message, function (err, response) {
//   if(err){
//     console.log("error sending message :", err);
//   } else {
//     console.log("send message:", response);
//   }
// })
io.on('connection', (socket) => {
  console.log('A user connected');
  // Handle custom events
  socket.on('alertMessage', (data) => {
    io.emit('receiveAlert', data); // Emit the alert to all connected clients
    console.log('Alert message received:', data);
  });
  // Handle disconnection
  socket.on('disconnect', () => {
    console.log('A user disconnected');
  });
});
//Fcm code implementation
app.use(
  cors({
    methods: ["GET", "POST", "DELETE", "UPDATE", "PUT", "PATCH"],
  })
);
app.use(function(req, res, next) {
  res.setHeader("Content-Type", "application/json");
  next();
});
//database connected
var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "crime_project"
});
con.connect(function(err) {
  if (err) throw err;
  console.log("Connected!");
});
// initializeApp({
//   credential: applicationDefault(),
//   projectId: 'causal-scarab-356404',
// });
admin.initializeApp({
// const GOOGLE_APPLICATION_CREDENTIALS="../google-services.json"
  credential: admin.credential.applicationDefault(),
  projectId: 'causal-scarab-356404',
  databaseURL: 'https://vigilanteye.firebaseio.com'
});
// Function to get device tokens from MySQL
async function getDeviceTokensFromDB() {
  return new Promise((resolve, reject) => {
    con.query('SELECT token FROM user_devices', (err, results) => {
      if (err) {
        reject(err);
      } else {
        const tokens = results.map(result => result.token);
        resolve(tokens);
        console.log(tokens);
      }
    });
  });
}
async function getNearestDeviceTokens() {
  return await getDeviceTokensFromDB();
}
//after open device send notification
app.post("/send", async function (req, res) {
  // const { currentLocation, fcmToken } = req.body;
  try {
    const nearestDeviceTokens = await getNearestDeviceTokens();
    const message = {
      notification: {
        title: "Notif",
        body: 'This is a Test Notification'
      },
      tokens: nearestDeviceTokens,
    };
    const response = await admin.messaging().sendMulticast(message);
    res.status(200).json({
      message: "Successfully sent message",
      tokens: nearestDeviceTokens,
      response: response,
    });
    console.log("Successfully sent message:", response);
  } catch (error) {
    res.status(400).json({
      message: "Error sending message",
      error: error.message,
    });
    console.log("Error sending message:", error);
  }
});
const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});*/