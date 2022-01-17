class UsuarioModel {
  String _id = '';
  String _nome = '';
  String _sobrenome = '';
  String _email = '';
  String _senha = '';
  String _username = '';
  String _imagem = '';

  UsuarioModel({String? id, String? nome, String? sobrenome, required String email, required String senha, required String username, String? imagem}){
    _id = id!;
    _nome = nome!;
    _sobrenome = sobrenome!;
    _email = email;
    _senha = senha;
    _username = username;
    _imagem = imagem!;
  }

  set id(String id) => _id = id;
  set nome(String nome) => _nome = nome;
  set sobrenome(String sobrenome) => _sobrenome = sobrenome;
  set email(String email) => _email = email;
  set senha(String senha) => _senha = senha;
  set username(String username) => _username = username;
  set imagem(String imagem) => _imagem = imagem;

  Map<String,dynamic> toMap() {
    return {
      'id' : _id,
      'nome' : _nome,
      'sobrenome' : _sobrenome,
      'email' : _email,
      'senha' : _senha,
      'username' : _username,
      'imagem' : _imagem,
    };
  }
}