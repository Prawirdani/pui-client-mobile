class Meja {
  final int id;
  final String nomor;
  final String status;

  Meja({required this.id, required this.nomor, required this.status});

  factory Meja.fromJSON(Map<String, dynamic> json) {
    return Meja(id: json['id'], nomor: json['nomor'], status: json['status']);
  }
}
