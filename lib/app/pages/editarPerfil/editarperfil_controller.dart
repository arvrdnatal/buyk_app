import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:buyk_app/app/models/usuario_model.dart';
import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditarPerfilController {
  // services
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage =
      FirebaseStorage.instanceFor(app: Firebase.app());
  final UsuarioService _usuarioService = UsuarioService.instance;
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  // controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  // variáveis
  dynamic _setState;
  dynamic _mensagemValidacaoUsername;
  bool _isBotaoEnabled = false;
  bool _isCheckingUsername = false;
  UsuarioModel? _usuario;

  EditarPerfilController() {
    _setUsuario();
  }

  Future _setUsuario() async {
    Map<String, dynamic> usuario = jsonDecode(jsonEncode((await _usuarioService.get(_firebaseAuth.currentUser!.uid))));
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
    _nomeController.text = _usuario?.toMap()['nome'];
    _sobrenomeController.text = _usuario?.toMap()['sobrenome'];
    _usernameController.text = _usuario?.toMap()['username'];
    _setState();
    return _usuario?.toMap();
  }

  Future editarImagem() async {
    XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) {
      File? cropedImg = await ImageCropper.cropImage(
        sourcePath: img.path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      );
      if (cropedImg != null) {
        if (_usuario != null) {
          String nomeImg = _usuario!.toMap()['username'] + '-pp';
          Reference reference = _firebaseStorage.ref().child('profile-pictures/$nomeImg');
          TaskSnapshot taskSnapshot;
          if (_usuario!.toMap()['imagem'] != null) {
            taskSnapshot = await reference.putFile(cropedImg);
          } else {
            reference.delete();
            Reference newReference = _firebaseStorage.ref().child('profile-pictures/$nomeImg');
            taskSnapshot = await newReference.putFile(cropedImg);
          }
          String url = await taskSnapshot.ref.getDownloadURL();
          if (url.isNotEmpty) {
            _usuario!.imagem = url;
            _usuarioService.update(_firebaseAuth.currentUser!.uid, {'imagem': url});
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
    _usuarioService.update(_firebaseAuth.currentUser!.uid, {'imagem': ''});
  }

  Future verificaUsername() async {
    String username = _usernameController.text;
    _mensagemValidacaoUsername = null;
    if(username != _usuario!.toMap()['username']) {
      if (username.isEmpty) _mensagemValidacaoUsername = 'O campo username é obrigatório';
      if (username.contains(' ')) _mensagemValidacaoUsername = 'O nome de usuário não deve conter espaços';

      _isCheckingUsername = true;
      _setState();

      List<String> usernames = [];
      for (var usuario in await _usuarioService.getAll()) {
        usernames.add(usuario['username']);
      }

      if (usernames.contains(username)) _mensagemValidacaoUsername = 'O usuário $username já existe';
      _isCheckingUsername = false;
      _setState();
    }
  }

  Future mudarBotao() async {
    _isBotaoEnabled = false;
    Map usuario = _usuario!.toMap();
    if(_nomeController.text != usuario['nome'] || _sobrenomeController.text != usuario['sobrenome'] || _usernameController.text != usuario['username']) {
      _isBotaoEnabled = true;
    }
    _setState();
  }

  salvarAlteracoes(GlobalKey<FormState> formKey, BuildContext context) {
    if(formKey.currentState!.validate()) {
      Map usuario = _usuario!.toMap();
      String? nome = _nomeController.text != usuario['nome'] ? _nomeController.text : usuario['nome'];
      String? sobrenome = _sobrenomeController.text != usuario['sobrenome'] ? _sobrenomeController.text : usuario['sobrenome'];
      String? username = _usernameController.text != usuario['username'] ? _usernameController.text : usuario['username'];
      _usuarioService.update(_firebaseAuth.currentUser!.uid, {
        'nome' : nome,
        'sobrenome' : sobrenome,
        'username' : username,
      }).then((_) => Navigator.of(context).pop());
    }
  }

  String? get mensagemValidacaoUsername => _mensagemValidacaoUsername;
  bool get isCheckingUsername => _isCheckingUsername;
  bool get isBotaoEnabled => _isBotaoEnabled;
  AsyncMemoizer get memoizer => _memoizer;
  TextEditingController get usernameController => _usernameController;
  TextEditingController get nomeController => _nomeController;
  TextEditingController get sobrenomeController => _sobrenomeController;
  set setStateController(Function() funcao) => _setState = funcao;
}
