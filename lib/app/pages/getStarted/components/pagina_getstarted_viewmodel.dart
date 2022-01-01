import 'package:buyk_app/app/pages/getStarted/pagina_getstarted_widget.dart';
import 'package:flutter/material.dart';

class PaginaGetStartedViewModel {
  final List<Widget> _paginas = [
    const PaginaGetStarted(
      icone: Icons.insert_emoticon,
      texto: 'Diga olá para a BUYK!',
    ),
    const PaginaGetStarted(
      icone: Icons.auto_stories,
      texto: 'Leia e publique livros do jeitinho que você quiser',
    ),
    const PaginaGetStarted(
      icone: Icons.celebration,
      texto: 'Ganhe pontos por capítulo lido',
    ),
    const PaginaGetStarted(
      icone: Icons.shopping_cart,
      texto: 'Use esses pontos para comprar outros livros',
    ),
    const PaginaGetStarted(
      icone: Icons.attractions,
      texto: 'Divirta-se!',
    ),
  ];

  PaginaGetStartedViewModel();

  List<Widget> getPaginasGetStarted() {
    return _paginas;
  }
}