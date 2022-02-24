import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioService {
  static final instance = UsuarioService._constructor();
  final _colection = FirebaseFirestore.instance.collection('usuarios');

  UsuarioService._constructor();

  Future add(Map<String, dynamic> info) async {
    String id = info['id'];
    info.remove('id');
    _colection.doc(id).set(info);
  }

  // Future delete(String id) async => _colection.doc(id).delete();

  Future update(String id, Map<String, dynamic> info) async {
      Map<String,dynamic> usuario = jsonDecode(jsonEncode((await _colection.doc(id).get()).data()));
      Map<String,dynamic> biblioteca = {};
      if(usuario.containsKey('biblioteca')) {
        usuario['biblioteca'].forEach((id, info) {
          biblioteca[id] = info;
        });
        usuario.remove('biblioteca');
      }
      if(info.containsKey('biblioteca')) {
        info['biblioteca'].forEach((id, info) {
          biblioteca[id] = info;
        });
        info.remove('biblioteca');
      }
      usuario.addEntries(info.entries);
      usuario['biblioteca'] = biblioteca;
      usuario.removeWhere((key, value) => (value == '') || (value == null));
      _colection.doc(id).set(usuario);
  }

  Future get(String id) async {
    Map<String,dynamic> data = jsonDecode(jsonEncode((await _colection.doc(id).get()).data()));
    return {
      'id': (await _colection.doc(id).get()).id,
      'nome': (data.containsKey('nome') ? data['nome'] : ''),
      'sobrenome': (data.containsKey('sobrenome') ? data['sobrenome'] : ''),
      'email': data['email'],
      'senha': data['senha'],
      'username': data['username'],
      'imagem': (data.containsKey('imagem') ? data['imagem'] : ''),
      'pontos': data['pontos'],
      'biblioteca': data['biblioteca'],
    };
  }

  Future getAll() async => (await _colection.get()).docs;
}