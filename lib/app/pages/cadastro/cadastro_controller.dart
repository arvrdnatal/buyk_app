import 'package:buyk_app/app/models/usuario_model.dart';
import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CadastroController {
  // services
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final UsuarioService _usuarioService = UsuarioService.instance;
  // controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  // variáveis
  dynamic _mensagemValidacaoEmail;
  dynamic _mensagemValidacaoUsername;
  dynamic _setState;
  bool _isCheckingEmail = false;
  bool _isCheckingUsername = false;

  CadastroController();

  Future verificaEmail() async {
    String email = _emailController.text;
    _mensagemValidacaoEmail = null;
    if(email.isEmpty) _mensagemValidacaoEmail = 'O campo e-mail é obrigatório';
    if(!EmailValidator.validate(email)) _mensagemValidacaoEmail = 'O e-mail digitado é inválido';

    _isCheckingEmail = true;
    _setState();

    List<String> emails = [];
    for(var usuario in await _usuarioService.getAll()) {
      emails.add(usuario['email']);
    }

    if(emails.contains(email)) _mensagemValidacaoEmail = 'O email já está sendo utilizado';
    _isCheckingEmail = false;
    _setState();
  }

  String? verificaSenha(String senha) {
    if(senha.isEmpty) return 'O campo senha é obrigatório';
    if(senha.length < 6) return 'A senha precisa de no mínimo 6 caracteres';
  }

  Future verificaUsername() async {
    String username = _usernameController.text;
    _mensagemValidacaoUsername = null;
    if(username.isEmpty) _mensagemValidacaoUsername = 'O campo username é obrigatório';

    _isCheckingUsername = true;
    _setState();

    List<String> usernames = [];
    for(var usuario in await _usuarioService.getAll()) {
      usernames.add(usuario['username']);
    }

    if(usernames.contains(username)) _mensagemValidacaoUsername = 'O usuário $username já existe';
    _isCheckingUsername = false;
    _setState();
  }

  registrarUsuario(GlobalKey<FormState> _formKey, BuildContext contextState) async {
    verificaEmail();
    verificaUsername();
    if (_formKey.currentState!.validate()) {
      firebaseAuth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text,
      ).then((result) {
        UsuarioModel usuario = UsuarioModel(
          id: result.user!.uid,
          nome: _nomeController.text,
          sobrenome: _sobrenomeController.text,
          email: _emailController.text,
          senha: _senhaController.text,
          username: _usernameController.text,
          imagem: '',
        );
        _usuarioService.add(usuario).then((_) {
          Navigator.of(contextState).pushNamedAndRemoveUntil('/inicio', (route) => false);
        });
      }).catchError((err) {
        ScaffoldMessenger.of(contextState).showSnackBar(
          SnackBar(content: Text(err.toString())),
        );
      });
    }
  }

  String? get mensagemValidacaoUsername => _mensagemValidacaoUsername;
  String? get mensagemValidacaoEmail => _mensagemValidacaoEmail;
  bool get isCheckingUsername => _isCheckingUsername;
  bool get isCheckingEmail => _isCheckingEmail;
  TextEditingController get emailController => _emailController;
  TextEditingController get usernameController => _usernameController;
  TextEditingController get senhaController => _senhaController;
  TextEditingController get nomeController => _nomeController;
  TextEditingController get sobrenomeController => _sobrenomeController;
  set setStateController(Function() funcao) => _setState = funcao;
}