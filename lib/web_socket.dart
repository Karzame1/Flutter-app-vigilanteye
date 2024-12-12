


import 'dart:io';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService{
  static String _serverIP = Platform.isIOS ? 'http://localhost' : 'http://10.0.2.2';
  static const int SERVER_PORT = 5000;
  static String _connectUrl = 'https://real-chat-node.onrender.com/';

  static const String ON_MESSAGE_RECEIVED = 'receive_alert';
  static const String SUB_EVENT_MESSAGE_SENT = 'alert_sent_to_user';
  static const String IS_USER_CONNECTED_EVENT = 'is_user_connected';
  static const String IS_USER_ONLINE_EVENT = 'check_online';
  static const String SUB_EVENT_MESSAGE_FROM_SERVER = 'alert_from_server';

  static const int STATUS_MESSAGE_NOT_SENT = 10001;
  static const int STATUS_MESSAGE_SENT = 10002;
  static const int STATUS_MESSAGE_DELIVERED = 10003;
  static const int STATUS_MESSAGE_READ = 10004;

  static const String SINGLE_CHAT = 'single_chat';


  initSocket() async {
    print('Connecting user...');
    await _init();
  }

  String socketUrl() {
    if (Platform.isAndroid) {
      return "http://10.0.2.2:3000";  //default ip address of android emulator
    } else {
      return "http://localhost:3000"; // for ios simulator
    }
  }

  Map<String, dynamic> socketOptions(){
    final Map<String, String> userMap = {
      "from":"karzame_app"
    };
    return {
      'transports': ['websocket'],
      'autoConnect': false,
      'query': userMap
    };
  }

  ///socket url for private server...
  /*
  String socketUrl() {
  return "https://your-online-server-url.com";
  }
  */

  IO.Socket? _socket;
  _init() async {
    _socket = IO.io(socketUrl(),
      socketOptions(),
    );
  }

  sendSingleChatMessage() {
    if (_socket == null) {
      print("Socket is Null, Cannot send message");
      return;
    }
    _socket!.emit("single_chat_message", [/*chatMessageModel.toJson()*/]);
  }

  setOnAlertBackFromServer(Function onMessageBackFromServer) {
    _socket!.on(SUB_EVENT_MESSAGE_FROM_SERVER, (data) {
      onMessageBackFromServer(data);
    });
  }

  getAlertMessage(){
      if( _socket != null){

      }
  }

}