import 'dart:convert';
import 'dart:io';

import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AdicionarObraController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instanceFor(app: Firebase.app());
  final UsuarioService _usuarioService = UsuarioService.instance;
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _sinopseController = TextEditingController();
  final TextEditingController _pontosController = TextEditingController();
  final TextEditingController _arquivoController = TextEditingController(text: 'Nenhum'.toUpperCase());
  dynamic _setState;
  dynamic _usuario;
  dynamic _img;

  AdicionarObraController() {
    _setUsuario();
  }

  Future _setUsuario() async {
    _usuario = jsonDecode(jsonEncode((await _usuarioService.get(_firebaseAuth.currentUser!.uid))));
    _setState(() {});
  }

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
    FilePickerResult? picked = await FilePicker.platform.pickFiles(
      // type: FileType.custom,
      // allowedExtensions: ['epub'],
    );

    if(picked != null) {
      print(picked.files.first.name);
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