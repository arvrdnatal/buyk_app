import 'dart:convert';

import 'package:buyk_app/app/models/usuario_model.dart';
import 'package:buyk_app/app/services/interface_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioService implements IServices<UsuarioModel> {
  static final UsuarioService instance = UsuarioService._constructor();
  final CollectionReference _colection = FirebaseFirestore.instance.collection("usuarios");

  UsuarioService._constructor();

  @override
  Future add(UsuarioModel objeto) async {
    Map mapObjeto = objeto.toMap();
    Map<String, dynamic> usuario = {
      'email': mapObjeto['email'],
      'senha': mapObjeto['senha'],
      'username': mapObjeto['username'],
    };
    if(mapObjeto['nome']!.isNotEmpty) usuario['nome'] = mapObjeto['nome'];
    if(mapObjeto['sobrenome']!.isNotEmpty) usuario['sobrenome'] = mapObjeto['sobrenome'];
    if(mapObjeto['imagem']!.isNotEmpty) usuario['imagem'] = mapObjeto['imagem'];

    _colection.doc(mapObjeto['id']).set(usuario);
  }

  @override
  Future delete(String id) async => _colection.doc(id).delete();

  @override
  Future update(String id, Map<String, dynamic> informacoes) async {
      Map<String,dynamic> usuario = jsonDecode(jsonEncode((await _colection.doc(id).get()).data()));
      usuario.addEntries(informacoes.entries);
      usuario.removeWhere((key, value) => (value == '') || (value == null));
      _colection.doc(id).set(usuario);
  }

  @override
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
    };
  }

  @override
  Future getAll() async => (await _colection.get()).docs;
}