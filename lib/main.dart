import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:topup_shop/components/appbar.dart';
import 'package:topup_shop/components/game_card.dart';
import 'package:topup_shop/components/my_carosel.dart';
import 'package:topup_shop/firebase_options.dart';
import 'package:topup_shop/routes/my_routes.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Topup Store',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      routerConfig: routerConfig,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? gameId;
  String? errText;

  void getUid(String name) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              titlePadding: const EdgeInsets.only(left: 15, top: 25),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              actionsPadding: const EdgeInsets.only(right: 15, bottom: 25),
              title: const Text('Enter Game Id'),
              content: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  gameId = value;
                },
                decoration: InputDecoration(
                    hintText: "Enter game id", errorText: errText),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel",
                      style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.red.shade200),
                ),
                TextButton(
                  onPressed: () {
                    if (gameId == null || gameId!.isEmpty) {
                      setState(() {
                        errText = "Please enter game id";
                      });
                    } else {
                      setState(() {
                        errText = null;
                      });
                      int? validity = int.tryParse(gameId!);
                      if (validity == null) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Invalid Game Id")));
                      } else {
                        Navigator.pop(context);
                        context.go(Routes.offers,
                            extra: {"name": name, "gameId": gameId});
                      }
                    }
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
            );
          });
        });
  }

  @override
  void didChangeDependencies() {
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppBar(size, context),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              customCarosel(size),
              const SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(left: size.width > 850 ? 0 : 20),
                width: size.width > 850 ? size.width * .6 : size.width,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => getUid("freefire"),
                      child:
                          gameCard("Free Fire", "assets/images/freefire.jpg"),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () => getUid("pubg"),
                      child: gameCard("PUBG", "assets/images/pubg.png"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
