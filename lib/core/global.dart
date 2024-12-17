import '../utils/helpers/base_controller.dart';
import 'entities/currency_by_currency.dart';
import 'entities/currencys.dart';

class Global extends BaseController {
  factory Global() {
    _instance ??= Global._();
    return _instance!;
  }
  Global._();
  static Global? _instance;
  static Global get instance => _instance ?? Global();

  List<CurrencyByCurrency> currencies = [];
  Currency selectedStandartCurrency = Currency.BRL;

  DateTime? lastUpdated;
}
