import 'package:buyk_app/app/app_colors.dart';
import 'package:buyk_app/app/pages/cadastro/cadastro_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final CadastroController _cadastroController = CadastroController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _cadastroController.setStateController = () => setState(() {});
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              tituloCadastro(),
              nomeInputCadastro(),
              sobrenomeInputCadastro(),
              usernameInputCadastro(),
              emailInputCadastro(),
              senhaInputCadastro(),
              botaoSubmit(),
            ],
          ),
        ),
      ),
    );
  }

  Widget tituloCadastro() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 30,
        top: 30,
      ),
      child: Column(
        children: [
          Text(
            'Cadastro',
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
              color: GlobalColors.deadGreen,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '* ',
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                  color: Colors.red,
                  fontSize: 15,
                ),
              ),
              Text(
                'Campos Obrigatórios',
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                  color: GlobalColors.deadGreen,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget nomeInputCadastro() {
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
            controller: _cadastroController.nomeController,
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

  Widget sobrenomeInputCadastro() {
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
            controller: _cadastroController.sobrenomeController,
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

  Widget usernameInputCadastro() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Text(
                      'Nome de Usuário',
                      style: GoogleFonts.raleway(
                        color: GlobalColors.deadGreen,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '*',
                      style: GoogleFonts.raleway(
                        color: Colors.red,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Focus(
            onFocusChange: (hasFocus) {
              if(!hasFocus) _cadastroController.verificaUsername();
            },
            child: TextFormField(
              controller: _cadastroController.usernameController,
              cursorColor: GlobalColors.deadGreen,
              style: GoogleFonts.raleway(
                color: GlobalColors.deadGreen,
              ),
              decoration: InputDecoration(
                suffixIcon: _cadastroController.isCheckingUsername ?
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (_) {
                return _cadastroController.mensagemValidacaoUsername;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget emailInputCadastro() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Text(
                      'E-mail',
                      style: GoogleFonts.raleway(
                        color: GlobalColors.deadGreen,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '*',
                      style: GoogleFonts.raleway(
                        color: Colors.red,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Focus(
            onFocusChange: (hasFocus) {
              if(!hasFocus) _cadastroController.verificaEmail();
            },
            child: TextFormField(
              controller: _cadastroController.emailController,
              cursorColor: GlobalColors.deadGreen,
              style: GoogleFonts.raleway(
                color: GlobalColors.deadGreen,
              ),
              decoration: InputDecoration(
                suffixIcon: _cadastroController.isCheckingEmail ?
                Transform.scale(
                  scale: 0.5,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF63911d)),
                  ),
                ) : null,
                hintText: 'Digite seu e-mail',
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (_) {
                return _cadastroController.mensagemValidacaoEmail;
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget senhaInputCadastro() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Text(
                      'Senha',
                      style: GoogleFonts.raleway(
                        color: GlobalColors.deadGreen,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '*',
                      style: GoogleFonts.raleway(
                        color: Colors.red,
                        fontSize: 20,
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
          TextFormField(
            controller: _cadastroController.senhaController,
            cursorColor: GlobalColors.deadGreen,
            style: GoogleFonts.raleway(
              color: GlobalColors.deadGreen,
            ),
            decoration: InputDecoration(
              hintText: 'Digite sua senha',
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (senha) {
              return _cadastroController.verificaSenha(senha!);
            },
          ),
        ],
      ),
    );
  }

  Widget botaoSubmit() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        right: 70,
        left: 70,
        bottom: 10,
      ),
      child: TextButton(
        onPressed: () => {
          _cadastroController.registrarUsuario(_formKey, context)
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: GlobalColors.deadGreen,
          padding: const EdgeInsets.all(18),
        ),
        child: Text(
          'Cadastrar',
          style: GoogleFonts.raleway(
            color: GlobalColors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
