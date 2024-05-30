import 'package:flutter_application_4/models/payment.dart';
import 'package:flutter_application_4/models/pesanan.dart';

class Receipt {
  Pesanan pesanan;
  Payment payment;

  Receipt({required this.pesanan, required this.payment});

  factory Receipt.fromJSON(Map<String, dynamic> json) {
    var pesanan = Pesanan.fromJSON(json["pesanan"]);
    var payment = Payment.fromJSON(json["pembayaran"]);

    return Receipt(pesanan: pesanan, payment: payment);
  }
}
