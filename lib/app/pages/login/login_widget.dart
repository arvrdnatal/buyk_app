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
  void initState() {
    Future.delayed(Duration.zero, () => _controller.setStateController = (_) => setState(_));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              title: Text('Login', style: Theme.of(context).textTheme.headline2),
              automaticallyImplyLeading: false,
            ),
          ],
        ),
      ),
      // extendBodyBehindAppBar: true,
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
              _botaoCadastro(),
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
      onChanged: (_) => _controller.verificaEmail(),
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
        'onPressed' : () => _controller.vizualizarSenha(),
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
      onPressed: () => _controller.logarUsuario(_formKey, context),
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
          AppStyles.getTextButton(texto: 'Cadastre-se', onPressed: () {}),
        ],
      ),
    );
  }
}
