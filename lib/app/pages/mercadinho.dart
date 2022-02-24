import 'dart:convert';

import 'package:buyk_app/app/services/obra_service.dart';
import 'package:buyk_app/app/services/usuario_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Mercadinho extends StatefulWidget {
  const Mercadinho({Key? key}) : super(key: key);

  @override
  _MercadinhoState createState() => _MercadinhoState();
}

class _MercadinhoState extends State<Mercadinho> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _obraService = ObraService.instance;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mercadinho'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.account_circle_rounded), onPressed: () => Navigator.of(context).pushNamed('/meuperfil')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        onPressed: () => Navigator.of(context).pushNamed('/adicionarobra'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => Future.delayed(const Duration(seconds: 2), () => setState(() {})),
        child: StreamBuilder(
          stream: _obraService.getAllStream(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              QuerySnapshot dados = snapshot.data as QuerySnapshot;
              Map obras = {};
              for(var obra in dados.docs) {
                obras[obra.id] = obra.data();
              }
              return NotificationListener<OverscrollIndicatorNotification>(
                onNotification: ((overscroll) {
                  overscroll.disallowIndicator();
                  return overscroll.leading;
                }),
                child: ListView(
                  children: [
                    _tituloRecentes(),
                    _livrosRecentes(obras),
                  ],
                ),
              );
            } else {
              return const Align(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _tituloRecentes() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: Text('Veja as novidades:', style: Theme.of(context).textTheme.headline3),
    );
  }

  Widget _livrosRecentes(Map dados) {
    List<Widget> obras = [];
    dados.forEach((id, info) {
      obras.add(
        GestureDetector(
          onTap: () => _verObra(id, info),
          child: Hero(
            tag: id,
            child: DecoratedBox(
              decoration: BoxDecoration(borderRadius: const BorderRadiusDirectional.all(Radius.circular(2)), color: info['capa_livro'] != null ? Colors.transparent : Theme.of(context).primaryColor),
              child: SizedBox(
                height: 800 * 0.25, width: 512 * 0.25,
                child: info['capa_livro'] == null ?
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
    return GridView.count(
      shrinkWrap: true,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      crossAxisCount: 3,
      padding: const EdgeInsets.only(right: 20, left: 20),
      childAspectRatio: (512 * 0.25) / (800 * 0.25),
      children: obras,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  // BACK-END
  Future _verObra(String id, Map info) async {
    Map autor = await _usuarioService.get(info['autor']) as Map;
    bool leitura = _usuario['biblioteca'].containsKey(id);
    info.addEntries({'id': id, 'dados_autor': autor, 'leitura': leitura}.entries);
    Navigator.of(context).pushNamed('/verobra', arguments: info);
  }
}
