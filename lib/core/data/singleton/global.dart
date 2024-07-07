import '../../domain/entities/currencys.dart';
import '../../entities/currency_by_currency.dart';

class Global {
  factory Global() {
    _instance ??= Global._();
    return _instance!;
  }
  Global._();
  static Global? _instance;
  static Global get instance => _instance ?? Global();
  List<CurrencyByCurrency> currencies = [];
  Currency selectedStandartCurrency = Currency.BRL;
}
