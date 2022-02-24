import 'dart:io';

import 'package:buyk_app/app/app_styles.dart';
import 'package:buyk_app/app/services/obra_service.dart';
import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class VerObra extends StatefulWidget {
  const VerObra({ Key? key }) : super(key: key);

  @override
  _VerObraState createState() => _VerObraState();
}

class _VerObraState extends State<VerObra> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instanceFor(app: Firebase.app());
  final _usuarioService = UsuarioService.instance;
  final _obraService = ObraService.instance;

  @override
  Widget build(BuildContext context) {
    Map<String,dynamic> info = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    return Scaffold(
      appBar: AppBar(title: Text(info['titulo'])),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _capaObra(info['capa_livro'], info['id']),
            _tituloObra(info['titulo']),
            const Divider(),
            _infoObra(info),
            const Divider(),
            _comprarObra(info),
          ],
        ),
      ),
    );
  }

  Widget _capaObra(String? img, String id) {
    return Align(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Hero(
          tag: id,
          child: DecoratedBox(
            decoration: BoxDecoration(borderRadius: const BorderRadiusDirectional.all(Radius.circular(2)), color: img != null ? Colors.transparent : Theme.of(context).primaryColor),
            child: SizedBox(
              height: 800 * 0.25, width: 512 * 0.25,
              child: img == null ?
              Icon(Icons.image_not_supported, color: Theme.of(context).scaffoldBackgroundColor) :
              CachedNetworkImage(
                imageUrl: img,
                placeholder: (context, url) => const Align(child: CircularProgressIndicator()),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tituloObra(String titulo) => Align(child: Text(titulo, style: Theme.of(context).textTheme.headline2));

  Widget _infoObra(Map info) {
    Widget espacador = const SizedBox(height: 15);
    String autor = info['dados_autor']['username'];
    String sinopse = info['sinopse'];
    int preco = info['preco'];
    return Padding(
      padding: const EdgeInsets.only(right: 30, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Autor: $autor'), espacador,
          Text('Sinopse: $sinopse'), espacador,
          Text('Valor: $preco pontos'),
        ],
      ),
    );
  }

  Widget _comprarObra(Map info) {
    return AppStyles.getElevatedButton(
      texto: info['leitura'] ? 'Ler' : 'Comprar',
      onPressed: () => info['leitura'] ? _ler(info) : _comprar(info),
    );
  }

  // BACK-END
  Future _ler(Map info) async {
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
    Navigator.of(context).pushNamed('/leitor', arguments: info);
  }

  Future _comprar(Map info) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(title: Text('Aguarde...'), content: LinearProgressIndicator()),
    );
    Map<String,dynamic> usuario = await _usuarioService.get(_firebaseAuth.currentUser!.uid) as Map<String,dynamic>;
    Map bibliotecaPrivada = usuario['biblioteca'] as Map;
    if(!bibliotecaPrivada.containsKey(info['id'])) {
      if(usuario['pontos'] < info['preco']) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
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
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Atenção'),
            content: const Text('Tem certeza que deseja comprar esta obra?'),
            actions: [
              AppStyles.getTextButton(
                texto: 'Sim',
                onPressed: () async {
                  Map<String,dynamic> autor = await _usuarioService.get(info['autor']) as Map<String,dynamic>;
                  Map<String,dynamic> obra = await _obraService.get(info['id']) as Map<String,dynamic>;
                  Map<String, dynamic> updateBiblioteca = {};
                  updateBiblioteca[info['id']] = obra;
                  Map<String,dynamic> updateUser = {
                    'pontos': usuario['pontos'] - info['preco'],
                    'biblioteca': updateBiblioteca,
                  };
                  _usuarioService.update(_firebaseAuth.currentUser!.uid, updateUser).then((_) {
                    Map<String,dynamic> updateAutor = {'pontos': autor['pontos'] + info['preco']};
                    _usuarioService.update(info['autor'], updateAutor).then((_) {
                      String titulo = info['titulo'];
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Parabéns'),
                          content: Text('Você acaba de adquirir um novo livro ($titulo)!'),
                          actions: [
                            AppStyles.getTextButton(texto: 'Ok', onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/mercadinho', (route) => false)),
                          ],
                        ),
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
          ),
        );
      }
    }
  }
}