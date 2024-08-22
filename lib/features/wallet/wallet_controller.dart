import 'package:collection/collection.dart';
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

  Future<void> changeCurrencyToWallet(Currency currency, double amount, {VoidCallback? onAdded}) async {
    final WalletedCurrency? existingCurrency = await dbHelper.getWalletedCurrencyByCode(currency.code);

    if (existingCurrency != null) {
      final updatedAmount = existingCurrency.amount + amount;
      if (updatedAmount <= 0) {
        await dbHelper.deleteWalletedCurrency(currency.code);
      } else {
        final updatedCurrency = WalletedCurrency(currency: currency, amount: updatedAmount);
        await dbHelper.updateWalletedCurrency(updatedCurrency);
      }
    } else {
      final newCurrency = WalletedCurrency(currency: currency, amount: amount);
      await dbHelper.insertWalletedCurrency(newCurrency);
    }

    update();
    if (onAdded != null) {
      onAdded();
    }
    walletValueController.text = '';
  }

  Future<List<WalletedCurrency>> getGroupedWalletedCurrencies() async {
    final List<WalletedCurrency> walletedCurrencies = await dbHelper.getWalletedCurrencies();

    final grouped = groupBy(walletedCurrencies, (WalletedCurrency wc) => wc.currency.code);
    return grouped.entries.map((entry) {
      final totalAmount = entry.value.fold(0, (sum, wc) => sum + wc.amount.toInt());
      return WalletedCurrency(
        currency: entry.value.first.currency,
        amount: totalAmount.toDouble(),
      );
    }).toList();
  }

  Future<double> calculateTotalInSelectedCurrency() async {
    if (selectedTargetCurrency == null) return 0.0;

    final List<WalletedCurrency> walletedCurrencies = await dbHelper.getWalletedCurrencies();

    double totalInTargetCurrency = 0;

    for (final walletedCurrency in walletedCurrencies) {
      final conversionRate = Global.instance.currencies
          .firstWhere(
            (currencyByCurrency) => currencyByCurrency.targetCurrency == walletedCurrency.currency,
            orElse: () => CurrencyByCurrency(
              code: walletedCurrency.currency.code,
              standardByTargetValue: 1,
              targetByStandardRate: 1,
              targetCurrency: walletedCurrency.currency,
            ),
          )
          .standardByTargetValue;

      totalInTargetCurrency += walletedCurrency.amount / conversionRate;
    }

    return totalInTargetCurrency;
  }

  Future<void> changeCurrency(Currency newCurrency) async {
    selectedTargetCurrency = newCurrency;
    Global.instance.selectedStandartCurrency = newCurrency;
    await dbHelper.saveSelectedCurrency(newCurrency);
    await getCurrencyValues();
    calculateTotalInSelectedCurrency();
    update();
  }
}
