import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'details.dart';
import 'login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String apiData;
  var apiDatalength;
  void apiDataGet() async {
    http.Response response =
        await http.get("https://api.androidhive.info/contacts/");

    if (response.statusCode == 200) {
      apiData = response.body;
      setState(() {
        apiDatalength = jsonDecode(apiData)['contacts'];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    super.initState();
    apiDataGet();
  }

  @override
  Widget build(BuildContext context) {
    if (apiDatalength == null) {
      return Center(child: CircularProgressIndicator());
    }
    return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: Scaffold(
          appBar: AppBar(
            title: Text("Home"),
            leading: Icon(Icons.home),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: (25),
                ),
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('sessiondata', null);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),
            ],
          ),
          body: ListView.builder(
              shrinkWrap: true,
              itemCount: apiDatalength.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Details()),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(apiDatalength[index]['id']),
                          Text(apiDatalength[index]['name']),
                          Text(apiDatalength[index]['email']),
                          Text(apiDatalength[index]['address']),
                          Text(apiDatalength[index]['gender']),
                          Text(apiDatalength[index]['phone']['mobile']),
                          Text(apiDatalength[index]['phone']['home']),
                          Text(apiDatalength[index]['phone']['office']),
                        ],
                      ),
                    ),
                  ),
                );
              })),
    );
  }
}
