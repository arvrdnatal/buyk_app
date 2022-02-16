import 'package:buyk_app/app/app_styles.dart';
import 'package:buyk_app/app/pages/login/login_controller.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _controller = LoginController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Align(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
            ],
          ),
        ),
      ),
    );
  }

  // build
  Widget _emailLogin() {
    return AppStyles.getInput(
      controller: _controller.emailController,
      texto: 'E-mail',
      context: context,
      isTheFirst: true,
      onChanged: (_) => _controller.verificaEmail((_) => setState(_)),
      checking: _controller.isCheckingEmail,
      hasAutoValidate: true,
      validator: (_) => _controller.mensagemValidacaoEmail,
    );
  }

  Widget _senhaLogin() {
    return AppStyles.getInput(
      controller: _controller.senhaController,
      texto: 'Senha',
      context: context,
      view: {
        'onPressed' : () => _controller.vizualizarSenha((_) => setState(_)),
        'obscure' : _controller.senhaObscureText,
      },
      obscureText: _controller.senhaObscureText,
      hasAutoValidate: true,
      validator: (_) => _controller.mensagemValidacaoSenha,
    );
  }

  Widget _botaoEntrar() {
    return AppStyles.getElevatedButton(
      texto: 'Entrar',
      onPressed: () => _controller.logarUsuario(
        formKey: _formKey,
        context: context,
        setState: (_) => setState(_),
      ),
    );
  }
}
