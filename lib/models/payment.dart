class PaymentMethod {
  int id;
  String tipePembayaran;
  String metode;
  String deskripsi;

  PaymentMethod(
      {required this.id,
      required this.tipePembayaran,
      required this.metode,
      required this.deskripsi});

  factory PaymentMethod.fromJSON(Map<String, dynamic> json) {
    return PaymentMethod(
        id: json["id"],
        tipePembayaran: json["tipePembayaran"],
        metode: json["metode"],
        deskripsi: json["deskripsi"]);
  }
}

class Payment {
  int id;
  PaymentMethod metode;
  int jumlah;
  String waktuPembayaran;

  Payment(
      {required this.id,
      required this.metode,
      required this.jumlah,
      required this.waktuPembayaran});

  factory Payment.fromJSON(Map<String, dynamic> json) {
    PaymentMethod metode = PaymentMethod.fromJSON(json["metode"]);
    return Payment(
        id: json["id"],
        metode: metode,
        jumlah: json["jumlah"],
        waktuPembayaran: json["waktuPembayaran"]);
  }
}
