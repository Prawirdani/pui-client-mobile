import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/meja.dart';
import 'package:flutter_application_4/providers/meja_provider.dart';
import 'package:flutter_application_4/providers/menu_provider.dart';
import 'package:flutter_application_4/providers/payment_provider.dart';
import 'package:flutter_application_4/widgets/meja_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final mejaProvider = Provider.of<MejaProvider>(context);
    final menuProvider = Provider.of<MenuProvider>(context);
    final paymentProvider = Provider.of<PaymentProvider>(context);

    fetchData() async {
      await Future.wait([
        mejaProvider.fetch(),
        menuProvider.fetch(),
        paymentProvider.fetch()
      ]);
    }

    return Column(
      children: [
        mejaProvider.daftarMeja.isEmpty
            ? FutureBuilder(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  return MejaGrid(listMeja: mejaProvider.daftarMeja);
                },
              )
            : MejaGrid(listMeja: mejaProvider.daftarMeja),
      ],
    );
  }
}

class MejaGrid extends StatelessWidget {
  final List<Meja> listMeja;
  const MejaGrid({super.key, required this.listMeja});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = (screenWidth / 200).floor();
    return Expanded(
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 36,
        crossAxisSpacing: 36,
        children: [
          ...listMeja.map((m) => MejaCard(m: m)),
        ],
      ),
    );
  }
}
