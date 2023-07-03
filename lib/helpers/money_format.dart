import 'package:intl/intl.dart';

String? moneyFormat(value) {
  var formatter = NumberFormat('#,##0.00', 'en_US');
  String formattedValue = formatter.format(value);

  return formattedValue; // Output: 1,234.56
}
