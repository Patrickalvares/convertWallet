import '../../core/entities/currency_by_currency.dart';
import '../../core/entities/currencys.dart';
import '../../core/repository/currency_repository.dart';
import '../global.dart';
import '../repository/database_helper.dart';

class CurrencyService {
  CurrencyService({
    required this.repository,
    required this.dbHelper,
  });

  final CurrencyRepository repository;
  final DatabaseHelper dbHelper;

  Future<void> loadSelectedCurrency() async {
    final currency = await dbHelper.getSelectedCurrency();
    if (currency != null) {
      Global.instance.selectedStandartCurrency = currency;
    } else {
      Global.instance.selectedStandartCurrency = Currency.BRL;
    }
  }

  Future<void> getCurrencyValues() async {
    try {
      final List<CurrencyByCurrency> value = await repository.obterCurrencyByCurrency(
        params: generateCurrencyCombinations(Global.instance.selectedStandartCurrency),
      );

      await dbHelper.clearCurrencyByCurrencies();
      Global.instance.currencies = value;

      for (final currency in value) {
        await dbHelper.insertCurrencyByCurrency(currency);
      }

      final DateTime now = DateTime.now();
      await dbHelper.saveLastUpdated(now);
      Global.instance.lastUpdated = now;
      Global.instance.update();
    } catch (_) {
      Global.instance.currencies = await dbHelper.getCurrencyByCurrencies();
      Global.instance.lastUpdated = await dbHelper.getLastUpdated();
    }
  }

  String generateCurrencyCombinations(Currency selectedCurrency) {
    final List<String> combinations = [];

    for (final Currency currency in Currency.values) {
      if (currency != selectedCurrency) {
        combinations.add('${currency.code}');
      }
    }
    return "&currencies=${combinations.join(',')}&base_currency=${selectedCurrency.code}";
  }
}
