import 'dart:convert';

import 'package:buyk_app/app/app_styles.dart';
import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditarPerfilController {
  final _firebaseAuth = FirebaseAuth.instance;
  final _usuarioService = UsuarioService.instance;
  final _usernameController = TextEditingController();
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  dynamic _setState;
  dynamic _mensagemValidacaoUsername;
  dynamic _usuario;
  bool _isBotaoEnabled = false;
  bool _isCheckingUsername = false;

  EditarPerfilController() {
    _setUsuario();
  }

  Future _setUsuario() async {
    _usuario = jsonDecode(jsonEncode((await _usuarioService.get(_firebaseAuth.currentUser!.uid))));
    _nomeController.text = _usuario['nome'];
    _sobrenomeController.text = _usuario['sobrenome'];
    _usernameController.text = _usuario['username'];
    _setState(() {});
  }

  void sair(BuildContext context) {
    if(_isBotaoEnabled) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Sair sem Salvar'),
            content: const Text('Tem certeza que deseja voltar sem salvar as alterações?'),
            actions: [
              AppStyles.getTextButton(
                texto: 'Cancelar',
                onPressed: () => Navigator.of(context).pop(),
              ),
              AppStyles.getTextButton(
                texto: 'Sim',
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  Future verificaUsername() async {
    String username = _usernameController.text;
    _mensagemValidacaoUsername = null;
    if(username != _usuario['username']) {
      if (username.isEmpty) _mensagemValidacaoUsername = 'O campo username é obrigatório';
      if (username.contains(' ')) _mensagemValidacaoUsername = 'O nome de usuário não deve conter espaços';

      _setState(() => _isCheckingUsername = true);

      List<String> usernames = [];
      for (var usuario in await _usuarioService.getAll()) {
        usernames.add(usuario['username']);
      }

      if (usernames.contains(username)) _mensagemValidacaoUsername = 'O usuário $username já existe';
      _setState(() => _isCheckingUsername = false);
    }
  }

  Future mudarBotao() async {
    _isBotaoEnabled = false;
    if(_nomeController.text != _usuario['nome'] || _sobrenomeController.text != _usuario['sobrenome'] || _usernameController.text != _usuario['username']) {
      _isBotaoEnabled = true;
    }
    _setState(() {});
  }

  salvarAlteracoes(GlobalKey<FormState> formKey, BuildContext context) {
    if(formKey.currentState!.validate()) {
      String? nome = _nomeController.text != _usuario['nome'] ? _nomeController.text : _usuario['nome'];
      String? sobrenome = _sobrenomeController.text != _usuario['sobrenome'] ? _sobrenomeController.text : _usuario['sobrenome'];
      String? username = _usernameController.text != _usuario['username'] ? _usernameController.text : _usuario['username'];
      _usuarioService.update(_firebaseAuth.currentUser!.uid, {
        'nome': nome,
        'sobrenome': sobrenome,
        'username': username,
      }).then((_) => Navigator.of(context).pop());
    }
  }

  String? get mensagemValidacaoUsername => _mensagemValidacaoUsername;
  bool get isCheckingUsername => _isCheckingUsername;
  bool get isBotaoEnabled => _isBotaoEnabled;
  TextEditingController get usernameController => _usernameController;
  TextEditingController get nomeController => _nomeController;
  TextEditingController get sobrenomeController => _sobrenomeController;
  set setStateController(dynamic funcao) => _setState = funcao;
}
