import 'dart:io';

import 'package:buyk_app/app/app_styles.dart';
import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:epub_viewer/epub_viewer.dart';
import 'package:epubx/epubx.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:starlight_epub_viewer/starlight_epub_viewer.dart';

class VerObraController {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instanceFor(app: Firebase.app());
  final _usuarioService = UsuarioService.instance;
  dynamic _setState;

  VerObraController();

  Future comprarObra(BuildContext context, Map info) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(title: Text('Aguarde...'), content: LinearProgressIndicator()),
    );
    Map<String,dynamic> usuario = await _usuarioService.get(_firebaseAuth.currentUser!.uid) as Map<String,dynamic>;
    List bibliotecaPrivada = usuario['biblioteca'] as List;
    if(!bibliotecaPrivada.contains(info['id']))  {
      if(usuario['pontos'] < info['preco']) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Atenção'),
              content: const Text('Você não tem pontos suficientes para comprar a obra!'),
              actions: [
                AppStyles.getTextButton(
                  texto: 'Ok',
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Atenção'),
              content: const Text('Tem certeza que deseja comprar esta obra?'),
              actions: [
                AppStyles.getTextButton(
                  texto: 'Sim',
                  onPressed: () async {
                    Map<String,dynamic> autor = await _usuarioService.get(info['autor']) as Map<String,dynamic>;
                    Map<String,dynamic> updateUser = {
                      'pontos': usuario['pontos'] - info['preco'],
                      'biblioteca': [info['id']],
                    };
                    Map<String,dynamic> updateAutor = {'pontos': autor['pontos'] + info['preco']};
                    _usuarioService.update(_firebaseAuth.currentUser!.uid, updateUser).then((_) {
                      _usuarioService.update(info['autor'], updateAutor).then((_) {
                        String titulo = info['titulo'];
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Parabéns'),
                              content: Text('Você acaba de adquirir um novo livro ($titulo)!'),
                              actions: [
                                AppStyles.getTextButton(
                                  texto: 'Ok',
                                  onPressed: () {
                                    Navigator.of(context).pushNamedAndRemoveUntil('/mercadinho', (route) => false);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      });
                    });
                  },
                ),
                AppStyles.getTextButton(
                  texto: 'Não',
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future lerObra(BuildContext context, Map info) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(title: Text('Aguarde...'), content: LinearProgressIndicator()),
    );
    Directory tempDir = Directory.systemTemp;
    String nome = _firebaseStorage.refFromURL(info['arquivo']).name;
    var file = File('${tempDir.path}/$nome');
    await _firebaseStorage.refFromURL(info['arquivo']).writeToFile(file);
    info['arquivo_file'] = file;

    StarlightEpubViewer.setConfig(
      themeColor: Theme.of(context).primaryColor,
      nightMode: true,
      scrollDirection: StarlightEpubViewerScrollDirection.ALLDIRECTIONS,
      allowSharing: false,
      enableTts: false,
      setShowRemainingIndicator: true,
    );
    StarlightEpubViewer.open(file.path);
    // Navigator.of(context).pushNamed('/leitor', arguments: info);
  }

  set setSetState(dynamic function) => _setState = function;
}