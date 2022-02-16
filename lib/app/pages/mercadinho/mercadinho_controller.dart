import 'package:flutter/material.dart';

class MercadinhoController {

  MercadinhoController();

  void meuPerfil(BuildContext context) => Navigator.of(context).pushNamed('/meuperfil');
  void adicionarObra(BuildContext context) => Navigator.of(context).pushNamed('/adicionarobra');
}