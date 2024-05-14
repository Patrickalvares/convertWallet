import '../../../../utils/helpers/log.dart';
import '../../data/repository/main_screen_repository.dart';
import '../../domain/entities/currency_by_currency.dart';

class MainScreenController {
  MainScreenController({required this.repository});

  final MainScreenRepository repository;
  List<CurrencyByCurrency> currencies = [];

  Future<void> getCurrencyValues() async {
    await repository.getMainScreenData(params: 'USD-BRL,EUR-BRL,BTC-BRL').then((value) {
      currencies = value;
    }).catchError((error) {});
    for (final currency in currencies) {
      Log.print('Currency: ${currency.name} ${currency.highValue}');
    }
  }
}
