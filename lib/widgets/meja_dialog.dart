import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/meja.dart';
import 'package:flutter_application_4/pages/add_pesanan_page.dart';
import 'package:flutter_application_4/widgets/button.dart';

class MejaDialog extends StatelessWidget {
  final Meja meja;
  const MejaDialog({super.key, required this.meja});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          height: 300,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(meja.nomor),
              Align(
                alignment: Alignment.bottomRight,
                child: Button(
                  text: "Buat pesanan",
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddPesananPage(meja: meja),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
