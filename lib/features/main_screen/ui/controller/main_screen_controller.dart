import '../../../../core/domain/entities/currencys.dart';
import '../../../../utils/helpers/base_controller.dart';
import '../../data/repository/main_screen_repository.dart';
import '../../domain/entities/currency_by_currency.dart';

class MainScreenController extends BaseController {
  MainScreenController({required this.repository});
  final MainScreenRepository repository;
  List<CurrencyByCurrency> currencies = [];
  bool getCurrencyValuesLoading = false;
  Currency selectedCurrency = Currency.BRL;

  Future<void> getCurrencyValues() async {
    getCurrencyValuesLoading = false;
    update();

    await repository
        .getMainScreenData(
      params: generateCurrencyCombinations(selectedCurrency),
    )
        .then((value) {
      currencies = value;
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
}
