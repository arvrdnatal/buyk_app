import 'dart:io';
import 'dart:typed_data';

import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';

class Leitor extends StatefulWidget {
  const Leitor({ Key? key }) : super(key: key);

  @override
  _LeitorState createState() => _LeitorState();
}

class _LeitorState extends State<Leitor> {
  EpubController? _epubController;

  Future<Uint8List> _carregarBytes(Map info) async {
    File file = info['arquivo_file'] as File;
    return await file.readAsBytes();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Map<String, dynamic> obra = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _epubController = EpubController(
        document: EpubReader.readBook(_carregarBytes(obra)),
        epubCfi: 'epubcfi(/6/6[chapter-2]!/4/2/1612)',
      );
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: EpubActualChapter(
            controller: _epubController!,
            builder: (chapterValue) => Text(
              chapterValue?.chapter?.Title ?? '',
              textAlign: TextAlign.center,
            ),
          ),
          leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }),
        ),
        body: EpubView(
          controller: _epubController!,
        ),
      ),
    );
  }
}