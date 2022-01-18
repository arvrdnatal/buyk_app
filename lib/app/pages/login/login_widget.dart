import 'package:buyk_app/app/app_colors.dart';
import 'package:buyk_app/app/pages/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final LoginController _loginController = LoginController();

  @override
  Widget build(BuildContext context) {
    _loginController.setStateController = () => setState(() {});
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  tituloLogin(),
                  emailInputLogin(),
                  senhaInputLogin(),
                  botaoSubmit(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget tituloLogin() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 30,
        top: 30,
      ),
      child: Text(
        'Login',
        textAlign: TextAlign.center,
        style: GoogleFonts.raleway(
          color: GlobalColors.deadGreen,
          fontSize: 30,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget emailInputLogin() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
          Focus(
            onFocusChange: (hasFocus) {
              if(!hasFocus) _loginController.verificaEmail();
            },
            child: TextFormField(
              controller: _loginController.emailController,
              cursorColor: GlobalColors.deadGreen,
              style: GoogleFonts.raleway(
                color: GlobalColors.deadGreen,
              ),
              decoration: InputDecoration(
                suffixIcon: _loginController.isCheckingEmail ?
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
                return _loginController.mensagemValidacaoEmail;
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget senhaInputLogin() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
          TextFormField(
            controller: _loginController.senhaController,
            cursorColor: GlobalColors.deadGreen,
            style: GoogleFonts.raleway(
              color: GlobalColors.deadGreen,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  _loginController.vizualizarSenha();
                },
                icon: Icon(
                  _loginController.senhaObscureText ?
                  Icons.visibility_outlined :
                  Icons.visibility_off_outlined
                ),
                color: GlobalColors.deadGreen,
              ),
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
            obscureText: _loginController.senhaObscureText,
            validator: (_) {
              return _loginController.mensagemValidacaoSenha;
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
        onPressed: () {
          _loginController.logarUsuario(_formKey, context);
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: GlobalColors.deadGreen,
          padding: const EdgeInsets.all(18),
        ),
        child: Text(
          'Entrar',
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
