import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/meja.dart';

class MejaDetailScreen extends StatelessWidget {
  final Meja meja;

  const MejaDetailScreen({super.key, required this.meja});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meja - ${meja.nomor}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meja Number: ${meja.nomor}',
                style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            Text('Status: ${meja.status}',
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
