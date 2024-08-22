import '../../core/data/singleton/global.dart';
import '../../core/entities/currency_by_currency.dart';
import '../../core/entities/currencys.dart';
import '../../core/service/currencies_service.dart';
import '../../utils/helpers/base_controller.dart';

class QuotesController extends BaseController {
  QuotesController({
    required CurrencyService currencyService,
  }) : _currencyService = currencyService;

  final CurrencyService _currencyService;
  List<CurrencyByCurrency> currencieByCurrencysFiltred = [];
  bool getCurrencyValuesLoading = false;

  Future<void> initialize() async {
    await _currencyService.loadSelectedCurrency();
    await getCurrencyValues();
  }

  Future<void> getCurrencyValues() async {
    getCurrencyValuesLoading = true;
    update();

    await _currencyService.getCurrencyValues();
    currencieByCurrencysFiltred = Global.instance.currencies;

    getCurrencyValuesLoading = false;
    update();
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
    await _currencyService.dbHelper.saveSelectedCurrency(newCurrency);
    await _currencyService.getCurrencyValues();
    update();
  }
}
