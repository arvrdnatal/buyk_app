import 'package:flutter/material.dart';

class Mercadinho extends StatefulWidget {
  const Mercadinho({Key? key}) : super(key: key);

  @override
  _MercadinhoState createState() => _MercadinhoState();
}

class _MercadinhoState extends State<Mercadinho> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Mercadinho'),
      ),
    );
  }
}
