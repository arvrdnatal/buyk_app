class UsuarioModel {
  String _id = '';
  String _nome = '';
  String _sobrenome = '';
  String _email = '';
  String _senha = '';
  String _username = '';

  UsuarioModel({String? id, String? nome, String? sobrenome, required String email, required String senha, required String username}){
    _id = id!;
    _nome = nome!;
    _sobrenome = sobrenome!;
    _email = email;
    _senha = senha;
    _username = username;
  }

  set id(String id) => _id = id;
  set nome(String nome) => _nome = nome;
  set sobrenome(String sobrenome) => _sobrenome = sobrenome;
  set email(String email) => _email = email;
  set senha(String senha) => _senha = senha;
  set username(String username) => _username = username;

  Map<String,dynamic> toMap() {
    return {
      'id' : _id,
      'nome' : _nome,
      'sobrenome' : _sobrenome,
      'email' : _email,
      'senha' : _senha,
      'username' : _username,
    };
  }
}