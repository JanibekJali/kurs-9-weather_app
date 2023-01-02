import 'dart:developer';

import 'package:flutter/material.dart';

class Misal extends StatefulWidget {
  const Misal({super.key});

  @override
  State<Misal> createState() => _MisalState();
}

class _MisalState extends State<Misal> {
  String? text;
  @override
  void initState() {
    log('initState ===> ');
    getText();

    super.initState();
  }

  @override
  void dispose() {
    log('Dispose ===> ');
    super.dispose();
  }

  Future<String>? getText() async {
    try {
      log('getText ===> ');
      await Future.delayed(const Duration(seconds: 3), () {
        text = 'Data keldi ';
      });
      setState(() {});
      log('getText ===> ');
      return text!;
    } catch (kata) {
      throw Exception(kata);
    }
    // return text = 'Data keldi sync';
  }

  @override
  Widget build(BuildContext context) {
    log('buildFunction ===> ');
    return Scaffold(
      body: Center(
          child: Text(
        text ?? 'Text 3 secunddan kiin kelet ',
        style: const TextStyle(fontSize: 35),
      )),
    );
  }
}
