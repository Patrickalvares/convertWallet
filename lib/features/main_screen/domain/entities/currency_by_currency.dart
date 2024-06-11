import 'package:flutter/foundation.dart';

import '../../../../core/domain/entities/currencys.dart';

class CurrencyByCurrency {
  CurrencyByCurrency({
    required this.code,
    required this.rate,
  });

  factory CurrencyByCurrency.fromJson(String code, double rate) {
    final currency = Currency.fromCode(code);
    if (currency != null) {
      return CurrencyByCurrency(
        code: currency.code,
        rate: rate,
      );
    } else {
      throw Exception('Código de moeda desconhecido: $code');
    }
  }

  final String code;
  final double rate;
}

List<CurrencyByCurrency> parseCurrencyData(Map<String, dynamic> json) {
  final List<CurrencyByCurrency> currencies = [];
  if (json.containsKey('data')) {
    final Map<String, dynamic> data = json['data'];
    data.forEach((key, value) {
      try {
        currencies.add(CurrencyByCurrency.fromJson(key, value));
      } catch (e) {
        if (kDebugMode) {
          print('Erro ao converter moeda: $e');
        }
      }
    });
  }
  return currencies;
}
