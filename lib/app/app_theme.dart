import 'package:buyk_app/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static getTheme(BuildContext context) {
    return ThemeData(
      // cores
      brightness: Brightness.dark,
      primaryColor: AppColors.deadGreen,
      focusColor: AppColors.lightGreen,
      errorColor: Colors.red,
      hintColor: AppColors.deadGreen.withOpacity(0.5),
      disabledColor: AppColors.deadGreen.withOpacity(0.5),
      scaffoldBackgroundColor: AppColors.black,
      dialogBackgroundColor: AppColors.black,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        primarySwatch: AppColors.createMaterialColor(AppColors.deadGreen),
        accentColor: AppColors.deadGreen,
      ),
      // app bar
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        color: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.deadGreen),
        actionsIconTheme: IconThemeData(color: AppColors.deadGreen),
        titleTextStyle: GoogleFonts.raleway(color: AppColors.deadGreen, fontWeight: FontWeight.bold),
      ),
      // textos
      fontFamily: GoogleFonts.montserrat().fontFamily,
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 40, letterSpacing: 1, color: AppColors.deadGreen),
        headline2: TextStyle(fontSize: 30, letterSpacing: 1, color: AppColors.deadGreen),
        headline3: TextStyle(fontSize: 20, letterSpacing: 1, color: AppColors.deadGreen),
        headline6: TextStyle(letterSpacing: 1, color: AppColors.lightGreen),
        subtitle1: TextStyle(letterSpacing: 1, color: AppColors.deadGreen),
        bodyText2: TextStyle(fontSize: 15, letterSpacing: 1, color: AppColors.deadGreen),
        button: TextStyle(fontSize: 15, letterSpacing: 1, color: AppColors.lightGreen),
        caption: TextStyle(fontSize: 10, letterSpacing: 1, color: AppColors.deadGreen),
      ),
      // divider
      dividerTheme: DividerThemeData(
        color: AppColors.deadGreen,
        space: 50,
        indent: 30, endIndent: 30,
      ),
      // botões
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(EdgeInsets.zero),
          foregroundColor: MaterialStateProperty.all<Color?>(AppColors.lightGreen),
          textStyle: MaterialStateProperty.all<TextStyle?>(GoogleFonts.raleway(fontSize: 15, letterSpacing: 1)),
        )
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder?>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
          side: MaterialStateProperty.all<BorderSide?>(BorderSide(color: AppColors.deadGreen)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder?>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15)),
          textStyle: MaterialStateProperty.all<TextStyle?>(GoogleFonts.raleway(fontSize: 15, letterSpacing: 1, fontWeight: FontWeight.bold)),
        )
      ),
      // inputs
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.deadGreen)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.lightGreen, width: 2)),
        errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      ),
    );
  }
}