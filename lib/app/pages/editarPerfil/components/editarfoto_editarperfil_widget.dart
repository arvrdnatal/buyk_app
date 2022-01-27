import 'package:buyk_app/app/app_colors.dart';
import 'package:buyk_app/app/pages/editarPerfil/editarperfil_controller.dart';
import 'package:flutter/material.dart';

class EditarFotoPerfil extends StatefulWidget {
  const EditarFotoPerfil({ Key? key }) : super(key: key);

  @override
  _EditarFotoPerfilState createState() => _EditarFotoPerfilState();
}

class _EditarFotoPerfilState extends State<EditarFotoPerfil> {
  final EditarPerfilController _editarPerfilController = EditarPerfilController();
  
  @override
  Widget build(BuildContext context) {
    _editarPerfilController.setStateController = () => setState(() {});
    return FutureBuilder(
      future: _editarPerfilController.getImagem(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: snapshot.data != '' ?
              DecorationImage(
                image: Image.network(
                  snapshot.data.toString(),
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
                backgroundColor: snapshot.data != '' ?
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
                              _editarPerfilController.editarImagem();
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('Remover foto'),
                            onTap: () {
                              _editarPerfilController.removerImagem();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  }
                );
              },
              child: snapshot.data != '' ?
              Container() :
              const Icon(
                Icons.person_rounded,
                size: 100,
                color: Colors.black,
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF63911d)),
          );
        }
      }
    );
  }
}