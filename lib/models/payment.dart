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
