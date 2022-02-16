import 'package:flutter/material.dart';

class InfoNovaObra extends StatelessWidget {
  const InfoNovaObra({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Informações')),
      body: ListView(
        children: [
          _arquivos(context),
          const Divider(),
          _preco(context),
        ],
      ),
    );
  }

  // build
  Widget _arquivos(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text('Que arquivo devo utilizar?', style: Theme.of(context).textTheme.headline2),
          ),
          const Text('O arquivo recomendado para este aplicativo é o .epub, você pode criá-lo a partir de sua obra em .doc ou .docx com a aplicação desktop Calibre.'),
        ],
      ),
    );
  }

  Widget _preco(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text('Como funcionam os pontos?', style: Theme.of(context).textTheme.headline2),
          ),
          const Text('Os preços podem variar de acordo com o que você acha que deverá ser cobrado. Ele não é um valor decimal, ou seja, não possui o famoso 0,99, por isso são chamados de pontos. Também existe um mínimo de 100 pontos e máximo de 5000 pontos.'),
        ],
      ),
    );
  }
}