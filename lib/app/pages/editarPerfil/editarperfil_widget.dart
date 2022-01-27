import 'package:buyk_app/app/app_colors.dart';
import 'package:buyk_app/app/pages/editarPerfil/components/editarfoto_editarperfil_widget.dart';
import 'package:buyk_app/app/pages/editarPerfil/editarperfil_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({Key? key}) : super(key: key);

  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  final EditarPerfilController _editarPerfilController = EditarPerfilController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _editarPerfilController.setStateController = () => setState(() {});
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () {
          if(_editarPerfilController.isBotaoEnabled) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    'Sair sem Salvar',
                    style: GoogleFonts.raleway(
                      color: GlobalColors.lightGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    'Tem certeza que deseja voltar sem salvar as alterações?',
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
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Cancelar',
                        style: GoogleFonts.raleway(
                          color: GlobalColors.deadGreen,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                );
              }
            );
          } else {
            Navigator.of(context).pop();
          }
        },
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Color(0xFF63911d),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.center,
          child: FutureBuilder(
            future: _editarPerfilController.memoizer.runOnce(() => _editarPerfilController.getDados()),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                Map dados = snapshot.data as Map;
                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        tituloEditar(),
                        const EditarFotoPerfil(),
                        nomeEditar(dados['nome']),
                        sobrenomeEditar(dados['sobrenome']),
                        usernameEditar(dados['username']),
                        botaoSalvarPerfil(),
                      ],
                    ),
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

  Widget tituloEditar() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 30,
        top: 30,
      ),
      child: Text(
        'Editar Perfil',
        textAlign: TextAlign.center,
        style: GoogleFonts.raleway(
          color: GlobalColors.deadGreen,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget nomeEditar(String? nome) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Nome',
                  style: GoogleFonts.raleway(
                    color: GlobalColors.deadGreen,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          TextFormField(
            controller: _editarPerfilController.nomeController,
            onChanged: (_) => _editarPerfilController.mudarBotao(),
            cursorColor: GlobalColors.deadGreen,
            style: GoogleFonts.raleway(
              color: GlobalColors.deadGreen,
            ),
            decoration: InputDecoration(
              hintText: 'Digite seu nome',
              hintStyle: GoogleFonts.raleway(
                color: GlobalColors.deadGreen.withOpacity(0.5),
              ),
              errorStyle: GoogleFonts.raleway(
                color: Colors.red,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: GlobalColors.deadGreen,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: GlobalColors.lightGreen
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sobrenomeEditar(String? sobrenome) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Sobrenome',
                  style: GoogleFonts.raleway(
                    color: GlobalColors.deadGreen,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          TextFormField(
            controller: _editarPerfilController.sobrenomeController,
            onChanged: (_) => _editarPerfilController.mudarBotao(),
            cursorColor: GlobalColors.deadGreen,
            style: GoogleFonts.raleway(
              color: GlobalColors.deadGreen,
            ),
            decoration: InputDecoration(
              hintText: 'Digite seu sobrenome',
              hintStyle: GoogleFonts.raleway(
                color: GlobalColors.deadGreen.withOpacity(0.5),
              ),
              errorStyle: GoogleFonts.raleway(
                color: Colors.red,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: GlobalColors.deadGreen,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: GlobalColors.lightGreen
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget usernameEditar(String username) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Nome de Usuário',
                  style: GoogleFonts.raleway(
                    color: GlobalColors.deadGreen,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          TextFormField(
            onChanged: (_) {
              _editarPerfilController.mudarBotao();
              _editarPerfilController.verificaUsername();
            },
            controller: _editarPerfilController.usernameController,
            cursorColor: GlobalColors.deadGreen,
            style: GoogleFonts.raleway(
              color: GlobalColors.deadGreen,
            ),
            decoration: InputDecoration(
              suffixIcon: _editarPerfilController.isCheckingUsername ?
              Transform.scale(
                scale: 0.5,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF63911d)),
                ),
              ) : null,
              hintText: 'Digite seu nome de usuário',
              hintStyle: GoogleFonts.raleway(
                color: GlobalColors.deadGreen.withOpacity(0.5),
              ),
              errorStyle: GoogleFonts.raleway(
                color: Colors.red,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: GlobalColors.deadGreen,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: GlobalColors.lightGreen,
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (_) => _editarPerfilController.mensagemValidacaoUsername,
          ),
        ],
      ),
    );
  }

  Widget botaoSalvarPerfil() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        right: 70,
        left: 70,
        bottom: 10,
      ),
      child: TextButton(
        onPressed: _editarPerfilController.isBotaoEnabled ?
        () {
          _editarPerfilController.salvarAlteracoes(_formKey, context);
        } : null,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: _editarPerfilController.isBotaoEnabled ?
          GlobalColors.deadGreen :
          Colors.black12,
          padding: const EdgeInsets.all(18),
        ),
        child: Text(
          'Salvar',
          style: GoogleFonts.raleway(
            color: _editarPerfilController.isBotaoEnabled ?
            GlobalColors.black :
            GlobalColors.deadGreen,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
