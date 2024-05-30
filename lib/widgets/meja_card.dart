import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/meja.dart';
import 'package:flutter_application_4/pages/add_pesanan_page.dart';
import 'package:flutter_application_4/providers/pesanan_form.dart';
import 'package:provider/provider.dart';

class MejaCard extends StatelessWidget {
  final Meja m;
  const MejaCard({super.key, required this.m});

  @override
  Widget build(BuildContext context) {
    final formPesanan = Provider.of<PesananForm>(context);

    Map<String, Color> cardColor = {
      "Tersedia": const Color(0xFF83D991),
      "Terisi": const Color(0xFFD16F6F),
      "Reserved": const Color(0xFF6F79D1),
    };
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        elevation: 4,
        backgroundColor: cardColor[m.status]!.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        m.nomor,
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () {
        formPesanan.initPesananDineIn(m);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddPesananPage(meja: m),
          ),
        );
      },
    );
  }
}
