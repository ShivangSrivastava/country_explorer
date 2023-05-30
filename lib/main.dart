import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

// https://restcountries.com/v3.1/name/india
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: ThemeData(
        primaryColor: Colors.redAccent,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List listResponse = [];
  Map data = {};

  String country = 'india';

  TextEditingController _controller = TextEditingController();

  Future getData(country) async {
    http.Response response;
    response = await http
        .get(Uri.parse('https://restcountries.com/v3.1/name/$country'));

    if (response.statusCode == 200) {
      setState(() {
        listResponse = jsonDecode(response.body);
        data = listResponse.first;
        String name = data['name']['common'].toString();
        String currency = data['currencies'].toString();
        String capital = data['capital'].toString();
        String population = data['population'].toString();
        String timezones = data['timezones'].toString();
        String region = data['region'].toString();
        String flag = data['flags']['png'].toString();
        String area = data['area'].toString();
        data.clear();
        data['name'] = name;
        data['currency'] = currency;
        data['capital'] = capital;
        data['population'] = population;
        data['timezones'] = timezones;
        data['region'] = region;
        data['flag'] = flag;
        data['area'] = area;
      });
    }
  }

  Widget myCard(String desc, String title) {
    return Card(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                title.toString().toUpperCase(),
                style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B0000)),
              ),
              Text(
                desc.toString().toUpperCase(),
                style: TextStyle(
                    letterSpacing: 3,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF002A5C)),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  void initState() {
    getData(country);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.search), Text("Country Explorer")],
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: (data.isEmpty)
          ? const SplashScreen()
          : Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://source.unsplash.com/random/?${data['name']}"),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 100,
                            backgroundColor: Colors.transparent,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                data['flag'],
                                fit: BoxFit.cover,
                                height: 202,
                                width: 202,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: myCard(data['name'], 'Country Name'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: myCard(
                              data['capital'].toString().substring(
                                  1, data['capital'].toString().length - 1),
                              'Capital'),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            myCard(data['currency'].toString().substring(1, 4),
                                'Currency'),
                            myCard(data['region'], 'Region'),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Center(child: myCard(data['population'], 'Population')),
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: myCard(
                              data['timezones'].toString().substring(
                                    1,
                                    (data['timezones'].toString().length - 1),
                                  ),
                              'Timezones'),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Center(child: myCard(data['area'], 'Area (km2)')),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.fromLTRB(10, 2, 0, 2),
                              labelText: "Country",
                              hintText: 'e.g. India',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              if (_controller.text.isNotEmpty) {
                                country = _controller.text;
                                getData(country);
                                data.clear();
                                _controller.clear();
                              }
                            });
                          },
                          icon: Icon(Icons.search),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 2),
                            child: Text(
                              'Explore',
                              style: TextStyle(fontSize: 20, letterSpacing: 2),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.redAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpinKitFadingCube(
              color: Colors.white,
              size: 60,
            ),
            SizedBox(height: 50),
            Text(
              "Country Explorer",
              style: TextStyle(
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text("Loading...")
          ],
        ),
      ),
    );
  }
}
