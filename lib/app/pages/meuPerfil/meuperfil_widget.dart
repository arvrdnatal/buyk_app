import 'package:buyk_app/app/pages/meuPerfil/meuperfil_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MeuPerfil extends StatefulWidget {
  const MeuPerfil({Key? key}) : super(key: key);

  @override
  _MeuPerfilState createState() => _MeuPerfilState();
}

class _MeuPerfilState extends State<MeuPerfil> {
  final _controller = MeuPerfilController();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    _controller.setSetState = (_) => setState(_);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () => _controller.editarPerfil(context)),
          IconButton(icon: const Icon(Icons.exit_to_app), onPressed: () => _controller.logoutUsuario(context)),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        onPressed: () => _controller.adicionarObra(context),
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: FutureBuilder(
          future: _controller.memoizer.runOnce(() => _controller.getDados()),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              Map dados = snapshot.data as Map;
              return NotificationListener<OverscrollIndicatorNotification>(
                onNotification: ((overscroll) {
                  overscroll.disallowIndicator();
                  return overscroll.leading;
                }),
                child: ListView(
                  children: [
                    _perfil(dados['usuario']),
                    _tituloBiblioteca(),
                    _biblioteca(dados['biblioteca']),
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

  // build
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

  Widget _biblioteca(Map dados) {
    List<Widget> obras = [];
    dados.forEach((id, info) {
      obras.add(
        GestureDetector(
          onTap: () => _controller.verObra(context, id, info),
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

  // perfil
  Widget _fotoPerfil(String? img) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: () => _controller.cliqueImagem(context),
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
}
