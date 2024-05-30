import 'dart:convert';

import 'package:flutter_application_4/models/meja.dart';

class Pesanan {
  int id;
  String namaPelanggan;
  Meja? meja;
  String kasir;
  String tipe;
  String status;
  String? catatan;
  List<DetailPesanan> detail;
  int total;
  String waktuPesanan;

  Pesanan(
      {required this.id,
      required this.namaPelanggan,
      required this.tipe,
      required this.status,
      required this.kasir,
      this.meja,
      required this.catatan,
      required this.detail,
      required this.total,
      required this.waktuPesanan});

  String toRequestBody() {
    return jsonEncode({
      "namaPelanggan": namaPelanggan,
      "mejaID": meja?.id,
      "menu": detail.map((each) {
        return {"menuID": each.menuID, "kuantitas": each.kuantitas};
      }).toList(),
      "catatan": catatan
    });
  }

  factory Pesanan.fromJSON(Map<String, dynamic> json) {
    Meja meja = Meja.fromJSON(json["meja"]);
    List<DetailPesanan> detail = [];

    var detailJSON = json["detail"];
    if (detailJSON != null) {
      for (var each in detailJSON) {
        var d = DetailPesanan.fromJSON(each);
        detail.add(d);
      }
    }

    return Pesanan(
        id: json["id"],
        namaPelanggan: json["namaPelanggan"],
        kasir: json["kasir"],
        meja: meja,
        tipe: json["tipe"],
        status: json["status"],
        catatan: json["catatan"],
        detail: detail,
        total: json["total"],
        waktuPesanan: json["waktuPesanan"]);
  }
}

class DetailPesanan {
  int id;
  String namaMenu;
  int hargaMenu;
  int kuantitas;
  int subTotal;
  int menuID;

  DetailPesanan(
      {required this.id,
      required this.namaMenu,
      this.menuID = 0,
      required this.hargaMenu,
      required this.kuantitas,
      required this.subTotal});

  factory DetailPesanan.fromJSON(Map<String, dynamic> json) {
    return DetailPesanan(
        id: json["id"],
        namaMenu: json["namaMenu"],
        hargaMenu: json["hargaMenu"],
        kuantitas: json["kuantitas"],
        subTotal: json["subtotal"]);
  }
}
