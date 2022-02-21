import 'package:buyk_app/app/pages/mercadinho/mercadinho_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Mercadinho extends StatefulWidget {
  const Mercadinho({Key? key}) : super(key: key);

  @override
  _MercadinhoState createState() => _MercadinhoState();
}

class _MercadinhoState extends State<Mercadinho> {
  final _controller = MercadinhoController();

  @override
  Widget build(BuildContext context) {
    _controller.setSetState = (_) => setState(_);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mercadinho'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.account_circle_rounded), onPressed: () => _controller.meuPerfil(context)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        onPressed: () => _controller.adicionarObra(context),
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: FutureBuilder(
          future: _controller.carregarObras(),
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
                    _tituloRecentes(),
                    _livrosRecentes(dados),
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
          onTap: () => _controller.verObra(context, id, info),
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
}
