class User {
  final int id; //ID do usuario
  final String name; //Nome do usuario
  final int age; //Idade usuario

  //contrutor da classe User
  User({required this.id, required this.name, required this.age});

  //Converte um JSON em um objeto User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      age: json['age'],
    );
  }
}
