import 'package:buyk_app/app/app_routes.dart';
import 'package:buyk_app/app/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  AppWidget({Key? key}) : super(key: key);
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(context),
      initialRoute: _firebaseAuth.currentUser != null ? '/mercadinho' : '/',
      routes: AppRoutes.routes,
    );
  }
}