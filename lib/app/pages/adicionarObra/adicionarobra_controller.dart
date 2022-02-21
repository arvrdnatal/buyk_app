import 'dart:io';

import 'package:buyk_app/app/services/obra_service.dart';
import 'package:epub_viewer/epub_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AdicionarObraController {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instanceFor(app: Firebase.app());
  final _obraService = ObraService.instance;
  final _tituloController = TextEditingController();
  final _sinopseController = TextEditingController();
  final _pontosController = TextEditingController();
  final _arquivoController = TextEditingController(text: 'Nenhum'.toUpperCase());
  dynamic _arquivo;
  dynamic _setState;
  dynamic _img;

  AdicionarObraController();

  Future editarImagem(BuildContext context) async {
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
        _setState(() => _img = cropedImg);
      }
    }
  }

  String? verificaTitulo() {
    String? titulo = _tituloController.text;
    if(titulo.isEmpty) return 'O título não pode ficar em branco';
    return null;
  }

  String? verificaSinopse() {
    String? sinopse = _sinopseController.text;
    if(sinopse.isEmpty) return 'A sinopse não pode ficar em branco';
    return null;
  }

  String? verificaPreco() {
    String? pontos = _pontosController.text;
    if(pontos.isEmpty) return 'O preço não pode ficar em branco';
    if(pontos.contains(',') || pontos.contains('.')) return 'O preço não deve possuir [,] ou [.]';
    int? intPontos = int.parse(pontos);
    if(intPontos < 100) return 'O preço é muito baixo';
    if(intPontos > 5000) return 'O preço é muito alto';
    return null;
  }

  Future adicionarArquivo() async {
    FilePickerResult? picked = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['epub']);
    if(picked != null) {
      _arquivoController.text = picked.files.first.name;
      // EpubViewer.open(picked.files.first.path!);
      _arquivo = File(picked.files.first.path!);
      _setState(() {});
    }
  }

  String? verificaArquivo() {
    if(_arquivoController.text == 'NENHUM') return 'Um arquivo deve ser selecionado';
    return null;
  }

  Future enviarObra(GlobalKey<FormState> formKey, BuildContext context) async {
    if(formKey.currentState!.validate()) {
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
      }.entries);
      _obraService.add(infosObra).then((_) => Navigator.of(context).pushNamed('/mercadinho')).catchError((error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()))));
    }
  }

  void info(BuildContext context) => Navigator.of(context).pushNamed('/infonovaobra');

  get tituloController => _tituloController;
  get sinopseController => _sinopseController;
  get pontosController => _pontosController;
  get arquivoController => _arquivoController;
  get img => _img;
  set setSetState(dynamic function) => _setState = function;
}