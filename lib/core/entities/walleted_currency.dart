import 'currencys.dart';

class WalletedCurrency {
  WalletedCurrency({
    required this.currency,
    required this.amount,
  });
  final Currency currency;
  final double amount;
}
