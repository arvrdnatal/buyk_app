import 'package:buyk_app/app/app_styles.dart';
import 'package:buyk_app/app/pages/editarPerfil/editarperfil_controller.dart';
import 'package:flutter/material.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({Key? key}) : super(key: key);

  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  final _controller = EditarPerfilController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _controller.setStateController = (_) => setState(_);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => _controller.sair(context),
        ),
      ),
      body: Align(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    nomeEditar(),
                    sobrenomeEditar(),
                    usernameEditar(),
                  ],
                ),
              ),
              botaoSalvarPerfil(),
            ],
          ),
        ),
      ),
    );
  }

  // build
  Widget nomeEditar() {
    return AppStyles.getInput(
      context: context,
      controller: _controller.nomeController,
      texto: 'Nome',
      isTheFirst: true,
      onChanged: (_) => _controller.mudarBotao(),
    );
  }

  Widget sobrenomeEditar() {
    return AppStyles.getInput(
      context: context,
      controller: _controller.sobrenomeController,
      texto: 'Sobrenome',
      onChanged: (_) => _controller.mudarBotao(),
    );
  }

  Widget usernameEditar() {
    return AppStyles.getInput(
      context: context,
      controller: _controller.usernameController,
      texto: 'Nome de Usuário',
      onChanged: (_) {
        _controller.mudarBotao();
        _controller.verificaUsername();
      },
      checking: _controller.isCheckingUsername,
      hasAutoValidate: true,
      validator: (_) => _controller.mensagemValidacaoUsername,
    );
  }

  Widget botaoSalvarPerfil() {
    // return Container();
    return Visibility(
      visible: _controller.isBotaoEnabled,
      child: AppStyles.getElevatedButton(
        texto: 'Salvar',
        onPressed: () => _controller.salvarAlteracoes(_formKey, context)
      ),
    );
  }
}
