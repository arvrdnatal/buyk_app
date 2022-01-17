import 'package:buyk_app/app/app_routes.dart';
import 'package:buyk_app/app/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  AppWidget({Key? key}) : super(key: key);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: GlobalColors.green,
        disabledColor: GlobalColors.deadGreen,
      ),
      initialRoute: _firebaseAuth.currentUser != null ? '/inicio' : '/',
      routes: AppRoutes.routes,
    );
  }
}