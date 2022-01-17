import 'package:flutter/material.dart';

class InicioController {
  // controllers
  final PageController _pageController = PageController();
  // variáveis
  int pageSelected = 0;

  InicioController();

  PageController get pageController => _pageController;
}