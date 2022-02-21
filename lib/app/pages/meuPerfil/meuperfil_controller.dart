import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:buyk_app/app/app_styles.dart';
import 'package:buyk_app/app/services/obra_service.dart';
import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MeuPerfilController {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instanceFor(app: Firebase.app());
  final _usuarioService = UsuarioService.instance;
  final _obraService = ObraService.instance;
  final _memoizer = AsyncMemoizer();
  dynamic _setState;
  dynamic _usuario;
  dynamic _biblioteca;

  MeuPerfilController() {
    _setUsuario();
  }

  Future _setUsuario() async {
    _usuario = jsonDecode(jsonEncode((await _usuarioService.get(_firebaseAuth.currentUser!.uid))));
    _setState(() {});
  }
  
  Future getDados() async {
    await _setUsuario().then((_) => _carregarBiblioteca());
    return {
      'usuario': _usuario,
      'biblioteca': _biblioteca,
    };
  }

  Future cliqueImagem(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 120,
          child: Column(
            children: [
              ListTile(
                title: const Text('Escolha uma foto da galeria'),
                onTap: () => _editarImagem(context).then((_) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  _setState(() {});
                }),
              ),
              ListTile(
                title: const Text('Remover foto'),
                onTap: () => _removerImagem().then((_) {
                  Navigator.of(context).pop();
                  _setState(() {});
                }),
              ),
            ],
          ),
        );
      }
    );
  }

  Future _editarImagem(BuildContext context) async {
    XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) {
      File? cropedImg = await ImageCropper.cropImage(
        sourcePath: img.path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Capa',
          toolbarColor: Theme.of(context).primaryColor,
          activeControlsWidgetColor: Theme.of(context).focusColor,
        ),
      );
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(title: Text('Aguarde...'), content: LinearProgressIndicator()),
      );
      if (cropedImg != null) {
        if (_usuario != null) {
          String nomeImg = _usuario['username'] + '-pp';
          Reference reference = _firebaseStorage.ref().child('profile-pictures/$nomeImg');
          TaskSnapshot taskSnapshot;
          if (_usuario['imagem'] != null) {
            taskSnapshot = await reference.putFile(cropedImg);
          } else {
            reference.delete();
            Reference newReference = _firebaseStorage.ref().child('profile-pictures/$nomeImg');
            taskSnapshot = await newReference.putFile(cropedImg);
          }
          String url = await taskSnapshot.ref.getDownloadURL();
          if (url.isNotEmpty) {
            _usuario['imagem'] = url;
            _usuarioService.update(_firebaseAuth.currentUser!.uid, {'imagem': url});
          }
        }
      }
    }
  }

  Future _removerImagem() async {
    String nomeImg = _usuario['username'] + '-pp';
    _firebaseStorage.ref().child('profile-pictures/$nomeImg').delete();
    _usuario['imagem'] = '';
    _usuarioService.update(_firebaseAuth.currentUser!.uid, {'imagem': ''});
  }

  Future _carregarBiblioteca() async {
    Map<String, dynamic> biblioteca = {};
    for(var id in _usuario['biblioteca']) {
      Map obra = await _obraService.get(id);
      biblioteca[id] = obra;
    }
    _setState(() => _biblioteca = biblioteca);
  }

  Future verObra(BuildContext context, String id, Map info) async {
    Map autor = await _usuarioService.get(info['autor']) as Map;
    bool leitura = _usuario['biblioteca'].contains(id);
    info.addEntries({'id': id, 'dados_autor': autor, 'leitura': leitura}.entries);
    Navigator.of(context).pushNamed('/verobra', arguments: info);
  }

  void editarPerfil(BuildContext context) => Navigator.of(context).pushNamed('/editarperfil');
  void logoutUsuario(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sair'),
          content: const Text('Tem certeza que deseja sair?'),
          actionsPadding: const EdgeInsets.only(right: 20),
          actions: [
            AppStyles.getTextButton(
              texto: 'Sim',
              onPressed: () => _firebaseAuth.signOut().then((_) => Navigator.of(context).pushNamed('/')),
            ),
            AppStyles.getTextButton(
              texto: 'Cancelar',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void adicionarObra(BuildContext context) => Navigator.of(context).pushNamed('/adicionarobra');

  AsyncMemoizer get memoizer => _memoizer;
  set setSetState(dynamic function) => _setState = function;
}
