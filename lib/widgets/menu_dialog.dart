import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/menu.dart';
import 'package:flutter_application_4/providers/pesanan_form.dart';
import 'package:flutter_application_4/util/formatter.dart';
import 'package:flutter_application_4/widgets/button.dart';
import 'package:provider/provider.dart';

class MenuDialog extends StatefulWidget {
  final Menu menu;
  final int? qty;

  const MenuDialog({super.key, required this.menu, this.qty});

  @override
  State<MenuDialog> createState() => _MenuDialogState();
}

class _MenuDialogState extends State<MenuDialog> {
  int _menuQty = 1;

  @override
  void initState() {
    super.initState();
    if (widget.qty != null) {
      _menuQty = widget.qty!;
    }
  }

  setCount(int v) {
    setState(() {
      _menuQty = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    final form = Provider.of<PesananForm>(context);
    final menu = widget.menu;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        height: 500,
        width: 550,
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: double.infinity,
                  child: Image.network(menu.url, fit: BoxFit.cover),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 2, left: 2),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              menu.nama,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              menu.kategori.nama,
                              style: const TextStyle(
                                height: 0.7,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          formatIDR(menu.harga),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "${menu.deskripsi} Lorem Ipsum Dolor Apsimet Ipsum Dolor Apsimet Ipsum Dolor",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          QtyCounter(setCount: setCount, counter: _menuQty),
                          const SizedBox(
                            height: 8,
                          ),
                          Button(
                            text: "Tambah Pesanan",
                            onPressed: () async {
                              await form.addDetail(menu, _menuQty);
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class QtyCounter extends StatefulWidget {
  final int counter;
  final Function(int v) setCount;
  const QtyCounter({super.key, required this.setCount, required this.counter});

  @override
  State<QtyCounter> createState() => _QtyCounterState();
}

class _QtyCounterState extends State<QtyCounter> {
  @override
  Widget build(BuildContext context) {
    var counter = widget.counter;
    incrementQty() {
      widget.setCount(counter + 1);
    }

    decrementQty() {
      widget.setCount(counter - 1);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          padding: const EdgeInsets.all(3),
          constraints: const BoxConstraints(maxHeight: 64, maxWidth: 64),
          style: ButtonStyle(
            side: WidgetStatePropertyAll(
              BorderSide(width: 2, color: Theme.of(context).primaryColor),
            ),
            shape: const WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
            ),
          ),
          onPressed: counter > 1 ? decrementQty : null,
          icon: Icon(
            Icons.remove,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 4),
          child: Text(
            "$counter",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        IconButton(
          padding: const EdgeInsets.all(3),
          constraints: const BoxConstraints(maxHeight: 64, maxWidth: 64),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Theme.of(context).primaryColor,
            ),
            shape: const WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
            ),
          ),
          onPressed: incrementQty,
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
