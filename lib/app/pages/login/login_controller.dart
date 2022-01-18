import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginController {
  // services
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final UsuarioService _usuarioService = UsuarioService.instance;
  // controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  // variáveis
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
      _isCheckingEmail = true;
      _setState();

      List<String> emails = [];
      for(var usuario in await _usuarioService.getAll()) {
        emails.add(usuario['email']);
      }

      if(!emails.contains(email)) _mensagemValidacaoEmail = 'O email digitado não existe';
      _isCheckingEmail = false;
    }
    _setState();
  }

  Future verificaSenha() async {
    String senha = _senhaController.text;
    _mensagemValidacaoSenha = null;
    if(senha.isEmpty) _mensagemValidacaoSenha = 'O campo senha não pode ficar vazio';

    for(var usuario in await _usuarioService.getAll()) {
      if(usuario['email'] == _emailController.text) {
        if(senha != usuario['senha']) {
          _mensagemValidacaoSenha = 'Senha incorreta';
          _setState();
          return;
        }
      }
    }
  }

  Future vizualizarSenha() async {
    _senhaObscureText = !_senhaObscureText;
    _setState();
  }

  Future logarUsuario(GlobalKey<FormState> _formKey, BuildContext contextState) async {
    verificaEmail();
    verificaSenha();
    if (_formKey.currentState!.validate()) {
      firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text,
      ).then((_) {
        Navigator.of(contextState).pushNamedAndRemoveUntil('/inicio', (route) => false);
      }).catchError((error) {
        ScaffoldMessenger.of(contextState).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      });
    }
  }

  String? get mensagemValidacaoEmail => _mensagemValidacaoEmail;
  String? get mensagemValidacaoSenha => _mensagemValidacaoSenha;
  bool get isCheckingEmail => _isCheckingEmail;
  bool get senhaObscureText => _senhaObscureText;
  TextEditingController get emailController => _emailController;
  TextEditingController get senhaController => _senhaController;
  set setStateController(Function() funcao) => _setState = funcao;
}