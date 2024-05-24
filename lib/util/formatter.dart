import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

String formatIDR(int amount) {
  return currencyFormatter.format(amount);
}
