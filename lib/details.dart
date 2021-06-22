import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Details extends StatefulWidget {
  const Details({Key key}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String apiDetails;
  var apiDetailslength;
  void apiDataGet() async {
    http.Response response =
        await http.get("https://api.androidhive.info/json/menu.json");

    if (response.statusCode == 200) {
      apiDetails = response.body;
      setState(() {
        apiDetailslength = jsonDecode(apiDetails);
        print(apiDetailslength);
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

  int current = 0;
  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    if (apiDetailslength == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: apiDetailslength.isEmpty
          ? Container()
          : Column(
              children: <Widget>[
                Container(
                  child: CarouselSlider.builder(
                    carouselController: buttonCarouselController,
                    options: CarouselOptions(
                        autoPlay: true,
                        scrollPhysics: ClampingScrollPhysics(),
                        autoPlayCurve: Curves.decelerate,
                        autoPlayAnimationDuration: Duration(seconds: 1),
                        enlargeCenterPage: false,
                        viewportFraction: 1.0,
                        height: 390,
                        initialPage: 0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            current = index;
                          });
                        }),
                    itemCount: apiDetailslength.length,
                    itemBuilder: (BuildContext context, int index) => Column(
                      children: [
                        ListTile(
                          title: Text(
                            '${apiDetailslength[index]["name"]}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle:
                              Text('${apiDetailslength[index]["description"]}'),
                          trailing:
                              Text('Rs: ${apiDetailslength[index]["price"]}'),
                        ),
                        Container(
                          child: Image.network(
                            '${apiDetailslength[index]["thumbnail"]}',
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(
                      apiDetailslength.length,
                      (index) => Container(
                        width: 12.0,
                        height: 12.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                    .withOpacity(current == index ? 0.9 : 0.3)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
