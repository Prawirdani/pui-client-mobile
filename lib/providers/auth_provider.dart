import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/auth.dart';
import 'package:flutter_application_4/util/http_client.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  AuthedUser? _user;
  String? _token;
  String? _loginError;

  isAuthed() {
    return _user != null && _token != null;
  }

  Future<void> login(String username, String password) async {
    var url = Uri.https(baseURL, "/api/v1/auth/login");
    try {
      var reqBody = json.encode({
        "username": username,
        "password": password,
      });
      debugPrint(reqBody);

      var res = await http.post(
        url,
        body: reqBody,
      );
      var resBody = jsonDecode(res.body);

      if (res.statusCode != 200) {
        var errMessage = resBody['error']['message'];
        _loginError = errMessage;
        return;
      }
      var token = resBody['data']['token'] as String;
      _token = token;
      await identify();
      // Save token to Shared Prefs
      final sPrefs = await SharedPreferences.getInstance();
      await sPrefs.setString("authToken", token);

      _loginError = null;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> persistLogin() async {
    debugPrint("Persist Login Executed");
    try {
      final sPrefs = await SharedPreferences.getInstance();
      String token = sPrefs.getString("authToken") ?? '';
      if (token.isEmpty) {
        return;
      }
      _token = token;
      await identify();
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> identify() async {
    final url = Uri.https(baseURL, "/api/v1/auth/current");
    try {
      final res = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );
      if (res.statusCode != 200) {
        debugPrint("User not identified!");
        await logout();
        return;
      }

      final resBody = jsonDecode(res.body)['data'];
      _user = AuthedUser.fromJSON(resBody);
      debugPrint("User identified!");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;

    // Clear token from shared prefs
    final sPrefs = await SharedPreferences.getInstance();
    await sPrefs.remove("authToken");
    notifyListeners();
  }

  AuthedUser? get user => _user;
  String get token => _token ?? '';
  String get loginError => _loginError ?? '';
}
