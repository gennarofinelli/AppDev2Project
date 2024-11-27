class User {
  String? id;
  String name;
  int age;
  String email;
  String password;
  String bloodType;

  User({
    this.id,
    required this.name,
    required this.age,
    required this.email,
    required this.password,
    required this.bloodType,
  });

  User.fromMap(Map<String, dynamic> result)
      : id = result['id'],
        name = result['name'],
        age = result['age'],
        email = result['email'],
        password = result['password'],
        bloodType = result['bloodType'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'email': email,
      'password': password,
      'bloodType': bloodType,
    };
  }
}