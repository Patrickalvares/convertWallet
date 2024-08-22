import 'package:flutter/material.dart';

import '../../core/global.dart';
import '../../core/entities/currency_by_currency.dart';
import '../../core/entities/currencys.dart';
import '../../core/entities/walleted_currency.dart';
import '../../core/service/currencies_service.dart';
import '../../utils/helpers/base_controller.dart';

class WalletController extends BaseController {
  WalletController({
    required CurrencyService currencyService,
  }) : _currencyService = currencyService;

  final CurrencyService _currencyService;
  bool getCurrencyValuesLoading = false;
  CurrencyByCurrency? targetCurrencyByCurrency;
  final TextEditingController walletValueController = TextEditingController();
  Currency? selectedTargetCurrency;

  Future<void> getCurrencyValues() async {
    getCurrencyValuesLoading = true;
    update();

    await _currencyService.getCurrencyValues();
    getCurrencyValuesLoading = false;
    update();
  }

  Future<void> setSourceCurrency(Currency? currency) async {
    Global.instance.selectedStandartCurrency = currency!;
    await _currencyService.getCurrencyValues();
    targetCurrencyByCurrency = Global.instance.currencies.firstWhere((element) => element.targetCurrency == selectedTargetCurrency);
    update();
  }

  Future<void> changeCurrencyToWallet(Currency currency, double amount, {VoidCallback? onAdded}) async {
    final WalletedCurrency? existingCurrency = await _currencyService.dbHelper.getWalletedCurrencyByCode(currency.code);

    if (existingCurrency != null) {
      final updatedAmount = existingCurrency.amount + amount;
      if (updatedAmount <= 0) {
        await _currencyService.dbHelper.deleteWalletedCurrency(currency.code);
      } else {
        final updatedCurrency = WalletedCurrency(currency: currency, amount: updatedAmount);
        await _currencyService.dbHelper.updateWalletedCurrency(updatedCurrency);
      }
    } else {
      final newCurrency = WalletedCurrency(currency: currency, amount: amount);
      await _currencyService.dbHelper.insertWalletedCurrency(newCurrency);
    }

    update();
    if (onAdded != null) {
      onAdded();
    }
    walletValueController.text = '';
  }

  Future<List<WalletedCurrency>> getGroupedWalletedCurrencies() async {
    final List<WalletedCurrency> walletedCurrencies = await _currencyService.dbHelper.getWalletedCurrencies();

    return walletedCurrencies;
  }

  Future<double> calculateTotalInSelectedCurrency() async {
    if (selectedTargetCurrency == null) return 0.0;

    final List<WalletedCurrency> walletedCurrencies = await _currencyService.dbHelper.getWalletedCurrencies();

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
    await _currencyService.dbHelper.saveSelectedCurrency(newCurrency);
    await getCurrencyValues();
    await calculateTotalInSelectedCurrency();
    update();
  }
}
