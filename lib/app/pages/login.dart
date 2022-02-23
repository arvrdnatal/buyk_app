import 'dart:convert';

import 'package:buyk_app/app/app_styles.dart';
import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _usuarioService = UsuarioService.instance;
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  dynamic _mensagemValidacaoEmail;
  dynamic _mensagemValidacaoSenha;
  bool _isCheckingEmail = false;
  bool _senhaObscureText = true;

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
                    _emailLogin(),
                    _senhaLogin(),
                  ],
                ),
              ),
              _botaoEntrar(),
              _botaoCadastro(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tituloPage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 75),
      child: Text('Login', style: Theme.of(context).textTheme.headline2),
    );
  }

  Widget _emailLogin() {
    return Focus(
      onFocusChange: (focus) {
        if (focus) _verificarEmail();
      },
      child: AppStyles.getInput(
        controller: _emailController,
        texto: 'E-mail',
        context: context,
        isTheFirst: true,
        onChanged: (_) => _verificarEmail(),
        checking: _isCheckingEmail,
        hasAutoValidate: true,
        validator: (_) => _mensagemValidacaoEmail,
      ),
    );
  }

  Widget _senhaLogin() {
    return AppStyles.getInput(
      controller: _senhaController,
      texto: 'Senha',
      context: context,
      view: {
        'onPressed' : () => setState(() => _senhaObscureText = !_senhaObscureText),
        'obscure' : _senhaObscureText,
      },
      obscureText: _senhaObscureText,
      hasAutoValidate: true,
      validator: (_) {
        _verificarSenha();
        return _mensagemValidacaoSenha;
      },
    );
  }

  Widget _botaoEntrar() {
    return AppStyles.getElevatedButton(
      texto: 'Entrar',
      onPressed: () => _logar(),
      minSize: false,
    );
  }

  Widget _botaoCadastro() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Ainda não possui conta? '),
          AppStyles.getTextButton(texto: 'Cadastre-se', onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/cadastro', (route) => false)),
        ],
      ),
    );
  }

  // BACK-END
  Future _verificarEmail() async {
    String email = _emailController.text;
    _mensagemValidacaoEmail = null;
    if(email.isEmpty) {
      _mensagemValidacaoEmail = 'O campo e-mail não pode ficar vazio';
    } else if(!EmailValidator.validate(email)) {
      _mensagemValidacaoEmail = 'O e-mail digitado é inválido';
    } else {
      setState(() => _isCheckingEmail = true);

      List<String> emails = [];
      for(var usuario in await _usuarioService.getAll()) {
        emails.add(usuario['email']);
      }

      if(!emails.contains(email)) _mensagemValidacaoEmail = 'O email digitado não existe';
      setState(() => _isCheckingEmail = false);
    }
  }

  Future _verificarSenha() async {
    String senha = _senhaController.text;
    _mensagemValidacaoSenha = null;
    if(senha.isEmpty) _mensagemValidacaoSenha = 'O campo senha não pode ficar vazio';

    for(var usuario in await _usuarioService.getAll()) {
      if(usuario['email'] == _emailController.text) {
        if(base64Url.encode(utf8.encode(senha)) != usuario['senha']) {
          _mensagemValidacaoSenha = 'Senha incorreta';
          setState(() {});
          return;
        }
      }
    }
  }

  void _logar() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(title: Text('Aguarde...'), content: LinearProgressIndicator()),
    );
    if (_formKey.currentState!.validate()) {
      _firebaseAuth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _senhaController.text,
        ).then((result) {
          if (result.user!.emailVerified) {
            Navigator.of(context).pushNamedAndRemoveUntil('/mercadinho', (route) => false);
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Atenção'),
                  content: const Text('Você ainda não verificou seu email. Gostaria de reenviar a verificação?'),
                  actions: [
                    AppStyles.getTextButton(
                      texto: 'Sim',
                      onPressed: () => result.user!.sendEmailVerification().then((_) => Navigator.of(context).pop()),
                    ),
                    AppStyles.getTextButton(
                      texto: 'Não',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                );
              },
            );
          }
        });
    } else {
      Navigator.of(context).pop();
    }
  }
}
