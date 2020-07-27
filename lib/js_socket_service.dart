import 'package:interactive_webview/interactive_webview.dart';

class JSSocketService {
  static InteractiveWebView jsWebview;
  final String jsAppURL =
      "https://liqr.cc/bridge_socket"; // url of the JS application

  JSSocketService() {
    jsWebview = new InteractiveWebView();
    jsWebview.loadUrl(jsAppURL);
  }

//  _initJSWebListeners(String jwt) {
//    print("data from Javascript bridge..!!");
//
//    // Listener to receive data from Javascript to Flutter
//    JSSocketService.jsWebview.didReceiveMessage.listen((message) {
//      print("data from Javascript bridge  1..!!");
//      print(message.data);
////      callJavaScript('connect', 'eventData');
//      String eventName = message.data["eventName"]; // event name from server
//      String eventData = message.data["eventData"]; // event data from server
//
//      switch (eventName) {
//        case "ready_to_connect":
//          {
//            print('[socket] -> connecting with jwt..!');
//            socketEmit("connect", jwt);
//            break;
//          }
//
//        case "event_name_from_server":
//          {
//            if (eventData == null) {
//              return;
//            }
//            print("data from Javascript bridge.2.!!");
//            print(message);
//            break;
//          }
//
//        case "connect":
//          {
//            print('[socket] -> connected');
//            break;
//          }
//        case "disconnect":
//          {
//            print('[socket] -> disconnect');
//            break;
//          }
//        case "reconnect_attempt":
//          {
//            print('[socket] -> reconnect_attempt');
//            break;
//          }
//        case "reconnect":
//          {
//            print('[socket] -> reconnect');
//            break;
//          }
//      }
//    });
//  }

  _leaveChannel(String channelName) {
    socketEmit("leaveChannel", channelName);
  }

  // Method to send data from Flutter to Javascript
  void socketEmit(String eventName, String eventData) {
    String script =
        "javascript:document.dispatchEvent(new CustomEvent('flutterListener', {detail: {eventName: '$eventName',eventData: '$eventData'}}));";
    JSSocketService.jsWebview.evalJavascript(script);
    print(script);
  }
}
