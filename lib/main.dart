import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testometer/models/data.dart';
import 'package:testometer/screens/coins.dart';
import 'package:testometer/shared/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const MyHomePage(title: 'Crypto Lite'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Welcome> fetchPrice() async {
    final response = await http
        .get(Uri.parse('https://api.coindesk.com/v1/bpi/currentprice.json'));
    print(response);
    if (response.statusCode == 200) {
      return Welcome.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load');
    }
  }

//add api call method in initsttae() , so that it does not repeatedly call in build method
  late Future<Welcome> futurePrice;

  @override
  void initState() {
    super.initState();
    futurePrice = fetchPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 30, 0, 40),
                    child: Text(
                      'Market Price for:',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  FutureBuilder(
                      future: futurePrice,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!.chartName,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Dollar:  ${snapshot.data!.bpi.usd.rate}',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Pound:  ${snapshot.data!.bpi.gbp.rate}',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Euros: ${snapshot.data!.bpi.eur.rate}',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              const SizedBox(height: 90),
                              Text(
                                  'Updated as at: ${snapshot.data!.time.updated}'),
                              const SizedBox(height: 130),
                              Text(snapshot.data!.disclaimer),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error!.toString());
                        }
                        return Loading();
                        // return CircularProgressIndicator(
                        //   color: Colors.yellowAccent,
                        // );
                      }),
                ],
              ),
              Spacer(
                flex: 2,
              ),
              InkWell(
                onTap: () async {
                  const url = 'https://coinmarketcap.com/';
                  if (await canLaunchUrlString(url)) {
                    await launchUrlString(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: double.infinity,
                  child: const Text(
                    'Other Coins Prices',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
