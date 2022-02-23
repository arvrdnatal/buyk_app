import 'dart:convert';

import 'package:buyk_app/app/app_styles.dart';
import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginController {
  final _firebaseAuth = FirebaseAuth.instance;
  final _usuarioService = UsuarioService.instance;
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  dynamic _setState;
  dynamic _mensagemValidacaoEmail;
  dynamic _mensagemValidacaoSenha;
  bool _isCheckingEmail = false;
  bool _senhaObscureText = true;

  LoginController();

  Future verificaEmail() async {
    String email = _emailController.text;
    _mensagemValidacaoEmail = null;
    if(email.isEmpty) {
      _mensagemValidacaoEmail = 'O campo e-mail não pode ficar vazio';
    } else if(!EmailValidator.validate(email)) {
      _mensagemValidacaoEmail = 'O e-mail digitado é inválido';
    } else {
      _setState(() => _isCheckingEmail = true);

      List<String> emails = [];
      for(var usuario in await _usuarioService.getAll()) {
        emails.add(usuario['email']);
      }

      if(!emails.contains(email)) _mensagemValidacaoEmail = 'O email digitado não existe';
      _setState(() => _isCheckingEmail = false);
    }
  }

  Future verificaSenha() async {
    String senha = _senhaController.text;
    _mensagemValidacaoSenha = null;
    if(senha.isEmpty) _mensagemValidacaoSenha = 'O campo senha não pode ficar vazio';

    for(var usuario in await _usuarioService.getAll()) {
      if(usuario['email'] == _emailController.text) {
        if(base64Url.encode(utf8.encode(senha)) != usuario['senha']) {
          _mensagemValidacaoSenha = 'Senha incorreta';
          _setState(() {});
          return;
        }
      }
    }
  }

  Future vizualizarSenha() async => _setState(() => _senhaObscureText = !_senhaObscureText);

  void logarUsuario(GlobalKey<FormState> formKey, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(title: Text('Aguarde...'), content: LinearProgressIndicator()),
    );
    verificaEmail();
    verificaSenha();
    if (formKey.currentState!.validate()) {
      _firebaseAuth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _senhaController.text,
        ).then((result) {
          if (result.user!.emailVerified) {
            return Navigator.of(context).pushNamedAndRemoveUntil('/mercadinho', (route) => false);
          } else {
            return showDialog(
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
        }).catchError((error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()))));
    } else {
      Navigator.of(context).pop();
    }
  }

  String? get mensagemValidacaoEmail => _mensagemValidacaoEmail;
  String? get mensagemValidacaoSenha => _mensagemValidacaoSenha;
  bool get isCheckingEmail => _isCheckingEmail;
  bool get senhaObscureText => _senhaObscureText;
  TextEditingController get emailController => _emailController;
  TextEditingController get senhaController => _senhaController;
  set setStateController(dynamic funcao) => _setState = funcao;
}