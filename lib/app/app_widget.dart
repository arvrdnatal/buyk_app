import 'package:buyk_app/app/global/colors_global.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: GlobalColors.green,
        disabledColor: GlobalColors.deadGreen,
      ),
      home: const Center(
        child: Text('inicio'),
      ),
    );
  }
}