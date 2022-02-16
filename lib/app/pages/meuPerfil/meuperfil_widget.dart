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
      body: FutureBuilder(
        future: _controller.getDados(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            Map dados = snapshot.data as Map;
            return Column(
              children: [
                _perfil(dados),
                _tituloBiblioteca(),
                _biblioteca(),
              ],
            );
          } else {
            return const Align(child: CircularProgressIndicator());
          }
        }
      )
    );
  }

  // build
  Widget _perfil(Map dados) {
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
                  _nomeCompletoPerfil(dados['nome'], dados['sobrenome']),
                  _usernamePerfil(dados['username']),
                  _pontosPerfil(),
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
      child: Text('Minha Biblioteca'.toUpperCase(), style: Theme.of(context).textTheme.headline2),
    );
  }

  Widget _biblioteca() {
    return Expanded(
      child: GridView.count(
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        crossAxisCount: 3,
        padding: const EdgeInsets.only(right: 20, left: 20),
        childAspectRatio: (512 * 0.25) / (800 * 0.25),
        children: const [
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.amber),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.blue),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.deepOrange),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.teal),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.pink),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.lightGreen),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.redAccent),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.orange),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.indigo),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.red),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.deepPurple),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
        ],
      ),
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
    return Text(nomeCompleto, style: Theme.of(context).textTheme.headline3);
  }

  Widget _usernamePerfil(String username) => Text('@$username');
  Widget _pontosPerfil() => const Text('X pontos');
}
