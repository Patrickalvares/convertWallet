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
  List<CurrencyByCurrency> currencieByCurrencys = [];
  List<CurrencyByCurrency> currencieByCurrencysFiltred = [];
  bool getCurrencyValuesLoading = false;
  Currency selectedCurrency = Currency.BRL;
  final DatabaseHelper dbHelper;

  Future<void> initialized() async {
    currencieByCurrencys = await dbHelper.getCurrencyByCurrencies();
    currencieByCurrencysFiltred = currencieByCurrencys;
    update();
  }

  Future<void> getCurrencyValues() async {
    getCurrencyValuesLoading = false;
    update();

    await repository
        .obterCurrencyByCurrency(
      params: generateCurrencyCombinations(selectedCurrency),
    )
        .then((value) async {
      await dbHelper.clearCurrencyByCurrencies();
      currencieByCurrencys = value;
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
      currencieByCurrencysFiltred = currencieByCurrencys;
    } else {
      currencieByCurrencysFiltred = currencieByCurrencys
          .where((element) {
            final bool nomeMatches = element.code.toLowerCase().contains(value.toLowerCase()) || element.targetCurrency.name.toLowerCase().contains(value.toLowerCase());
            return nomeMatches;
          })
          .map((currency) => currency.copyWith())
          .toList();
    }
    update();
  }
}
