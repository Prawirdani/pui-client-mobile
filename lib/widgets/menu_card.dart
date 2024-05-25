import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/menu.dart';
import 'package:flutter_application_4/providers/pesanan_form.dart';
import 'package:flutter_application_4/util/formatter.dart';
import 'package:flutter_application_4/widgets/menu_dialog.dart';
import 'package:provider/provider.dart';

class MenuCard extends StatelessWidget {
  final Menu menu;
  const MenuCard({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    final form = Provider.of<PesananForm>(context);
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => showDialog(
          context: context,
          builder: (context) => ChangeNotifierProvider.value(
            value: form,
            child: MenuDialog(menu: menu),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: double.infinity,
                    child: Image.network(menu.url, fit: BoxFit.cover),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 4, right: 2, left: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              menu.nama,
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              menu.kategori.nama,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                height: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          formatIDR(menu.harga),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
