import 'package:buyk_app/app/app_colors.dart';
import 'package:buyk_app/app/pages/inicio/inicio_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Inicio extends StatefulWidget {
  final Map paginas;
  const Inicio({Key? key, required this.paginas}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final InicioController _inicioController = InicioController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          backgroundColor: GlobalColors.deadGreen,
          padding: const EdgeInsets.all(20),
        ),
        onPressed: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.edit,
              color: GlobalColors.black,
            ),
            Text(
              'Adicionar',
              style: GoogleFonts.raleway(
                color: GlobalColors.black,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Mercadinho'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Buscar'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories_outlined),
            label: 'Biblioteca'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Meu Perfil'
          ),
        ],
        selectedItemColor: GlobalColors.lightGreen,
        unselectedItemColor: GlobalColors.deadGreen,
        currentIndex: _inicioController.pageSelected,
        onTap: (int index) {
          setState(() { _inicioController.pageSelected = index; });
          _inicioController.pageController.jumpToPage(index);
        },
        type: BottomNavigationBarType.fixed,
      ),
      body: PageView(
        controller: _inicioController.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          widget.paginas['mercadinho'],
          widget.paginas['busca'],
          widget.paginas['biblioteca'],
          widget.paginas['meuperfil'],
        ],
      ),
    );
  }
}
