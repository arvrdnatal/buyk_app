import 'dart:convert';

import 'package:buyk_app/app/app_styles.dart';
import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({Key? key}) : super(key: key);

  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _usuarioService = UsuarioService.instance;
  final _usernameController = TextEditingController();
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  dynamic _mensagemValidacaoUsername;
  dynamic _usuario;
  bool _isBotaoEnabled = false;
  bool _isCheckingUsername = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      _usuario = jsonDecode(jsonEncode((await _usuarioService.get(_firebaseAuth.currentUser!.uid))));
      _nomeController.text = _usuario['nome'];
      _sobrenomeController.text = _usuario['sobrenome'];
      _usernameController.text = _usuario['username'];
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => _sair()),
      ),
      body: Align(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    nomeEditar(),
                    sobrenomeEditar(),
                    usernameEditar(),
                  ],
                ),
              ),
              botaoSalvarPerfil(),
            ],
          ),
        ),
      ),
    );
  }

  Widget nomeEditar() {
    return AppStyles.getInput(
      context: context,
      controller: _nomeController,
      texto: 'Nome',
      isTheFirst: true,
      onChanged: (_) => _mudarBotao(),
    );
  }

  Widget sobrenomeEditar() {
    return AppStyles.getInput(
      context: context,
      controller: _sobrenomeController,
      texto: 'Sobrenome',
      onChanged: (_) => _mudarBotao(),
    );
  }

  Widget usernameEditar() {
    return AppStyles.getInput(
      context: context,
      controller: _usernameController,
      texto: 'Nome de Usuário',
      onChanged: (_) {
        _mudarBotao();
        _verificaUsername();
      },
      checking: _isCheckingUsername,
      hasAutoValidate: true,
      validator: (_) => _mensagemValidacaoUsername,
    );
  }

  Widget botaoSalvarPerfil() {
    return Visibility(
      visible: _isBotaoEnabled,
      child: AppStyles.getElevatedButton(
        texto: 'Salvar',
        onPressed: () => _salvarAlteracoes()
      ),
    );
  }

  // BACK-END
  void _sair() {
    if(_isBotaoEnabled) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sair sem Salvar'),
          content: const Text('Tem certeza que deseja voltar sem salvar as alterações?'),
          actions: [
            AppStyles.getTextButton(texto: 'Cancelar', onPressed: () => Navigator.of(context).pop()),
            AppStyles.getTextButton(
              texto: 'Sim',
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  Future _mudarBotao() async {
    _isBotaoEnabled = false;
    if(_nomeController.text != _usuario['nome'] || _sobrenomeController.text != _usuario['sobrenome'] || _usernameController.text != _usuario['username']) {
      _isBotaoEnabled = true;
    }
    setState(() {});
  }

  Future _verificaUsername() async {
    String username = _usernameController.text;
    _mensagemValidacaoUsername = null;
    if(username != _usuario['username']) {
      if (username.isEmpty) _mensagemValidacaoUsername = 'O campo username é obrigatório';
      if (username.contains(' ')) _mensagemValidacaoUsername = 'O nome de usuário não deve conter espaços';

      setState(() => _isCheckingUsername = true);

      List<String> usernames = [];
      for (var usuario in await _usuarioService.getAll()) {
        usernames.add(usuario['username']);
      }

      if (usernames.contains(username)) _mensagemValidacaoUsername = 'O usuário $username já existe';
      setState(() => _isCheckingUsername = false);
    }
  }

  void _salvarAlteracoes() {
    if(_formKey.currentState!.validate()) {
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
}