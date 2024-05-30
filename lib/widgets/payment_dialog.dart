import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/payment.dart';
import 'package:flutter_application_4/pages/completed_pesanan_page.dart';
import 'package:flutter_application_4/providers/meja_provider.dart';
import 'package:flutter_application_4/providers/payment_provider.dart';
import 'package:flutter_application_4/providers/pesanan_form.dart';
import 'package:flutter_application_4/widgets/button.dart';
import 'package:provider/provider.dart';

class PaymentDialog extends StatefulWidget {
  const PaymentDialog({super.key});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  bool _loading = false;
  PaymentMethod? _selectedPayment;

  _setSelected(PaymentMethod v) {
    setState(() {
      _selectedPayment = v;
    });
  }

  _setLoading(bool v) {
    setState(() {
      _loading = v;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedPayment =
        Provider.of<PaymentProvider>(context, listen: false).methods[0];
  }

  @override
  Widget build(BuildContext context) {
    final form = Provider.of<PesananForm>(context);
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final mejaProvider = Provider.of<MejaProvider>(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: const EdgeInsets.all(32),
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.width * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Metode Pembayaran",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: paymentProvider.methods.length,
                itemBuilder: (context, index) {
                  var curr = paymentProvider.methods[index];
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 0.5)),
                    child: RadioListTile<PaymentMethod>(
                      title: Text(curr.metode),
                      value: curr,
                      groupValue: _selectedPayment,
                      onChanged: (value) => _setSelected(value!),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
              ),
            ),
            _loading
                ? const CircularProgressIndicator()
                : Button(
                    text: "Bayar Pesanan",
                    minWidth: double.infinity,
                    onPressed: () async {
                      _setLoading(true);
                      try {
                        final receipt = await form.pay(_selectedPayment!);
                        await mejaProvider.invalidate();
                        if (context.mounted) {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CompletedPesananPage(receipt),
                            ),
                          );
                        }
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                      _setLoading(false);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
