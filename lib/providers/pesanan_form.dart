import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/receipt.dart';
import 'package:flutter_application_4/models/meja.dart';
import 'package:flutter_application_4/models/menu.dart';
import 'package:flutter_application_4/models/payment.dart';
import 'package:flutter_application_4/models/pesanan.dart';
import 'package:flutter_application_4/util/http_client.dart';
import 'package:http/http.dart' as http;

class PesananForm extends ChangeNotifier {
  late String _token;
  late Pesanan pesanan;

  registerToken(String token) {
    _token = token;
  }

  List<DetailPesanan> get listDetail => pesanan.detail;
  int get total => pesanan.total;
  bool get pesananInitial => pesanan.id == 0;

  set setPelangganName(String name) {
    pesanan.namaPelanggan = name;
  }

  set setCatatan(String note) {
    if (note.isEmpty) {
      pesanan.catatan = null;
      return;
    }
    pesanan.catatan = note;
  }

  void debug() {
    debugPrint(pesanan.namaPelanggan);
    debugPrint(pesanan.catatan);
  }

  initPesananDineIn(Meja meja) {
    pesanan = Pesanan(
        id: 0,
        namaPelanggan: "",
        meja: meja,
        tipe: "Dine In",
        kasir: "", // DEBT
        status: "Initial",
        catatan: "",
        detail: [],
        total: 0,
        waktuPesanan: "");
    notifyListeners();
  }

  Future<void> fetchDineIn(int mejaID) async {
    debugPrint("Fetchin pesanan data by meja id");
    try {
      final url = Uri.https(baseURL, "/api/v1/orders/search", {
        "mejaID": mejaID.toString(),
        "statusMeja": "Terisi",
        "status": "Diproses"
      });
      final res =
          await http.get(url, headers: {"Authorization": "Bearer $_token"});

      final resBody = jsonDecode(res.body);
      pesanan = Pesanan.fromJSON(resBody["data"]);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Receipt> pay(PaymentMethod pm) async {
    debugPrint("Processing payment");
    try {
      final url = Uri.https(baseURL, "/api/v1/payments");
      final reqBody =
          jsonEncode({"metodePembayaranId": pm.id, "pesananId": pesanan.id});
      final res = await http.post(url,
          body: reqBody, headers: {"Authorization": "Bearer $_token"});
      final resBody = jsonDecode(res.body);
      if (res.statusCode != 201) {
        throw "Failed to pay pesanan";
      }
      final invoice = Receipt.fromJSON(resBody["data"]);

      debugPrint("Payment success");
      return invoice;
    } catch (e) {
      debugPrint(e.toString());
      throw "Failed to pay pesanan";
    }
  }

  Future<bool> cancel() async {
    debugPrint("Canceling Pesanan");
    try {
      final url = Uri.https(baseURL, "/api/v1/orders/${pesanan.id}/cancel");
      final res =
          await http.put(url, headers: {"Authorization": "Bearer $_token"});

      final resBody = jsonDecode(res.body);
      debugPrint(resBody.toString());

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  addDetail(Menu m, int qty) async {
    if (pesananInitial) {
      var subTotal = m.harga * qty;
      pesanan.detail.add(
        DetailPesanan(
            id: 0,
            namaMenu: m.nama,
            menuID: m.id,
            hargaMenu: m.harga,
            kuantitas: qty,
            subTotal: subTotal),
      );
      pesanan.total += subTotal;
      notifyListeners();
    } else {
      final url = Uri.https(baseURL, "/api/v1/orders/${pesanan.id}/add-menu");
      final reqBody = jsonEncode({"menuID": m.id, "kuantitas": qty});
      await http.put(url,
          body: reqBody, headers: {"Authorization": "Bearer $_token"});
      await invalidate();
    }
  }

  Future<void> invalidate() async {
    debugPrint("Invalidating pesanan data");
    try {
      final url = Uri.https(baseURL, "/api/v1/orders/${pesanan.id}");
      final res =
          await http.get(url, headers: {"Authorization": "Bearer $_token"});
      final resBody = jsonDecode(res.body);
      pesanan = Pesanan.fromJSON(resBody["data"]);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  popPesanan(int idx) async {
    debugPrint("Deleting Pesanan Detail");
    var detail = pesanan.detail[idx];
    // Initial pesanan detail/item has id 0 because not yet stored to the db.
    if (detail.id == 0) {
      pesanan.detail.removeAt(idx);
      pesanan.total -= detail.subTotal;
      notifyListeners();
      return;
    }
    final url = Uri.https(baseURL, "/api/v1/orders/${pesanan.id}/${detail.id}");
    await http.delete(url, headers: {"Authorization": "Bearer $_token"});
    await invalidate();
  }

// True for dine in, False for take away
  Future<bool> createPesanan({type = true}) async {
    try {
      var reqBody = pesanan.toRequestBody();

      var endpoint = type ? "/api/v1/orders/dinein" : "/api/v1/orders/takeaway";
      final url = Uri.https(baseURL, endpoint);
      final res = await http.post(url,
          body: reqBody, headers: {"Authorization": "Bearer $_token"});

      final resBody = jsonDecode(res.body);
      debugPrint(resBody.toString());
      if (res.statusCode != 201) {
        return false;
      }
      pesanan.id = resBody["data"]["id"];
      await invalidate();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
