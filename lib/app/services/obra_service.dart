import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ObraService {
  static final instance = ObraService._constructor();
  final _colection = FirebaseFirestore.instance.collection('obras');

  ObraService._constructor();

  Future add(Map<String, dynamic> info) async  => _colection.add(info);

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
      'publicacao': data['publicacao'],
    };
  }

  Future getAll() async => (await _colection.get()).docs;
  Stream getAllStream() => _colection.orderBy("publicacao", descending: true).snapshots();
}