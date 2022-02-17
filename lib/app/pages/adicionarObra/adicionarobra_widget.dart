import 'package:buyk_app/app/app_styles.dart';
import 'package:buyk_app/app/pages/adicionarObra/adicionarobra_controller.dart';
import 'package:flutter/material.dart';

class AdicionarObra extends StatefulWidget {
  const AdicionarObra({ Key? key }) : super(key: key);

  @override
  _AdicionarObraState createState() => _AdicionarObraState();
}

class _AdicionarObraState extends State<AdicionarObra> {
  final _controller = AdicionarObraController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _controller.setSetState = (_) => setState(_);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Obra'),
        actions: [
          IconButton(icon: const Icon(Icons.info), onPressed: () => _controller.info(context))
        ],
      ),
      body: Align(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _formEnvia(),
              _botaoAdicionar(),
            ],
          ),
        ),
      ),
    );
  }

  // build
  Widget _formEnvia() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _capaAdicionar(),
          _tituloObraAdicionar(),
          _sinopseAdicionar(),
          _precoAdicionar(),
          _enviarArquivo(),
        ],
      ),
    );
  }

  Widget _botaoAdicionar() {
    return AppStyles.getElevatedButton(
      onPressed: () => _controller.enviarObra(_formKey, context),
      texto: 'Adicionar',
    );
  }

  // form
  Widget _capaAdicionar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () => _controller.editarImagem(context),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadiusDirectional.all(Radius.circular(2)),
            color: _controller.img != null ? Colors.transparent : Theme.of(context).primaryColor,
          ),
          child: SizedBox(
            height: 800 * 0.25,
            width: 512 * 0.25,
            child: _controller.img != null ?
            ClipRRect(child: Image.file(_controller.img), borderRadius: const BorderRadius.all(Radius.circular(2)))
            : Icon(Icons.add_a_photo_rounded, color: Theme.of(context).scaffoldBackgroundColor),
          ),
        ),
      ),
    );
  }

  Widget _tituloObraAdicionar() {
    return AppStyles.getInput(
      controller: _controller.tituloController,
      texto: 'Título da Obra',
      context: context,
      validator: (_) => _controller.verificaTitulo(),
    );
  }

  Widget _sinopseAdicionar() {
    return AppStyles.getInput(
      controller: _controller.sinopseController,
      texto: 'Sinopse',
      context: context,
      maxLength: 500,
      validator: (_) => _controller.verificaSinopse(),
    );
  }

  Widget _precoAdicionar() {
    return AppStyles.getInput(
      controller: _controller.pontosController,
      texto: 'Preço',
      context: context,
      numberFormat: true,
      validator: (_) => _controller.verificaPreco(),
    );
  }

  Widget _enviarArquivo() {
    return Column(
      children: [
        AppStyles.getInput(
          context: context,
          controller: _controller.arquivoController,
          texto: 'Arquivo',
          readOnly: true,
          validator: (_) => _controller.verificaArquivo(),
        ),
        AppStyles.getTextButton(
          onPressed: () => _controller.adicionarArquivo(),
          texto: 'Envie seu Arquivo',
          icone: Icons.file_upload_rounded,
        ),
      ],
    );
  }
}