import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/receipt.dart';
import 'package:flutter_application_4/util/formatter.dart';
import 'package:flutter_application_4/widgets/button.dart';

class CompletedPesananPage extends StatelessWidget {
  final Receipt receipt;
  const CompletedPesananPage(this.receipt, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 6,
              child: Material(
                elevation: 7,
                child: Container(
                  color: Theme.of(context).hoverColor,
                  padding: const EdgeInsets.all(96),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.receipt_long,
                        size: 42,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const InvoiceText("No Pesanan"),
                          InvoiceText("#${receipt.pesanan.id}"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const InvoiceText("Tipe Pesanan"),
                          InvoiceText(receipt.pesanan.tipe),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const InvoiceText("Pembayaran"),
                          InvoiceText(receipt.payment.metode.metode),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        flex: 7,
                        child: ListView.separated(
                          itemCount: receipt.pesanan.detail.length,
                          itemBuilder: (context, index) {
                            var detail = receipt.pesanan.detail[index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InvoiceText(
                                    "${detail.kuantitas}x ${detail.namaMenu}"),
                                InvoiceText(formatIDR(detail.subTotal)),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            formatIDR(receipt.pesanan.total),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.verified,
                    color: Colors.green,
                    size: 72,
                  ),
                  const Text(
                    "Pesanan berhasil",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 32),
                  Button(
                    minWidth: 300,
                    text: "Cetak Invoice",
                    onPressed: () {},
                  ),
                  const SizedBox(height: 8),
                  Button(
                    minWidth: 300,
                    text: "Kembali",
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    },
                    variant: ButtonVariant.secondary,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InvoiceText extends StatelessWidget {
  final String text;
  const InvoiceText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16),
    );
  }
}
