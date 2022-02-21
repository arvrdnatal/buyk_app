import 'package:buyk_app/app/app_styles.dart';
import 'package:buyk_app/app/pages/verObra/verobra_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VerObra extends StatefulWidget {
  const VerObra({ Key? key }) : super(key: key);

  @override
  _VerObraState createState() => _VerObraState();
}

class _VerObraState extends State<VerObra> {
  final _controller = VerObraController();

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

  // build
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
    setState(() {});
    return AppStyles.getElevatedButton(
      texto: info['leitura'] ? 'Ler' : 'Comprar',
      onPressed: () => info['leitura'] ?
      _controller.lerObra(context, info) :
      _controller.comprarObra(context, info),
    );
  }
}