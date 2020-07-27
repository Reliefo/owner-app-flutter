import 'dart:convert';

import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:flutter/material.dart';
import 'package:ownerapp/Home/homeScreen.dart';
import 'package:ownerapp/data.dart';
import 'package:ownerapp/js_socket_service.dart';
import 'package:ownerapp/url.dart';

class SocketConnection extends StatefulWidget {
  final String jwt;
  final String restaurantId;
  final String managerName;
  SocketConnection({
    this.jwt,
    this.restaurantId,
    this.managerName,
  });

  @override
  _SocketConnectionState createState() => _SocketConnectionState();
}

class _SocketConnectionState extends State<SocketConnection> {
  @override
  void initState() {
//    initSocket(uri);
    initNewSocket();

    super.initState();
  }

  JSSocketService jsSocket;
  SocketIOManager manager = SocketIOManager();
  Map<String, SocketIO> sockets = {};
  Map<String, bool> _isProbablyConnected = {};
  List<RestaurantOrderHistory> orderHistory = [];

  initNewSocket() {
    jsSocket = new JSSocketService();

    JSSocketService.jsWebview.didReceiveMessage.listen((message) {
      String eventName = message.data["eventName"]; // event name from server
      String eventData = message.data["eventData"]; // event data from server

      switch (eventName) {
        case "ready_to_connect":
          {
            print('[socket] -> connecting with jwt..!');
            jsSocket.socketEmit("connect",
                jsonEncode({"naveen": widget.jwt, "socket_url": uri}));
            break;
          }

        case "connect":
          {
            print('[socket] -> connected');

            jsSocket.socketEmit("fetch_rest_owner",
                jsonEncode({"restaurant_id": widget.restaurantId}));
            break;
          }
        case "disconnect":
          {
            print('[socket] -> disconnect');
            break;
          }
        case "reconnect_attempt":
          {
            print('[socket] -> reconnect_attempt');
            break;
          }
        case "reconnect":
          {
            print('[socket] -> reconnect');
            break;
          }

        case "billing":
          {
            print('[socket] -> fetch billing');

            fetchBilled(eventData);
            break;
          }
        case "logger":
          {
            print('[socket] -> logger');
            pprint(eventData);
            break;
          }

        case "restaurant_object":
          {
            print('[socket] -> restaurant');
            fetchRestaurant(eventData);
            break;
          }
      }
    });
  }

  initSocket(String uri) async {
    print('hey from new init file');
//    print(loginSession.jwt);
//    print(sockets.length);
    var identifier = 'working';
    SocketIO socket = await manager.createInstance(SocketOptions(
        //Socket IO server URI
        uri,
        nameSpace: "/reliefo",
        //Query params - can be used for authentication
        query: {
          "jwt": widget.jwt,
//          "username": loginSession.username,
          "info": "new connection from adhara-socketio",
          "timestamp": DateTime.now().toString()
        },
        //Enable or disable platform channel logging
        enableLogging: false,
        transports: [
          Transports.WEB_SOCKET /*, Transports.POLLING*/
//          Transports.POLLING
        ] //Enable required transport

        ));
    socket.onConnect((data) {
      pprint({"Status": "connected..."});
//      pprint(data);
//      sendMessage("DEFAULT");
      socket.emit("fetch_rest_owner", [
        jsonEncode({"restaurant_id": widget.restaurantId})
      ]);

      socket.emit("check_logger", [" sending........."]);
    });
    socket.onConnectError(pprint);
    socket.onConnectTimeout(pprint);
    socket.onError(pprint);
    socket.onDisconnect((data) {
      print('object disconnnecgts');
//      disconnect('working');
    });
    socket.on("logger", (data) => pprint(data));

    socket.on("restaurant_object", (data) => fetchRestaurant(data));

    socket.on("billing", (data) => fetchBilled(data));

    socket.connect();
    sockets[identifier] = socket;
  }

  bool isProbablyConnected(String identifier) {
    return _isProbablyConnected[identifier] ?? false;
  }

  disconnect(String identifier) async {
    await manager.clearInstance(sockets[identifier]);
    _isProbablyConnected[identifier] = false;
  }

  pprint(data) {
    if (data is Map) {
      data = json.encode(data);
    }
    print("from logger: $data");
  }

//////////////////////////////restaurant///////////////////////////
  fetchRestaurant(data) {
    setState(() {
      if (data is Map) {
        data = json.encode(data);
      }
      orderHistory.clear();
      var decoded = jsonDecode(data);

      print("here:  ");

      print(decoded["order_history"]);

      decoded["order_history"]?.forEach((history) {
        RestaurantOrderHistory order = RestaurantOrderHistory.fromJson(history);

        orderHistory.add(order);
      });
    });
  }

  fetchBilled(data) {
    print("inside billing");
    print(data);
    print(data["order_history"].keys.toList());

    if (data["status"] == "billed") {
      setState(() {
        /////////////////////// add bill to history ///////////////////
        RestaurantOrderHistory history =
            RestaurantOrderHistory.fromJson(data["order_history"]);

        orderHistory.add(history);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("hereeeeww");
    print(widget.managerName);

    return MaterialApp(
      home: Scaffold(
//        appBar: AppBar(
//          title: FlatButton(
//            child: Text("connect"),
//            onPressed: () {
////              jsSocket.callJavaScript("connect", "eventData");
//            },
//          ),
//        ),
        body: HomeScreen(
          orderHistory: orderHistory,
        ),
      ),
    );
  }
}
