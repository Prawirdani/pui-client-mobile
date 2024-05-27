import 'package:flutter/material.dart';
import 'package:flutter_application_4/providers/meja_provider.dart';
import 'package:flutter_application_4/providers/pesanan_form.dart';
import 'package:flutter_application_4/widgets/button.dart';
import 'package:provider/provider.dart';

class PesananConfirmationDialog extends StatefulWidget {
  const PesananConfirmationDialog({super.key});

  @override
  State<PesananConfirmationDialog> createState() =>
      _PesananConfirmationDialogState();
}

class _PesananConfirmationDialogState extends State<PesananConfirmationDialog> {
  bool _loading = false;

  _setLoading(bool v) {
    setState(() {
      _loading = v;
    });
  }

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final pesananForm = Provider.of<PesananForm>(context);
    final mejaProvider = Provider.of<MejaProvider>(context);
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: SizedBox(
          height: 400,
          width: 500,
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Proses Pesanan",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: [
                      TextFormField(
                        controller: _customerNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Masukkan nama pelanggan";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Nama Pelanggan"),
                          hintText: "Nama pelanggan",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      TextFormField(
                        controller: _noteController,
                        minLines: 3,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          label: Text("Catatan"),
                          hintText: "Catatan (Opsional)",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _loading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(),
                          )
                        : Button(
                            text: "Proses Pesanan",
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _setLoading(true);
                                pesananForm.setPelangganName =
                                    _customerNameController.text;
                                pesananForm.setCatatan = _noteController.text;

                                if (await pesananForm.createPesanan()) {
                                  await mejaProvider.invalidate();
                                  context.mounted
                                      ? Navigator.pop(context)
                                      : null;
                                }
                                _setLoading(false);
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
