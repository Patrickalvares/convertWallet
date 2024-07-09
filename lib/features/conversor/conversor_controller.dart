import 'package:flutter/material.dart';

import '../../core/data/singleton/global.dart';
import '../../core/entities/currency_by_currency.dart';
import '../../core/entities/currencys.dart';
import '../../core/repository/currency_repository.dart';
import '../../utils/helpers/base_controller.dart';
import '../../utils/helpers/database_helper.dart';

class ConversorController extends BaseController {
  ConversorController({
    required this.dbHelper,
    required this.repository,
  });
  final TextEditingController outputController = TextEditingController();
  final CurrencyRepository repository;
  CurrencyByCurrency? targetCurrency;
  bool getCurrencyValuesLoading = false;

  final DatabaseHelper dbHelper;

  Currency? selectedTargetCurrency;
  double? convertedValue;

  Future<void> initialize() async {
    _loadSelectedCurrency();
    Global.instance.currencies = await dbHelper.getCurrencyByCurrencies();
    targetCurrency = Global.instance.currencies.firstWhere((element) => element.targetCurrency == selectedTargetCurrency);
    update();
  }

  void setSourceCurrency(Currency? currency) {
    Global.instance.selectedStandartCurrency = currency!;
    getCurrencyValues();
  }

  void setTargetCurrency(Currency? currency) {
    selectedTargetCurrency = currency;
    targetCurrency = Global.instance.currencies.firstWhere((element) => element.targetCurrency == selectedTargetCurrency);
    update();
  }

  Future<void> convert(double amount) async {
    if (selectedTargetCurrency == null || amount == 0) {
      outputController.clear();

      return;
    }

    if (targetCurrency != null) outputController.text = "${targetCurrency!.targetCurrency.sifra} ${(amount * targetCurrency!.standardByTargetValue).toStringAsFixed(2).replaceAll('.', ',')}";

    update();
  }

  Future<void> _loadSelectedCurrency() async {
    final currency = await dbHelper.getSelectedCurrency();
    if (currency == null) return;
    Global.instance.selectedStandartCurrency = currency;
    if (currency == Currency.BRL) {
      selectedTargetCurrency = Currency.USD;
    } else {
      selectedTargetCurrency = Currency.BRL;
    }
    update();
  }

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
