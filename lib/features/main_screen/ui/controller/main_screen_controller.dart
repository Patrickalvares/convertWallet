import '../../../../core/domain/entities/currencys.dart';
import '../../../../utils/helpers/base_controller.dart';
import '../../../../utils/helpers/database_helper.dart';
import '../../data/repository/main_screen_repository.dart';
import '../../domain/entities/currency_by_currency.dart';

class MainScreenController extends BaseController {
  MainScreenController({required this.repository});
  final MainScreenRepository repository;
  List<CurrencyByCurrency> currencieByCurrencys = [];
  List<CurrencyByCurrency> currencieByCurrencysFiltred = [];
  bool getCurrencyValuesLoading = false;
  Currency selectedCurrency = Currency.BRL;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> initialized() async {
    currencieByCurrencys = await _dbHelper.getCurrencyByCurrencies();
    currencieByCurrencysFiltred = currencieByCurrencys;
    update();
  }

  Future<void> getCurrencyValues() async {
    getCurrencyValuesLoading = false;
    update();

    await repository
        .getMainScreenData(
      params: generateCurrencyCombinations(selectedCurrency),
    )
        .then((value) async {
      await _dbHelper.clearCurrencyByCurrencies();
      currencieByCurrencys = value;
      for (final currency in value) {
        await _dbHelper.insertCurrencyByCurrency(currency);
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
