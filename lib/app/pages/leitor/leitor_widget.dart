import 'package:buyk_app/app/pages/leitor/leitor_controller.dart';
import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';

class Leitor extends StatefulWidget {
  const Leitor({ Key? key }) : super(key: key);

  @override
  _LeitorState createState() => _LeitorState();
}

class _LeitorState extends State<Leitor> {
  final _controller = LeitorController();

  @override
  Widget build(BuildContext context) {
    EpubBook obra = ModalRoute.of(context)!.settings.arguments as EpubBook;
    _controller.obra = obra;
    return Scaffold(
      appBar: AppBar(),
      endDrawer: _drawer(obra),
      body: Text(obra.Content.toString()),
    );
  }

  Widget _drawer(EpubBook obra) {
    List<Widget> capitulos  = [
      ListTile(title: Text('Capítulos'.toUpperCase(), style: Theme.of(context).textTheme.headline2, textAlign: TextAlign.center))
    ];
    obra.Chapters?.forEach((capitulo) {
      capitulos.add(ListTile(title: Text(capitulo.Title.toString())));
    });
    return Drawer(
      child: ListView(
        children: capitulos,
      ),
    );
  }
}