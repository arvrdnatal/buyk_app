import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CadastroController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UsuarioService _usuarioService = UsuarioService.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  dynamic _mensagemValidacaoEmail;
  dynamic _mensagemValidacaoUsername;
  bool _isCheckingEmail = false;
  bool _isCheckingUsername = false;

  CadastroController();

  Future verificaEmail(dynamic setState) async {
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

  String? verificaSenha(String senha) {
    if(senha.isEmpty) return 'O campo senha é obrigatório';
    if(senha.length < 6) return 'A senha precisa de no mínimo 6 caracteres';
    return null;
  }

  Future verificaUsername(dynamic setState) async {
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

  void registrarUsuario({required GlobalKey<FormState> formKey, required BuildContext context, required dynamic setState}) {
    verificaEmail(setState);
    verificaUsername(setState);
    if (formKey.currentState!.validate()) {
      _firebaseAuth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text
      ).then((result) {
        return _usuarioService.add(result.user!.uid, {
          'nome': _nomeController.text,
          'sobrenome': _sobrenomeController.text,
          'email': _emailController.text,
          'senha': _senhaController.text,
          'username': _usernameController.text,
        }).then((_) => Navigator.of(context).pushNamedAndRemoveUntil('/mercadinho', (route) => false));
      }).catchError((error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()))));
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
}