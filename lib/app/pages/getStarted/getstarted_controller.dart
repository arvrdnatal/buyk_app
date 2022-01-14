import 'package:buyk_app/app/pages/getStarted/components/pagina_getstarted_viewmodel.dart';
import 'package:flutter/material.dart';

class GetStartedController {
  late final PaginaGetStartedViewModel _paginaGetStartedViewModel;
  final PageController _pageController = PageController();
  late final List<Widget> _paginas;
  int currentPage = 0;

  GetStartedController() {
    _paginaGetStartedViewModel = PaginaGetStartedViewModel();
    _paginas = _paginaGetStartedViewModel.getPaginasGetStarted();
  }

  void navegarParaCadastro(BuildContext context) => Navigator.of(context).pushNamed('/cadastro');
  void navegarParaLogin(BuildContext context) => Navigator.of(context).pushNamed('/login');

  PageController get pageController => _pageController;
  List<Widget> get paginas => _paginas;
}