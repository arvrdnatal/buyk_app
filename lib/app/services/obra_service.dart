import 'dart:convert';

import 'package:buyk_app/app/services/interface_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ObraService implements IServices {
  static final instance = ObraService._constructor();
  final _colection = FirebaseFirestore.instance.collection("obras");

  ObraService._constructor();

  @override
  Future add(Map<String, dynamic> info) async  => _colection.add(info);

  @override
  Future delete(String id) async {} // não se pode deletar uma obra ainda!

  @override
  Future get(String id) async {
    Map<String,dynamic> data = jsonDecode(jsonEncode((await _colection.doc(id).get()).data()));
    return {
      'id': (await _colection.doc(id).get()).id,
      'capa_livro': (data.containsKey('capa_livro') ? data['capa_livro'] : ''),
      'titulo': data['titulo'],
      'sinopse': data['sinopse'],
      'preco': data['preco'],
      'autor': data['autor'],
      'arquivo': data['arquivo'],
    };
  }

  @override
  Future getAll() async => (await _colection.get()).docs;
  Stream getAllStream() {
    return _colection.orderBy('nome').snapshots(); // não funfa ?
  }

  @override
  Future update(String id, Map<String, dynamic> info) async {} // também não se pode atualizar as informações de uma obra ainda!
}