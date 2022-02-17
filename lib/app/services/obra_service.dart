import 'package:buyk_app/app/services/interface_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ObraService implements IServices {
  static final instance = ObraService._constructor();
  final _colection = FirebaseFirestore.instance.collection("obras");

  ObraService._constructor();

  @override
  Future add(Map<String, dynamic> info) async {
    print(info);
    throw UnimplementedError();
    // String id = info['id'];
    // info.remove('id');
    // _colection.doc(id).set(info);
  }

  @override
  Future delete(String id) async {} // não se pode deletar uma obra ainda!

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
    // Map<String,dynamic> data = jsonDecode(jsonEncode((await _colection.doc(id).get()).data()));
    // return {
    //   'id': (await _colection.doc(id).get()).id,
    //   'nome': (data.containsKey('nome') ? data['nome'] : ''),
    //   'sobrenome': (data.containsKey('sobrenome') ? data['sobrenome'] : ''),
    //   'email': data['email'],
    //   'senha': data['senha'],
    //   'username': data['username'],
    //   'imagem': (data.containsKey('imagem') ? data['imagem'] : ''),
    // };
  }

  @override
  Future getAll() async => (await _colection.get()).docs;

  @override
  Future update(String id, Map<String, dynamic> info) async {} // também não se pode atualizar as informações de uma obra ainda!
}