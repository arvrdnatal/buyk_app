import 'package:flutter/material.dart';

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
        _getIcon(context),
        _getText(context),
      ],
    );
  }

  Widget _getIcon(BuildContext context) {
    return icone == null ? Container() :
    Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Icon(
        icone!,
        color: Theme.of(context).primaryColor,
        size: 100,
      ),
    );
  }

  Widget _getText(BuildContext context) {
    return texto == null ? Container() :
    Text(
      texto!,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline2,
    );
  }
}
