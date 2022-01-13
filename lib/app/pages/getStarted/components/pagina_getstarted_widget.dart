import 'package:buyk_app/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaginaGetStarted extends StatelessWidget {
  final IconData? icone;
  final String? texto;

  const PaginaGetStarted({Key? key, this.icone, this.texto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getIcon(),
        getText(),
      ],
    );
  }

  Widget getIcon() {
    if(icone == null) return Container();
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
        top: 20,
      ),
      child: Icon(
        icone!,
        color: GlobalColors.deadGreen,
        size: 100,
      ),
    );
  }

  Widget getText() {
    if(texto == null) return Container();
    return Text(
      texto!,
      textAlign: TextAlign.center,
      style: GoogleFonts.raleway(
        color: GlobalColors.deadGreen,
        fontSize: 30,
      ),
    );
  }
}
