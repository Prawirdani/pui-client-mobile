import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/meja.dart';
import 'package:flutter_application_4/util/http_client.dart';
import 'package:http/http.dart' as http;

class MejaProvider extends ChangeNotifier {
  String? _token;
  List<Meja> _daftarMeja = [];

  void registerToken(String token) {
    _token = token;
    notifyListeners();
  }

  List<Meja> get daftarMeja => _daftarMeja;

  Future<void> fetch() async {
    debugPrint("Fetchin tables");
    try {
      _daftarMeja = [];
      final url = Uri.https(baseURL, "/api/v1/tables");
      final res =
          await http.get(url, headers: {"Authorization": "Bearer $_token"});
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)["data"];
        for (var each in data) {
          var meja = Meja.fromJSON(each);
          _daftarMeja.add(meja);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
