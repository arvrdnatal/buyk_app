import 'dart:io';

import 'package:buyk_app/app/app_styles.dart';
import 'package:buyk_app/app/services/obra_service.dart';
import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AdicionarObra extends StatefulWidget {
  const AdicionarObra({ Key? key }) : super(key: key);

  @override
  _AdicionarObraState createState() => _AdicionarObraState();
}

class _AdicionarObraState extends State<AdicionarObra> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instanceFor(app: Firebase.app());
  final _obraService = ObraService.instance;
  final _usuarioService = UsuarioService.instance;
  final _tituloController = TextEditingController();
  final _sinopseController = TextEditingController();
  final _pontosController = TextEditingController();
  final _arquivoController = TextEditingController(text: 'Nenhum'.toUpperCase());
  final _formKey = GlobalKey<FormState>();
  dynamic _arquivo;
  dynamic _img;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Obra'),
        actions: [
          IconButton(icon: const Icon(Icons.info), onPressed: () => Navigator.of(context).pushNamed('/infonovaobra')),
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
      onPressed: () => _enviarObra(),
      texto: 'Adicionar',
    );
  }

  Widget _capaAdicionar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () => _editarImagem(),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadiusDirectional.all(Radius.circular(2)),
            color: _img != null ? Colors.transparent : Theme.of(context).primaryColor,
          ),
          child: SizedBox(
            height: 800 * 0.25,
            width: 512 * 0.25,
            child: _img != null ?
            ClipRRect(child: Image.file(_img), borderRadius: const BorderRadius.all(Radius.circular(2)))
            : Icon(Icons.add_a_photo_rounded, color: Theme.of(context).scaffoldBackgroundColor),
          ),
        ),
      ),
    );
  }

  Widget _tituloObraAdicionar() {
    return AppStyles.getInput(
      controller: _tituloController,
      texto: 'Título da Obra',
      context: context,
      validator: (_) => _verificaTitulo(),
    );
  }

  Widget _sinopseAdicionar() {
    return AppStyles.getInput(
      controller: _sinopseController,
      texto: 'Sinopse',
      context: context,
      maxLength: 500,
      validator: (_) => _verificaSinopse(),
    );
  }

  Widget _precoAdicionar() {
    return AppStyles.getInput(
      controller: _pontosController,
      texto: 'Preço',
      context: context,
      numberFormat: true,
      validator: (_) => _verificaPreco(),
    );
  }

  Widget _enviarArquivo() {
    return Column(
      children: [
        AppStyles.getInput(
          context: context,
          controller: _arquivoController,
          texto: 'Arquivo',
          readOnly: true,
          validator: (_) => _verificaArquivo(),
        ),
        AppStyles.getTextButton(
          onPressed: () => _adicionarArquivo(),
          texto: 'Envie seu Arquivo',
          icone: Icons.file_upload_rounded,
        ),
      ],
    );
  }

  // BACK-END
  Future _editarImagem() async {
    XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) {
      File? cropedImg = await ImageCropper.cropImage(
        sourcePath: img.path,
        aspectRatio: const CropAspectRatio(ratioX: 512 * 0.25, ratioY: 800 * 0.25),
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Capa',
          toolbarColor: Theme.of(context).primaryColor,
          activeControlsWidgetColor: Theme.of(context).focusColor,
        ),
      );
      if (cropedImg != null) {
        setState(() => _img = cropedImg);
      }
    }
  }

  String? _verificaTitulo() {
    String? titulo = _tituloController.text;
    if(titulo.isEmpty) return 'O título não pode ficar em branco';
    return null;
  }

  String? _verificaSinopse() {
    String? sinopse = _sinopseController.text;
    if(sinopse.isEmpty) return 'A sinopse não pode ficar em branco';
    return null;
  }

  String? _verificaPreco() {
    String? pontos = _pontosController.text;
    if(pontos.isEmpty) return 'O preço não pode ficar em branco';
    if(pontos.contains(',') || pontos.contains('.')) return 'O preço não deve possuir [,] ou [.]';
    int? intPontos = int.parse(pontos);
    if(intPontos < 100) return 'O preço é muito baixo';
    if(intPontos > 5000) return 'O preço é muito alto';
    return null;
  }

  String? _verificaArquivo() {
    if(_arquivoController.text == 'NENHUM') return 'Um arquivo deve ser selecionado';
    return null;
  }

  Future _adicionarArquivo() async {
    FilePickerResult? picked = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['epub']);
    if(picked != null) {
      _arquivoController.text = picked.files.first.name;
      _arquivo = File(picked.files.first.path!);
      setState(() {});
    }
  }

  Future _enviarObra() async {
    if(_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(title: Text('Aguarde...'), content: LinearProgressIndicator()),
      );
      String nomeGeral = _tituloController.text.replaceAll(' ', '_');
      Map<String, dynamic> infosObra = {};
      if (_img != null) {
        String nomeImg = 'bc-' + _tituloController.text.replaceAll(' ', '_');
        Reference reference = _firebaseStorage.ref().child('books/$nomeGeral/$nomeImg');
        TaskSnapshot taskSnapshot = await reference.putFile(_img);
        infosObra['capa_livro'] = await taskSnapshot.ref.getDownloadURL();
      }
      String nomeArq = 'epub-' + _tituloController.text.replaceAll(' ', '_');
      Reference reference = _firebaseStorage.ref().child('books/$nomeGeral/$nomeArq');
      TaskSnapshot taskSnapshot = await reference.putFile(_arquivo);
      infosObra['arquivo'] = await taskSnapshot.ref.getDownloadURL();
      infosObra.addEntries({
        'titulo': _tituloController.text,
        'sinopse': _sinopseController.text,
        'preco': int.parse(_pontosController.text),
        'autor': _firebaseAuth.currentUser!.uid,
        'publicacao': DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
      }.entries);
      _obraService.add(infosObra).then((obra) async {
        Map<String, dynamic> livro = (await _obraService.get(obra.id)) as Map<String, dynamic>;
        livro['id'] = obra.id;
        livro['data_compra'] = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
        Map<String, dynamic> updateBiblioteca = {};
        updateBiblioteca[obra.id] = livro;
        Map<String,dynamic> update = {'biblioteca': updateBiblioteca};
        _usuarioService.update(_firebaseAuth.currentUser!.uid, update).then((_) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      });
    }
  }
}