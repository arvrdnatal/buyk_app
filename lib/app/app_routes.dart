import 'package:buyk_app/app/pages/adicionarObra/adicionarobra_widget.dart';
import 'package:buyk_app/app/pages/cadastro/cadastro_widget.dart';
import 'package:buyk_app/app/pages/editarPerfil/editarperfil_widget.dart';
import 'package:buyk_app/app/pages/getStarted/getstarted_widget.dart';
import 'package:buyk_app/app/pages/infoNovaObra/infonovaobra_widget.dart';
import 'package:buyk_app/app/pages/login/login_widget.dart';
import 'package:buyk_app/app/pages/mercadinho/mercadinho_widget.dart';
import 'package:buyk_app/app/pages/meuPerfil/meuperfil_widget.dart';
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
  };
}