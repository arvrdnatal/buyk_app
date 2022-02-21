import 'dart:convert';
import 'dart:io';

import 'package:buyk_app/app/app_styles.dart';
import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:epub_viewer/epub_viewer.dart';
import 'package:epubx/epubx.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class VerObraController {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instanceFor(app: Firebase.app());
  final _usuarioService = UsuarioService.instance;

  VerObraController();

  Future comprarObra(BuildContext context, Map info) async {
    if(info['autor'] == _firebaseAuth.currentUser!.uid) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Atenção'),
            content: const Text('Esta obra foi publicada por você!'),
            actions: [
              AppStyles.getTextButton(
                texto: 'Ok',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(title: Text('Aguarde...'), content: LinearProgressIndicator()),
      );
      Map usuario = _usuarioService.get(_firebaseAuth.currentUser!.uid) as Map;
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
          Map<String,dynamic> update = {
            'pontos': usuario['pontos'] - info['preco'],
            'biblioteca': [info['id']],
          };
          _usuarioService.update(_firebaseAuth.currentUser!.uid, update).then((_) {
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
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          });
        }
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
    List<int> bytes = await file.readAsBytes();
    EpubBook epubBook = await EpubReader.readBook(bytes);
    Navigator.of(context).pushNamed('/leitor', arguments: epubBook);
  }
}