import 'currencys.dart';

class WalletedCurrency {
  WalletedCurrency({
    required this.currency,
    required this.amount,
  });
  final Currency currency;
  final double amount;

  Map<String, dynamic> toMap() {
    return {
      'currency_code': currency.code,
      'amount': amount,
    };
  }
}
