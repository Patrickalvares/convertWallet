import '../../../../core/domain/entities/currencys.dart';

class CurrencyByCurrency {
  CurrencyByCurrency({
    required this.code,
    required this.standardByTargetValue,
    required this.targetByStandardRate,
    required this.targetCurrency,
  });

  factory CurrencyByCurrency.fromJson(String code, double standardByTargetValue) {
    final currency = Currency.fromCode(code);
    if (currency != null) {
      return CurrencyByCurrency(
        code: currency.code,
        standardByTargetValue: standardByTargetValue,
        targetByStandardRate: 1 / standardByTargetValue,
        targetCurrency: currency,
      );
    } else {
      throw Exception('Código de moeda desconhecido: $code');
    }
  }

  final String code;
  final double standardByTargetValue;
  final double targetByStandardRate;
  final Currency targetCurrency;
}
