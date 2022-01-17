import 'dart:convert';
import 'dart:io';

import 'package:buyk_app/app/models/usuario_model.dart';
import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MeuPerfilController {
  // services
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instanceFor(app: Firebase.app());
  final UsuarioService _usuarioService = UsuarioService.instance;
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
    _setUsuario();
    return _usuario!.toMap();
  }

  Future editarImagem() async {
    XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(img != null) {
      File? cropedImg = await ImageCropper.cropImage(
        sourcePath: img.path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      );
      if(cropedImg != null) {
        if(_usuario != null) {
          String nomeImg = _usuario!.toMap()['username'] + '-pp';
          Reference reference = _firebaseStorage.ref().child('profile-pictures/$nomeImg');
          TaskSnapshot taskSnapshot;
          if(_usuario!.toMap()['imagem'] != null) {
            taskSnapshot = await reference.putFile(cropedImg);
          } else {
            reference.delete();
            Reference newReference = _firebaseStorage.ref().child('profile-pictures/$nomeImg');
            taskSnapshot = await newReference.putFile(cropedImg);
          }
          String url = await taskSnapshot.ref.getDownloadURL();
          if(url.isNotEmpty) {
            _usuario!.imagem = url;
            _usuarioService.update(_firebaseAuth.currentUser!.uid, {'imagem' : url});
          }
        }
      }
    }
    _setState();
  }

  Future removerImagem() async {
    String nomeImg = _usuario!.toMap()['username'] + '-pp';
    _firebaseStorage.ref().child('profile-pictures/$nomeImg').delete();
    _usuario!.imagem = '';
    _usuarioService.update(_firebaseAuth.currentUser!.uid, {'imagem' : ''});
  }

  void editarPerfil(BuildContext context) {
    Navigator.of(context).pushNamed('/editarperfil');
  }

  void logoutUsuario(BuildContext context) {
    _firebaseAuth.signOut().then((_) {
      Navigator.of(context).pushNamed('/');
    });
  }

  set setStateController(Function() funcao) => _setState = funcao;
}
