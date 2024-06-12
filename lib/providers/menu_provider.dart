import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/menu.dart';
import 'package:flutter_application_4/util/http_client.dart';
import 'package:http/http.dart' as http;

class MenuProvider extends ChangeNotifier {
  late String _token;
  List<Menu> _listMenu = [];

  List<Menu> get listMenu => _listMenu;

  registerToken(String token) {
    _token = token;
  }

  Future<void> fetch() async {
    debugPrint("fetchin Menus");
    _listMenu = [];
    try {
      final url = Uri.http(baseURL, "/api/v1/menus");
      final res =
          await http.get(url, headers: {"Authorization": "Bearer $_token"});
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'];
        for (var each in data) {
          var menu = Menu.fromJSON(each);
          _listMenu.add(menu);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
