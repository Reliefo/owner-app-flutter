import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ownerapp/authentication/loadingPage.dart';
import 'package:ownerapp/authentication/loginPage.dart';
import 'package:ownerapp/socketConnection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'url.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool authentication = false;
  bool showLoading = true;
  String accessToken;
  String restaurantId;
  String objectId;
  String managerName;
  Future<Map<String, dynamic>> _getSavedData() async {
    print("getData");

    final credentials = await SharedPreferences.getInstance();

    final restaurantId = credentials.getString('restaurantId');
    final objectId = credentials.getString('objectId');
    final refreshToken = credentials.getString('refreshToken');
    final managerName = credentials.getString('managerName');

    Map<String, dynamic> savedData = {
      "restaurantId": restaurantId,
      "staffId": objectId,
      "managerName": managerName,
      "refreshToken": refreshToken
    };

    print(savedData);

    return savedData;
  }

  checkRefresh() async {
    var savedData = await _getSavedData();

    print("Saved Refresh token : ${savedData["refreshToken"]} ");

    if (savedData["refreshToken"] != null) {
      print(" found refresh token calling refresh");
      refresh(refreshUrl);
    } else {
      print(" token not found calling login");
      setState(() {
        authentication = false;
        showLoading = false;
      });
    }
  }

  refresh(url) async {
    var savedData = await _getSavedData();

    setState(() {
      restaurantId = savedData["restaurantId"];
      objectId = savedData["objectId"];
      managerName = savedData["managerName"];
    });

    Map<String, String> headers = {
      "Authorization": "Bearer ${savedData["refreshToken"]}"
    };
    print("headers $headers");
    http.Response response = await http.post(url, headers: headers);

    int statusCode = response.statusCode;
    // this API passes back the id of the new item added to the body
    var decoded = json.decode(response.body);
    print("status in main page code");
    print(decoded);
    print(statusCode);
    if (statusCode == 200) {
      setState(() {
        accessToken = decoded["access_token"];
        showLoading = false;
        authentication = true;
      });
    } else {
      setState(() {
        authentication = false;
        showLoading = false;
      });
    }
  }

  @override
  void initState() {
    checkRefresh();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("here build method");
    print(refreshUrl);
    return showLoading == true
        ? LoadingPage()
        : authentication == true
            ? SocketConnection(
                jwt: accessToken,
                managerName: managerName,
                restaurantId: restaurantId,
              )
            : LoginPage();
  }
}
