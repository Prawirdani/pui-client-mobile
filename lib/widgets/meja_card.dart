import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/meja.dart';
import 'package:flutter_application_4/pages/meja_detail_page.dart';

class MejaCard extends StatelessWidget {
  final Meja m;
  const MejaCard({super.key, required this.m});

  @override
  Widget build(BuildContext context) {
    Map<String, Color> cardColor = {
      "Tersedia": const Color(0xFF83D991),
      "Terisi": const Color(0xFFD16F6F),
      "Reserved": const Color(0xFF6F79D1),
    };
    // return GestureDetector(
    //   onTap: () {
    //     debugPrint(m.nomor);
    //   },
    //   child: Container(
    //     padding: const EdgeInsets.all(12),
    //     decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(8), color: cardColor[m.status]),
    //     child: Center(
    //       child: Text(
    //         m.nomor,
    //         style: const TextStyle(
    //           fontSize: 20,
    //           fontWeight: FontWeight.w500,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MejaDetailScreen(meja: m),
          ),
        );
      },
    );
  }
}
