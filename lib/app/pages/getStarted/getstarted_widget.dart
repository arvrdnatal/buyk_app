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
  int currentPage = 0;
  final PageController pageController = PageController();
  final GetStartedController getStartedController = GetStartedController();
  late List<Widget> paginas;

  @override
  Widget build(BuildContext context) {
    paginas = getStartedController.getPaginasGetStarted();
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
            controller: pageController,
            itemCount: paginas.length,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (int index) { setState(() { currentPage = index; }); },
            itemBuilder: (BuildContext context, int index) { return paginas[index]; },
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
          children: List<Widget>.generate(paginas.length, (int index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 10,
              width: (index == currentPage) ? 15 : 10,
              margin: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: (index == currentPage) ? GlobalColors.deadGreen : GlobalColors.deadGreen.withOpacity(0.5),
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
    if(currentPage == (paginas.length - 1)) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: TextButton(
          onPressed: () => {
            Navigator.of(context).pushNamed('/cadastro')
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
          pageController.nextPage(
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
    if(currentPage == (paginas.length - 1)) {
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
          TextButton(
            onPressed: () => {},
            child: Text(
              'Login',
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
