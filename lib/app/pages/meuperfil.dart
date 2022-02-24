import 'dart:convert';
import 'dart:io';

import 'package:buyk_app/app/app_styles.dart';
import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MeuPerfil extends StatefulWidget {
  const MeuPerfil({Key? key}) : super(key: key);

  @override
  _MeuPerfilState createState() => _MeuPerfilState();
}

class _MeuPerfilState extends State<MeuPerfil> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instanceFor(app: Firebase.app());
  final _usuarioService = UsuarioService.instance;
  dynamic _usuario;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      _usuario = jsonDecode(jsonEncode((await _usuarioService.get(_firebaseAuth.currentUser!.uid))));
      setState(() {});
    });
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () => Navigator.of(context).pushNamed('/editarperfil')),
          IconButton(icon: const Icon(Icons.exit_to_app), onPressed: () => _logoutUsuario()),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        onPressed: () => Navigator.of(context).pushNamed('/adicionarobra'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => Future.delayed(const Duration(seconds: 2), () => setState(() {})),
        child: FutureBuilder(
          future: _usuarioService.get(_firebaseAuth.currentUser!.uid),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              Map<String,dynamic> dados = snapshot.data as Map<String,dynamic>;
              return NotificationListener<OverscrollIndicatorNotification>(
                onNotification: ((overscroll) {
                  overscroll.disallowIndicator();
                  return overscroll.leading;
                }),
                child: ListView(
                  children: [
                    _perfil(dados),
                    _tituloBiblioteca(),
                    _bibliotecaWidget(dados['biblioteca']),
                  ],
                ),
              );
            } else {
              return const Align(child: CircularProgressIndicator());
            }
          }
        ),
      )
    );
  }

  Widget _perfil(Map dados) {
    Widget espacador = const SizedBox(height: 5);
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _fotoPerfil(dados['imagem']),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _nomeCompletoPerfil(dados['nome'], dados['sobrenome']), espacador,
                  _usernamePerfil(dados['username']), espacador,
                  _pontosPerfil(dados['pontos']),
                ],
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _tituloBiblioteca() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Align(child: Text('Minha Biblioteca'.toUpperCase(), style: Theme.of(context).textTheme.headline2)),
    );
  }

  Widget _bibliotecaWidget(Map dados) {
    List<Widget> obras = [];
    dados.forEach((id, info) {
      obras.add(
        GestureDetector(
          onTap: () => _verObra(id, info),
          child: Hero(
            tag: id,
            child: DecoratedBox(
              decoration: BoxDecoration(borderRadius: const BorderRadiusDirectional.all(Radius.circular(2)), color: info['capa_livro'].isNotEmpty ? Colors.transparent : Theme.of(context).primaryColor),
              child: SizedBox(
                height: 800 * 0.25, width: 512 * 0.25,
                child: info['capa_livro'].isEmpty ?
                Icon(Icons.image_not_supported, color: Theme.of(context).scaffoldBackgroundColor) :
                CachedNetworkImage(
                  imageUrl: info['capa_livro'],
                  placeholder: (context, url) => const Align(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ),
        ),
      );
    });
    return dados.isEmpty ?
    Align(child: Text('Nenhum resultado encontrado ainda!', style: Theme.of(context).textTheme.caption?.copyWith(color: Theme.of(context).hintColor))) :
    GridView.count(
      shrinkWrap: true,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      crossAxisCount: 3,
      padding: const EdgeInsets.only(right: 20, left: 20),
      childAspectRatio: (512 * 0.25) / (800 * 0.25),
      children: obras,
    );
  }

  Widget _fotoPerfil(String? img) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: () => _cliqueImagem(),
        child: CircleAvatar(
          minRadius: 50, maxRadius: 50,
          backgroundColor: img!.isNotEmpty ? Colors.transparent : Theme.of(context).primaryColor,
          child: img.isNotEmpty ?
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: img,
              placeholder: (context, url) => const CircularProgressIndicator(),
            ),
          )
          : Icon(Icons.person_rounded, size: 100, color: Theme.of(context).scaffoldBackgroundColor),
        ),
      ),
    );
  }

  Widget _nomeCompletoPerfil(String? nome, String? sobrenome) {
    String? nomeCompleto = ((nome!.isNotEmpty) ? nome : '') + ((nome.isNotEmpty && sobrenome!.isNotEmpty) ? ' ' : '') + ((sobrenome!.isNotEmpty) ? sobrenome : '');
    return Text(nomeCompleto, style: Theme.of(context).textTheme.headline3!.copyWith(fontWeight: FontWeight.bold));
  }

  Widget _usernamePerfil(String username) => Text('@$username');
  Widget _pontosPerfil(int pontos) => Text('$pontos pontos');

  // BACK-END
  void _logoutUsuario() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair?'),
        actionsPadding: const EdgeInsets.only(right: 20),
        actions: [
          AppStyles.getTextButton(texto: 'Sim', onPressed: () => _firebaseAuth.signOut().then((_) => Navigator.of(context).pushNamed('/'))),
          AppStyles.getTextButton(texto: 'Cancelar', onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  Future _verObra(String id, Map info) async {
    Map autor = await _usuarioService.get(info['autor']) as Map;
    bool leitura = _usuario['biblioteca'].containsKey(id);
    info.addEntries({'id': id, 'dados_autor': autor, 'leitura': leitura}.entries);
    Navigator.of(context).pushNamed('/verobra', arguments: info);
  }

  Future _cliqueImagem() async {
    return showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 120,
        child: Column(
          children: [
            ListTile(title: const Text('Escolha uma foto da galeria'), onTap: () => _editarImagem()),
            ListTile(title: const Text('Remover foto'), onTap: () => _removerImagem()),
          ],
        ),
      ),
    );
  }

  Future _editarImagem() async {
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
            _usuarioService.update(_firebaseAuth.currentUser!.uid, {'imagem': url}).then((_) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              setState(() {});
            });
            
          }
        }
      }
    }
  }

  Future _removerImagem() async {
    String nomeImg = _usuario['username'] + '-pp';
    _firebaseStorage.ref().child('profile-pictures/$nomeImg').delete();
    _usuario['imagem'] = '';
    _usuarioService.update(_firebaseAuth.currentUser!.uid, {'imagem': ''}).then((_) {
      Navigator.of(context).pop();
      setState(() {});
    });
  }
}
