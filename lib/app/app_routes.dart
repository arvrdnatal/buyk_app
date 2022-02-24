import 'package:buyk_app/app/pages/adicionarobra.dart';
import 'package:buyk_app/app/pages/cadastro.dart';
import 'package:buyk_app/app/pages/editarperfil.dart';
import 'package:buyk_app/app/pages/getStarted/getstarted_widget.dart';
import 'package:buyk_app/app/pages/infonovaobra.dart';
import 'package:buyk_app/app/pages/leitor.dart';
import 'package:buyk_app/app/pages/login.dart';
import 'package:buyk_app/app/pages/mercadinho.dart';
import 'package:buyk_app/app/pages/meuperfil.dart';
import 'package:buyk_app/app/pages/verobra.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static final Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => const GetStarted(),
    '/cadastro': (context) => const Cadastro(),
    '/login': (context) => const Login(),
    '/mercadinho': (context) => const Mercadinho(),
    '/meuperfil': (context) => const MeuPerfil(),
    '/editarperfil': (context) => const EditarPerfil(),
    '/adicionarobra': (context) => const AdicionarObra(),
    '/infonovaobra': (context) => const InfoNovaObra(),
    '/verobra': (context) => const VerObra(),
    '/leitor': (context) => const Leitor(),
  };
}