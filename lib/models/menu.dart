import 'package:flutter_application_4/util/http_client.dart';

String _formatUrl(String imageName) {
  final url = Uri.http(baseURL, "/api/images/$imageName");
  return url.toString();
}

class Menu {
  final int id;
  final String nama;
  final String deskripsi;
  final Kategori kategori;
  final int harga;
  final String url;

  Menu(
      {required this.nama,
      required this.deskripsi,
      required this.kategori,
      required this.harga,
      required this.url,
      required this.id});

  @override
  String toString() {
    return "Menu<id:$id nama:$nama deskripsi:$deskripsi harga:$harga url:$url kategori:${kategori.toString()}>";
  }

  factory Menu.fromJSON(Map<String, dynamic> json) {
    final kategori = Kategori.fromJSON(json['kategori']);
    return Menu(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      kategori: kategori,
      harga: json['harga'],
      url: _formatUrl(json['url']),
    );
  }
}

class Kategori {
  final int id;
  final String nama;
  Kategori({required this.id, required this.nama});

  @override
  String toString() {
    return "Kategori<id:$id nama:$nama>";
  }

  factory Kategori.fromJSON(Map<String, dynamic> json) {
    return Kategori(id: json['id'], nama: json['nama']);
  }
}
