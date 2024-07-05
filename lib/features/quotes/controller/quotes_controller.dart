import '../../../core/data/global.dart';
import '../../../core/domain/entities/currencys.dart';
import '../../../core/entities/currency_by_currency.dart';
import '../../../core/repository/main_screen_repository.dart';
import '../../../utils/helpers/base_controller.dart';
import '../../../utils/helpers/database_helper.dart';

class QuotesController extends BaseController {
  QuotesController({
    required this.repository,
    required this.dbHelper,
  });
  final CurrencyRepository repository;

  List<CurrencyByCurrency> currencieByCurrencysFiltred = [];
  bool getCurrencyValuesLoading = false;

  final DatabaseHelper dbHelper;

  Future<void> initialized() async {
    await _loadSelectedCurrency();
    Global.instance.currencies = await dbHelper.getCurrencyByCurrencies();
    currencieByCurrencysFiltred = Global.instance.currencies;
    update();
  }

  Future<void> getCurrencyValues() async {
    getCurrencyValuesLoading = false;
    update();

    await repository
        .obterCurrencyByCurrency(
      params: generateCurrencyCombinations(Global.instance.selectedStandartCurrency),
    )
        .then((value) async {
      await dbHelper.clearCurrencyByCurrencies();
      Global.instance.currencies = value;
      for (final currency in value) {
        await dbHelper.insertCurrencyByCurrency(currency);
      }
    }).catchError((error) {});

    getCurrencyValuesLoading = true;
    update();
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

  Future<void> filtrarCurrencieByCurrencys(String value) async {
    if (value.trim().isEmpty) {
      currencieByCurrencysFiltred = Global.instance.currencies;
    } else {
      currencieByCurrencysFiltred = Global.instance.currencies
          .where((element) {
            final bool nomeMatches = element.code.toLowerCase().contains(value.toLowerCase()) || element.targetCurrency.name.toLowerCase().contains(value.toLowerCase());
            return nomeMatches;
          })
          .map((currency) => currency.copyWith())
          .toList();
    }
    update();
  }

  Future<void> changeCurrency(Currency newCurrency) async {
    Global.instance.selectedStandartCurrency = newCurrency;
    await dbHelper.saveSelectedCurrency(newCurrency);
    update();
  }

  Future<void> _loadSelectedCurrency() async {
    final currency = await dbHelper.getSelectedCurrency();
    if (currency != null) {
      Global.instance.selectedStandartCurrency = currency;
    }
  }
}
