import 'package:flutter/material.dart';

import '../../core/data/singleton/global.dart';
import '../../core/entities/currency_by_currency.dart';
import '../../core/entities/currencys.dart';
import '../../core/service/currencies_service.dart';
import '../../utils/helpers/base_controller.dart';

class ConversorController extends BaseController {
  ConversorController({
    required CurrencyService currencyService,
  }) : _currencyService = currencyService;

  final CurrencyService _currencyService;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController outputController = TextEditingController();
  CurrencyByCurrency? targetCurrencyByCurrency;
  bool getCurrencyValuesLoading = false;

  Currency? selectedTargetCurrency;
  double? convertedValue;

  Future<void> initialize() async {
    await _currencyService.loadSelectedCurrency();
    Global.instance.currencies = await _currencyService.dbHelper.getCurrencyByCurrencies();
    targetCurrencyByCurrency = Global.instance.currencies.firstWhere((element) => element.targetCurrency == selectedTargetCurrency);
    update();
  }

  Future<void> setSourceCurrency(Currency? currency) async {
    amountController.clear();
    outputController.clear();
    Global.instance.selectedStandartCurrency = currency!;
    await _currencyService.getCurrencyValues();
    targetCurrencyByCurrency = Global.instance.currencies.firstWhere((element) => element.targetCurrency == selectedTargetCurrency);
    update();
  }

  void setTargetCurrency(Currency? currency) {
    amountController.clear();
    outputController.clear();
    selectedTargetCurrency = currency;
    targetCurrencyByCurrency = Global.instance.currencies.firstWhere((element) => element.targetCurrency == currency);
    update();
  }

  Future<void> convert(double amount) async {
    if (selectedTargetCurrency == null || amount == 0) {
      outputController.clear();
      return;
    }

    if (targetCurrencyByCurrency != null) {
      outputController.text = "${targetCurrencyByCurrency!.targetCurrency.sifra} ${(amount * targetCurrencyByCurrency!.standardByTargetValue).toStringAsFixed(2).replaceAll('.', ',')}";
    }

    update();
  }
}
