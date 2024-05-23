class AuthedUser {
  final int id;
  final String nama;
  final String username;
  final String role;

  AuthedUser({
    required this.role,
    required this.username,
    required this.id,
    required this.nama,
  });

  @override
  String toString() {
    return "User<id:$id nama:$nama username:$username role:$role>";
  }

  factory AuthedUser.fromJSON(Map<String, dynamic> json) {
    return AuthedUser(
      id: json['id'] as int,
      nama: json['nama'] as String,
      username: json['username'] as String,
      role: json['role'] as String,
    );
  }
}
