import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flgeetest/flgeetest.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(
          builder: (context) => Center(
            child: GestureDetector(
              onTap: () async {
                Flgeetest flGeetest = Flgeetest();
                GeetestToken token = await flGeetest.check(
                    context, '714ae136a3e16a0808e7d569290734d6');
                print(token.toMap());
              },
              child: Text('Running on: $_platformVersion\n'),
            ),
          ),
        ),
      ),
    );
  }
}
