import 'dart:convert';

import 'package:async/async.dart';
import 'package:buyk_app/app/models/usuario_model.dart';
import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MeuPerfilController {
  // services
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UsuarioService _usuarioService = UsuarioService.instance;
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  // variáveis
  dynamic _setState;
  UsuarioModel? _usuario;

  MeuPerfilController() {
    _setUsuario();
  }

  Future _setUsuario() async {
    Map<String,dynamic> usuario = jsonDecode(jsonEncode((await _usuarioService.get(_firebaseAuth.currentUser!.uid))));
    _usuario = UsuarioModel(
      id: usuario['id'],
      nome: (usuario.containsKey('nome') ? usuario['nome'] : ''),
      sobrenome: (usuario.containsKey('sobrenome') ? usuario['sobrenome'] : ''),
      email: usuario['email'],
      senha: usuario['senha'],
      username: usuario['username'],
      imagem: (usuario.containsKey('imagem') ? usuario['imagem'] : ''),
    );
    _setState();
  }

  Future getDados() async {
    await _setUsuario();
    return _usuario?.toMap();
  }

  void editarPerfil(BuildContext context) {
    Navigator.of(context).pushNamed('/editarperfil');
  }

  void logoutUsuario(BuildContext context) {
    _firebaseAuth.signOut().then((_) {
      Navigator.of(context).pushNamed('/');
    });
  }

  AsyncMemoizer get memoizer => _memoizer;
  set setStateController(Function() funcao) => _setState = funcao;
}
