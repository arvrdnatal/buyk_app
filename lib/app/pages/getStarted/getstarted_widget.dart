import 'package:buyk_app/app/app_styles.dart';
import 'package:buyk_app/app/pages/getStarted/getstarted_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  final _controller = GetStartedController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          _paginasGetStarted(),
          _indicadorPaginasGetStarted(),
          _rodapeGetStarted(),
        ],
      ),
    );
  }

 // build
  Widget _paginasGetStarted() {
    return Expanded(
      flex: 8,
      child: Align(
        alignment: Alignment.center,
        child: PageView(
          scrollDirection: Axis.horizontal,
          controller: _controller.pageController,
          children: _controller.paginas,
          onPageChanged: (index) => setState(() => _controller.currentPage = index),
        ),
      ),
    );
  }

  Widget _indicadorPaginasGetStarted() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppStyles.getIndicadorPaginacao(
          context: context,
          paginas: _controller.paginas,
          currentPage: _controller.currentPage
        )
      ]
    );
  }

  Widget _rodapeGetStarted() {
    return Expanded(
      flex: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _botoesDePaginacao(),
          _fraseDeLogin(),
        ],
      ),
    );
  }

  // rodapePaginacao
  Widget _botoesDePaginacao() {
    if(_controller.currentPage == (_controller.paginas.length - 1)) {
      return AppStyles.getElevatedButton(
        texto: 'Comece Já',
        padding: const EdgeInsets.all(0),
        onPressed: () => _controller.cadastro(context),
      );
    } else {
      return AppStyles.getOutlinedButton(
        context: context,
        icone: Icons.navigate_next_rounded,
        tamanho: 50,
        radius: true,
        padding: const EdgeInsets.all(0),
        onPressed: () => _controller.pageController.nextPage(duration: const Duration(milliseconds: 800), curve: Curves.easeInOutQuint),
      );
    }
  }

  Widget _fraseDeLogin() {
    return _controller.currentPage == (_controller.paginas.length - 1) ?
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Já possui conta?'),
          AppStyles.getTextButton(texto: 'Login', onPressed: () => _controller.login(context)),
        ],
      ) : Container();
  }
}
