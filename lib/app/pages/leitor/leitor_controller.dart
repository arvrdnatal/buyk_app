import 'dart:io';
import 'dart:typed_data';

import 'package:epub_view/epub_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class LeitorController {
  final _firebaseStorage = FirebaseStorage.instanceFor(app: Firebase.app());
  late final EpubController _epubController;
  late List<int> _obra;
  dynamic _setState;

  LeitorController() {
    _epubController = EpubController(document: EpubReader.readBook(_obra));
    _setState(() {});
  }

  Future<EpubBook> setController(Map info) async {
    // Future<Uint8List> _loadFromAssets(String assetName) async {
    //   final bytes = await rootBundle.load(assetName);
    //   return bytes.buffer.asUint8List();
    // }
    Directory tempDir = Directory.systemTemp;
    String nome = _firebaseStorage.refFromURL(info['arquivo']).name;
    var file = File('${tempDir.path}/$nome');
    await _firebaseStorage.refFromURL(info['arquivo']).writeToFile(file);
    Uint8List bytes = file.readAsBytesSync();
    
    return EpubReader.readBook(bytes);
  }

  get epubController => _epubController;
  set obra(List<int> obra) => _obra = obra;
  set setSetState(dynamic function) => _setState = function;
}