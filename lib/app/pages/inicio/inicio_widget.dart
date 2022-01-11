import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  late String uid;

  @override
  Widget build(BuildContext context) {
    uid = ModalRoute.of(context)!.settings.arguments.toString();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(uid),
          ],
        ),
      ),
    );
  }
}
