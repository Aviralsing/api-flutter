import 'package:api/video.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';

void main() => runApp(MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  dynamic mapResponse;
  List listOfFacts = [];

  Future fetchData() async {
    http.Response response;
    response = await http.get(
        Uri.parse('https://my-json-server.typicode.com/Aviralsing/api/data'));
    if (response.statusCode == 200) {
      setState(() {
        mapResponse = json.decode(response.body);
        listOfFacts = mapResponse['facts'];
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API'),
        backgroundColor: Colors.blue[900],
      ),
      body: isLoading
          ? const Center(
              child: SizedBox(
                height: 24.0,
                width: 24.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    mapResponse['category'].toString(),
                    style: const TextStyle(fontSize: 30),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: 320.0,
                              child: ContentScreen(
                              src: listOfFacts[index]['image_url'],
                              looping: false,
                            )),
                            Text(
                              listOfFacts[index]['title'].toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              listOfFacts[index]['description'].toString(),
                              style: const TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: listOfFacts.isEmpty ? 0 : listOfFacts.length,
                  )
                ],
              ),
            ),
    );
  }
}
