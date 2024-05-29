import 'package:flutter/foundation.dart';

import '../../../../utils/helpers/log.dart';
import '../../data/repository/main_screen_repository.dart';
import '../../domain/entities/currency_by_currency.dart';

class MainScreenController with ChangeNotifier {
  MainScreenController({required this.repository});
  final MainScreenRepository repository;
  List<CurrencyByCurrency> currencies = [];
  bool getCurrencyValuesLoading = false;

  Future<void> getCurrencyValues() async {
    getCurrencyValuesLoading = false;
    notifyListeners();
    await repository.getMainScreenData(params: 'USD-BRL,USD-EUR,BTC-BRL,ETH-USD,LTC-EUR,XRP-BRL,DOGE-USD').then((value) {
      currencies = value;
    }).catchError((error) {});
    for (final currency in currencies) {
      Log.print('Currency: ${currency.name} ${currency.highValue}');
    }
    getCurrencyValuesLoading = true;
    notifyListeners();
  }
}
