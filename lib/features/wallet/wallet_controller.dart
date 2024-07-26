import 'package:flutter/material.dart';

import '../../core/data/singleton/global.dart';
import '../../core/entities/currency_by_currency.dart';
import '../../core/entities/currencys.dart';
import '../../core/entities/walleted_currency.dart';
import '../../core/repository/currency_repository.dart';
import '../../utils/helpers/base_controller.dart';
import '../../utils/helpers/database_helper.dart';

class WalletController extends BaseController {
  WalletController({
    required this.repository,
    required this.dbHelper,
  });

  bool getCurrencyValuesLoading = false;
  CurrencyByCurrency? targetCurrencyByCurrency;
  final CurrencyRepository repository;
  final DatabaseHelper dbHelper;
  final TextEditingController walletValueController = TextEditingController();
  Currency? selectedTargetCurrency;
  Future<void> getCurrencyValues() async {
    getCurrencyValuesLoading = true;
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

    getCurrencyValuesLoading = false;
    update();
  }

  Future<void> setSourceCurrency(Currency? currency) async {
    Global.instance.selectedStandartCurrency = currency!;
    await getCurrencyValues();
    targetCurrencyByCurrency = Global.instance.currencies.firstWhere((element) => element.targetCurrency == selectedTargetCurrency);
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

  Future<void> addCurrencyToWallet(Currency currency, double amount) async {
    final WalletedCurrency walletedCurrency = WalletedCurrency(
      currency: currency,
      amount: amount,
    );
    await dbHelper.insertWalletedCurrency(walletedCurrency);
    update();
  }
}
