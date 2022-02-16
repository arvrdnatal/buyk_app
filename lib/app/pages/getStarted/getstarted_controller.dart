import 'package:buyk_app/app/pages/getStarted/components/pagina_getstarted_widget.dart';
import 'package:flutter/material.dart';

class GetStartedController {
  final PageController _pageController = PageController();
  late final List<Widget> _paginas;
  int currentPage = 0;

  GetStartedController() {
    _setPaginas();
  }

  void cadastro(BuildContext context) => Navigator.of(context).pushNamed('/cadastro');
  void login(BuildContext context) => Navigator.of(context).pushNamed('/login');

  void _setPaginas() {
    _paginas = [
      const PaginaGetStarted(icone: Icons.insert_emoticon, texto: 'Diga olá para a BUYK!'),
      const PaginaGetStarted(icone: Icons.auto_stories, texto: 'Leia e publique livros do jeitinho que você quiser'),
      const PaginaGetStarted(icone: Icons.celebration, texto: 'Ganhe pontos por capítulo lido'),
      const PaginaGetStarted(icone: Icons.shopping_cart, texto: 'Use esses pontos para comprar outros livros'),
      const PaginaGetStarted(icone: Icons.attractions, texto: 'Divirta-se!'),
    ];
  }

  PageController get pageController => _pageController;
  List<Widget> get paginas => _paginas;
}