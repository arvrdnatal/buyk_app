import 'package:flutter/material.dart';

class Busca extends StatefulWidget {
  const Busca({Key? key}) : super(key: key);

  @override
  _BuscaState createState() => _BuscaState();
}

class _BuscaState extends State<Busca> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Busca'),
      ),
    );
  }
}
