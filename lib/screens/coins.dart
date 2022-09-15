import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:testometer/models/coindata.dart';
import 'package:http/http.dart' as http;
import 'package:testometer/shared/loading.dart';

class CoinsScreens extends StatefulWidget {
  const CoinsScreens({super.key});

  @override
  State<CoinsScreens> createState() => _CoinsScreensState();
}

class _CoinsScreensState extends State<CoinsScreens> {
//call coin layer api
  Future<Coins> fetchCoins() async {
    final response = await http.get(Uri.parse(
        'http://api.coinlayer.com/api/live?access_key=f0ca0093194a202ecabc1d20e346a817'));
    print(response);
    if (response.statusCode == 200) {
      return Coins.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load coins data');
    }
  }

  late Future<Coins> futureCoins;

  @override
  void initState() {
    super.initState();
    futureCoins = fetchCoins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coins'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: futureCoins,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // return Text(snapshot.data!.toString());
                return ListView.builder(
                    itemCount: snapshot.data!.rates.length,
                    itemBuilder: ((context, index) {
                      return ListTile(
                        onTap: () {
                          // print(snapshot.data!.rates.entries.map((e) => e.value));
                        },
                        title: Text(snapshot.data!.success.toString()),
                      );
                    }));
              } else if (snapshot.hasError) {
                return Text(snapshot.error!.toString());
              }
              return const Loading();
            }),
      ),
    );
  }
}
