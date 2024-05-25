import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/meja.dart';
import 'package:flutter_application_4/models/menu.dart';
import 'package:flutter_application_4/models/pesanan.dart';
import 'package:flutter_application_4/providers/meja_provider.dart';
import 'package:flutter_application_4/providers/menu_provider.dart';
import 'package:flutter_application_4/providers/pesanan_form.dart';
import 'package:flutter_application_4/util/formatter.dart';
import 'package:flutter_application_4/widgets/button.dart';
import 'package:flutter_application_4/widgets/menu_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

// TODO: Add Confirmation on: Delete detail, Cancel Pesanan
// TODO: Loading state for Tambah pesanan, delete pesanan or any invalidation
// TODO: When creating new pesanan, pop up confirmation on proceed button, also provide pelanggan name and pesanan note in this pop up.

enum PesananType { dinein, takeaway }

class AddPesananPage extends StatefulWidget {
  final Meja meja;
  final PesananType type;
  const AddPesananPage(
      {super.key, required this.meja, this.type = PesananType.dinein});

  @override
  State<AddPesananPage> createState() => _AddPesananPageState();
}

class _AddPesananPageState extends State<AddPesananPage> {
  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final form = Provider.of<PesananForm>(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 7, // 70% of the row
                    child: Container(
                      color: Theme.of(context).hoverColor,
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.arrow_back),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.meja.nomor,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, bottom: 24),
                              child: MenuGrid(menus: menuProvider.listMenu),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3, // 30% of the row
                    child: Material(
                      elevation: 8,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Pesanan",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (!form.pesananInitial)
                                  Text(
                                    "#${form.pesanan.id}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 12, right: 12, bottom: 12),
                            child: Divider(
                              height: 0,
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: FutureBuilder(
                                future: widget.meja.status != "Tersedia" &&
                                        form.pesananInitial
                                    ? form.fetchDineIn(widget.meja.id)
                                    : null,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  return const PesananList();
                                }),
                          ),
                          const ProceedSection()
                        ],
                      ),
                    ),
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

class PesananList extends StatelessWidget {
  const PesananList({super.key});

  @override
  Widget build(BuildContext context) {
    final form = Provider.of<PesananForm>(context);
    if (form.listDetail.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          "Belum ada menu yang dipesan",
          style: TextStyle(fontSize: 16, color: Colors.black45),
        ),
      );
    }
    return ListView.builder(
      itemCount: form.listDetail.length,
      itemBuilder: (context, index) {
        var currItem = form.listDetail[index];
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(),
          child: Slidable(
            endActionPane: ActionPane(
              extentRatio: 0.2,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  backgroundColor: Colors.red.withOpacity(0.5),
                  icon: Icons.delete,
                  onPressed: (context) => form.popPesanan(index),
                ),
              ],
            ),
            child: PesananItemListTile(
              detail: currItem,
            ),
          ),
        );
      },
    );
  }
}

class PesananItemListTile extends StatelessWidget {
  final DetailPesanan detail;
  const PesananItemListTile({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 24, right: 24),
      title: Text(
        detail.namaMenu,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("x${detail.kuantitas}"),
              Text(
                formatIDR(detail.subTotal),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ProceedSection extends StatefulWidget {
  const ProceedSection({super.key});

  @override
  State<ProceedSection> createState() => _ProceedSectionState();
}

class _ProceedSectionState extends State<ProceedSection> {
  bool _loading = false;

  _setLoading(bool v) {
    setState(() {
      _loading = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mejaProvider = Provider.of<MejaProvider>(context);
    final form = Provider.of<PesananForm>(context);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                formatIDR(form.total),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 42,
            margin: const EdgeInsets.only(bottom: 12),
            child: _loading
                ? const SizedBox(
                    width: 40,
                    child: CircularProgressIndicator(),
                  )
                : form.pesananInitial
                    ? Button(
                        text: "Proses",
                        minWidth: 250,
                        onPressed: form.pesanan.detail.isNotEmpty
                            ? () async {
                                _setLoading(true);
                                if (await form.createPesanan()) {
                                  await mejaProvider.invalidate();
                                  await form.fetchDineIn(form.pesanan.meja!.id);
                                }
                                _setLoading(false);
                              }
                            : null)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Button(
                            text: "Batalkan",
                            variant: ButtonVariant.destructive,
                            minWidth: 160,
                            onPressed: () async {
                              _setLoading(true);
                              if (await form.cancel()) {
                                await mejaProvider.invalidate();
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              }
                              _setLoading(false);
                            },
                          ),
                          const Button(text: "Bayar", minWidth: 160),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}

class MenuGrid extends StatelessWidget {
  const MenuGrid({super.key, required this.menus});
  final List<Menu> menus;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = (screenWidth / 400).floor();
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Refreshed'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: GridView.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
          children: [
            ...menus.map((each) => MenuCard(menu: each)),
          ]),
    );
  }
}
