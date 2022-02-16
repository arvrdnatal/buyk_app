import 'package:buyk_app/app/app_styles.dart';
import 'package:buyk_app/app/pages/cadastro/cadastro_controller.dart';
import 'package:flutter/material.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _controller = CadastroController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Align(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _nomeCadastro() {
    return AppStyles.getInput(
      controller: _controller.nomeController,
      texto: 'Nome',
      context: context,
      isTheFirst: true,
    );
  }

  Widget _sobrenomeCadastro() {
    return AppStyles.getInput(
      controller: _controller.sobrenomeController,
      texto: 'Sobrenome',
      context: context,
    );
  }

  Widget _usernameCadastro() {
    return AppStyles.getInput(
      controller: _controller.usernameController,
      texto: 'Nome de Usuário',
      context: context,
      onChanged: (_) => _controller.verificaUsername((_) => setState(_)),
      checking: _controller.isCheckingUsername,
      hasAutoValidate: true,
      validator: (_) => _controller.mensagemValidacaoUsername,
    );
  }

  Widget _emailCadastro() {
    return AppStyles.getInput(
      controller: _controller.emailController,
      texto: 'E-mail',
      context: context,
      onChanged: (_) => _controller.verificaEmail((_) => setState(_)),
      validator: (_) => _controller.mensagemValidacaoEmail,
      hasAutoValidate: true,
      checking: _controller.isCheckingEmail,
    );
  }

  Widget _senhaCadastro() {
    return AppStyles.getInput(
      controller: _controller.senhaController,
      texto: 'Senha',
      context: context,
      hasAutoValidate: true,
      validator: (senha) => _controller.verificaSenha(senha!),
      isTheLast: true,
    );
  }

  Widget _botaoCadastrar() {
    return AppStyles.getElevatedButton(
      texto: 'Cadastrar',
      onPressed: () => _controller.registrarUsuario(
        formKey: _formKey,
        context: context,
        setState: (_) => setState(_),
      ),
    );
  }
}
