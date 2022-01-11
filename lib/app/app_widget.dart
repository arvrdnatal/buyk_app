import 'package:buyk_app/app/app_routes.dart';
import 'package:buyk_app/app/app_colors.dart';
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
      initialRoute: '/',
      routes: AppRoutes.routes,
    );
  }
}