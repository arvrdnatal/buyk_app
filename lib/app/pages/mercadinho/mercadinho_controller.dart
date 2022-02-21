import 'dart:convert';

import 'package:buyk_app/app/services/obra_service.dart';
import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MercadinhoController {
  final _firebaseAuth = FirebaseAuth.instance;
  final _obraService = ObraService.instance;
  final _usuarioService = UsuarioService.instance;
  dynamic _setState;
  dynamic _usuario;

  MercadinhoController() {
    _setUsuario();
  }

  Future _setUsuario() async {
    _usuario = jsonDecode(jsonEncode((await _usuarioService.get(_firebaseAuth.currentUser!.uid))));
    _setState(() {});
  }

  Future carregarObras() async {
    List obrasFuture = await _obraService.getAll();
    Map obras = {};
    for(var obra in obrasFuture) {
      obras[obra.id] = obra.data();
    }
    return obras;
  }

  Future verObra(BuildContext context, String id, Map info) async {
    Map autor = await _usuarioService.get(info['autor']) as Map;
    bool leitura = _usuario['biblioteca'].contains(id);
    info.addEntries({'id': id, 'dados_autor': autor, 'leitura': leitura}.entries);
    Navigator.of(context).pushNamed('/verobra', arguments: info);
  }

  void meuPerfil(BuildContext context) => Navigator.of(context).pushNamed('/meuperfil');
  void adicionarObra(BuildContext context) => Navigator.of(context).pushNamed('/adicionarobra');

  set setSetState(dynamic function) => _setState = function;
}