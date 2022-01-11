import 'package:buyk_app/app/pages/cadastro/cadastro_widget.dart';
import 'package:buyk_app/app/pages/getStarted/getstarted_widget.dart';
import 'package:buyk_app/app/pages/inicio/inicio_widget.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static final Map<String, Widget Function(BuildContext)> routes = {
    '/' : (context) => const GetStarted(),
    '/cadastro' : (context) => const Cadastro(),
    '/inicio' : (context) => const Inicio(),
  };
}