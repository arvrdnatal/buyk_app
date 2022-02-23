import 'dart:convert';

import 'package:buyk_app/app/app_styles.dart';
import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _usuarioService = UsuarioService.instance;
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _senhaController = TextEditingController();
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  dynamic _mensagemValidacaoEmail;
  dynamic _mensagemValidacaoUsername;
  bool _isCheckingEmail = false;
  bool _isCheckingUsername = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _tituloPage(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _nomeCadastro(),
                    _sobrenomeCadastro(),
                    _usernameCadastro(),
                    _emailCadastro(),
                    _senhaCadastro(),
                  ],
                ),
              ),
              _botaoCadastrar(),
              _botaoLogin()
            ],
          ),
        ),
      ),
    );
  }

  Widget _tituloPage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Text('Cadastro', style: Theme.of(context).textTheme.headline2),
    );
  }

  Widget _nomeCadastro() {
    return AppStyles.getInput(
      controller: _nomeController,
      texto: 'Nome',
      context: context,
      isTheFirst: true,
    );
  }

  Widget _sobrenomeCadastro() {
    return AppStyles.getInput(
      controller: _sobrenomeController,
      texto: 'Sobrenome',
      context: context,
    );
  }

  Widget _usernameCadastro() {
    return AppStyles.getInput(
      controller: _usernameController,
      texto: 'Nome de Usuário',
      context: context,
      onChanged: (_) => _verificarUsername(),
      checking: _isCheckingUsername,
      validator: (_) {
        _verificarUsername();
        return _mensagemValidacaoUsername;
      },
    );
  }

  Widget _emailCadastro() {
    return AppStyles.getInput(
      controller: _emailController,
      texto: 'E-mail',
      context: context,
      onChanged: (_) => _verificarEmail(),
      validator: (_) {
        _verificarEmail();
        return _mensagemValidacaoEmail;
      },
      hasAutoValidate: true,
      checking: _isCheckingEmail,
    );
  }

  Widget _senhaCadastro() {
    return AppStyles.getInput(
      controller: _senhaController,
      texto: 'Senha',
      context: context,
      hasAutoValidate: true,
      validator: (_) => _verificarSenha(),
    );
  }

  Widget _botaoCadastrar() {
    return AppStyles.getElevatedButton(
      texto: 'Cadastrar',
      onPressed: () => _registrarUsuario(),
      minSize: false,
    );
  }

  Widget _botaoLogin() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Já possui uma conta?'),
          AppStyles.getTextButton(texto: 'Login', onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false)),
        ],
      ),
    );
  }

  // BACK-END
  Future _verificarUsername() async {
    String username = _usernameController.text;
    _mensagemValidacaoUsername = null;
    if(username.isEmpty) _mensagemValidacaoUsername = 'O campo username é obrigatório';
    if (username.contains(' ')) _mensagemValidacaoUsername = 'O nome de usuário não deve conter espaços';

    setState(() => _isCheckingUsername = true);

    List<String> usernames = [];
    for(var usuario in await _usuarioService.getAll()) {
      usernames.add(usuario['username']);
    }

    if(usernames.contains(username)) _mensagemValidacaoUsername = 'O usuário $username já existe';
    setState(() => _isCheckingUsername = false);
  }

  Future _verificarEmail() async {
    String email = _emailController.text;
    _mensagemValidacaoEmail = null;
    if(email.isEmpty) _mensagemValidacaoEmail = 'O campo e-mail é obrigatório';
    if(!EmailValidator.validate(email)) _mensagemValidacaoEmail = 'O e-mail digitado é inválido';

    setState(() => _isCheckingEmail = true);

    List<String> emails = [];
    for(var usuario in await _usuarioService.getAll()) {
      emails.add(usuario['email']);
    }

    if(emails.contains(email)) _mensagemValidacaoEmail = 'O email já está sendo utilizado';
    setState(() => _isCheckingEmail = false);
  }

  String? _verificarSenha() {
    String senha = _senhaController.text;
    if(senha.isEmpty) return 'O campo senha é obrigatório';
    if(senha.length < 6) return 'A senha precisa de no mínimo 6 caracteres';
    return null;
  }

  void _registrarUsuario() {
    if (_formKey.currentState!.validate()) {
      _firebaseAuth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text,
      ).then((result) {
        _usuarioService.add({
          'id': result.user!.uid,
          'nome': _nomeController.text,
          'sobrenome': _sobrenomeController.text,
          'email': _emailController.text,
          'senha': base64Url.encode(utf8.encode(_senhaController.text)),
          'username': _usernameController.text,
          'pontos': 2000,
          'biblioteca': [],
        }).then((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const AlertDialog(title: Text('Aguarde...'), content: LinearProgressIndicator()),
          );
          result.user!.sendEmailVerification().then((_) {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Atenção'),
                  content: const Text('Um e-mail de verificação foi enviado para você. Confira seu e-mail e volte para logar com sua conta!'),
                  actions: [
                    AppStyles.getTextButton(
                      texto: 'Ok',
                      onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false),
                    ),
                  ],
                );
              },
            );
          });
        });
      });
    }
  }
}
