import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/payment.dart';
import 'package:flutter_application_4/util/http_client.dart';
import 'package:http/http.dart' as http;

class PaymentProvider extends ChangeNotifier {
  late String _token;
  final List<PaymentMethod> _methods = [];

  get methods => _methods;

  registerToken(String token) {
    _token = token;
  }

  Future<void> fetch() async {
    debugPrint("Fetching payment methods");
    try {
      final url = Uri.https(baseURL, "/api/v1/payments/methods");
      final res =
          await http.get(url, headers: {"Authorization": "Bearer $_token"});

      if (res.statusCode == 200) {
        final resBody = jsonDecode(res.body)["data"];
        for (var each in resBody) {
          final method = PaymentMethod.fromJSON(each);
          _methods.add(method);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
