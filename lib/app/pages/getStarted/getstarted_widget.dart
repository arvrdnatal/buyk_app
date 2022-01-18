import 'package:buyk_app/app/app_colors.dart';
import 'package:buyk_app/app/pages/getStarted/getstarted_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  final GetStartedController _getStartedController = GetStartedController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            paginasBuilder(),
            indicadorDePaginas(),
            rodapePaginacao(),
          ],
        ),
      ),
    );
  }

  Widget paginasBuilder() {
    return Expanded(
      flex: 8,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.center,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: _getStartedController.pageController,
            itemCount: _getStartedController.paginas.length,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (int index) { setState(() { _getStartedController.currentPage = index; }); },
            itemBuilder: (BuildContext context, int index) { return _getStartedController.paginas[index]; },
          ),
        ),
      ),
    );
  }

  Widget indicadorDePaginas() {
    return Expanded(
      flex: 1,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(_getStartedController.paginas.length, (int index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 10,
              width: (index == _getStartedController.currentPage) ? 15 : 10,
              margin: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: (index == _getStartedController.currentPage) ? GlobalColors.deadGreen : GlobalColors.deadGreen.withOpacity(0.5),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget rodapePaginacao() {
    return SizedBox(
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: botoesDePaginacao(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: fraseDeLogin(),
          ),
        ],
      ),
    );
  }

  Widget botoesDePaginacao() {
    if(_getStartedController.currentPage == (_getStartedController.paginas.length - 1)) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: TextButton(
          onPressed: () {
            _getStartedController.navegarParaCadastro(context);
          },
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: GlobalColors.deadGreen,
            padding: const EdgeInsets.all(18),
          ),
          child: Text(
            'Comece já',
            style: GoogleFonts.raleway(
              color: GlobalColors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return IconButton(
        onPressed: () => {
          _getStartedController.pageController.nextPage(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutQuint,
          )
        },
        icon: const Icon(Icons.navigate_next_rounded),
        color: GlobalColors.deadGreen,
        iconSize: 50,
      );
    }
  }

  Widget fraseDeLogin() {
    if(_getStartedController.currentPage == (_getStartedController.paginas.length - 1)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Já possui conta?',
            style: GoogleFonts.raleway(
              color: GlobalColors.deadGreen,
              fontSize: 15,
            ),
          ),
          InkWell(
            onTap: () {
              _getStartedController.navegarParaLogin(context);
            },
            child: Text(
              ' Login',
              style: GoogleFonts.raleway(
                color: GlobalColors.lightGreen,
                fontSize: 15,
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
