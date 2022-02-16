import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UsuarioService _usuarioService = UsuarioService.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  dynamic _mensagemValidacaoEmail;
  dynamic _mensagemValidacaoSenha;
  bool _isCheckingEmail = false;
  bool _senhaObscureText = true;

  LoginController();

  Future verificaEmail(dynamic setState) async {
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

  Future verificaSenha(dynamic setState) async {
    String senha = _senhaController.text;
    _mensagemValidacaoSenha = null;
    if(senha.isEmpty) _mensagemValidacaoSenha = 'O campo senha não pode ficar vazio';

    for(var usuario in await _usuarioService.getAll()) {
      if(usuario['email'] == _emailController.text) {
        if(senha != usuario['senha']) {
          _mensagemValidacaoSenha = 'Senha incorreta';
          setState(() {});
          return;
        }
      }
    }
  }

  Future vizualizarSenha(dynamic setState) async => setState(() => _senhaObscureText = !_senhaObscureText);

  void logarUsuario({required GlobalKey<FormState> formKey, required BuildContext context, required dynamic setState}) {
    verificaEmail(setState);
    verificaSenha(setState);
    if (formKey.currentState!.validate()) {
      _firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text,
      ).then((_) => Navigator.of(context).pushNamedAndRemoveUntil('/mercadinho', (route) => false))
      .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()))));
    }
  }

  String? get mensagemValidacaoEmail => _mensagemValidacaoEmail;
  String? get mensagemValidacaoSenha => _mensagemValidacaoSenha;
  bool get isCheckingEmail => _isCheckingEmail;
  bool get senhaObscureText => _senhaObscureText;
  TextEditingController get emailController => _emailController;
  TextEditingController get senhaController => _senhaController;
}