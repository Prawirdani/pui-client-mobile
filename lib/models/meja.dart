import 'package:flutter_application_4/models/pesanan.dart';

class Meja {
  final int id;
  final String nomor;
  final String status;
  Pesanan? pesanan;

  set setPesanan(Pesanan p) {
    pesanan = p;
  }

  bool isPesananFetched() {
    return status == "Terisi" && pesanan != null;
  }

  Meja({required this.id, required this.nomor, required this.status});

  factory Meja.fromJSON(Map<String, dynamic> json) {
    return Meja(id: json['id'], nomor: json['nomor'], status: json['status']);
  }
}
