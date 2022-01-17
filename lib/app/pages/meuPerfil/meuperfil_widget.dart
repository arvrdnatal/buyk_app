import 'package:buyk_app/app/app_colors.dart';
import 'package:buyk_app/app/pages/meuPerfil/meuperfil_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MeuPerfil extends StatefulWidget {
  const MeuPerfil({Key? key}) : super(key: key);

  @override
  _MeuPerfilState createState() => _MeuPerfilState();
}

class _MeuPerfilState extends State<MeuPerfil> {
  final MeuPerfilController _meuPerfilController = MeuPerfilController();

  @override
  Widget build(BuildContext context) {
    _meuPerfilController.setStateController = () => setState(() {});
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.center,
          child: FutureBuilder(
            future: _meuPerfilController.getDados(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                Map dados = snapshot.data as Map;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      tituloPerfil(),
                      botaoSairPerfil(),
                      fotoPerfil(dados['imagem']),
                      nomeCompletoPerfil(dados['nome'], dados['sobrenome']),
                      usernamePerfil(dados['username']),
                      botaoEditarPerfil(),
                    ],
                  ),
                );
              } else {
                return const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF63911d)),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget tituloPerfil() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 30,
        top: 30,
      ),
      child: Text(
        'Meu Perfil',
        textAlign: TextAlign.center,
        style: GoogleFonts.raleway(
          color: GlobalColors.deadGreen,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget botaoSairPerfil() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Sair',
                  style: GoogleFonts.raleway(
                    color: GlobalColors.lightGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  'Tem certeza que deseja sair?',
                  style: GoogleFonts.raleway(
                    color: GlobalColors.deadGreen,
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      'Sim',
                      style: GoogleFonts.raleway(
                        color: GlobalColors.deadGreen,
                      ),
                    ),
                    onPressed: () {
                      _meuPerfilController.logoutUsuario(context);
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.raleway(
                        color: GlobalColors.deadGreen,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            }
          );
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.exit_to_app,
              color: Color(0xFF99c302),
            ),
            Text(
              ' Sair',
              style: GoogleFonts.raleway(
                color: GlobalColors.lightGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fotoPerfil(String? img) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        image: img!.isNotEmpty ?
        DecorationImage(
          image: Image.network(
            img,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ).image,
        ) :
        null,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          backgroundColor: img.isNotEmpty ?
          Colors.transparent :
          GlobalColors.deadGreen,
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return SizedBox(
                height: 120,
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Escolha uma foto da galeria'),
                      onTap: () {
                        _meuPerfilController.editarImagem();
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text('Remover foto'),
                      onTap: () {
                        _meuPerfilController.removerImagem();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            }
          );
        },
        child: img.isNotEmpty ?
        Container() :
        const Icon(
          Icons.person_rounded,
          size: 100,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget nomeCompletoPerfil(String? nome, String? sobrenome) {
    String? nomeCompleto = (nome!.isNotEmpty) ? nome : '';
    nomeCompleto += (nome.isNotEmpty && sobrenome!.isNotEmpty) ? ' ' : '';
    nomeCompleto += (sobrenome!.isNotEmpty) ? sobrenome : '';
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        nomeCompleto,
        style: GoogleFonts.raleway(
          color: GlobalColors.deadGreen,
          fontSize: 25,
        ),
      ),
    );
  }

  Widget usernamePerfil(String username) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        '@$username',
        style: GoogleFonts.raleway(
          color: GlobalColors.deadGreen,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget botaoEditarPerfil() {
    return TextButton(
      onPressed: () {
        _meuPerfilController.editarPerfil(context);
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.settings,
            color: Color(0xFF99c302),
          ),
          Text(
            ' Editar Perfil',
            style: GoogleFonts.raleway(
              color: GlobalColors.lightGreen,
            ),
          ),
        ],
      ),
    );
  }
}
