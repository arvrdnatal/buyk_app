import 'package:buyk_app/app/pages/getStarted/components/pagina_getstarted_viewmodel.dart';
import 'package:flutter/material.dart';

class GetStartedController {
  final PaginaGetStartedViewModel _paginaGetStartedViewModel;

  GetStartedController() :
    _paginaGetStartedViewModel = PaginaGetStartedViewModel();

  List<Widget> getPaginasGetStarted() {
    return _paginaGetStartedViewModel.getPaginasGetStarted();
  }
}