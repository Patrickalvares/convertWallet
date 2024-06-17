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

  CurrencyByCurrency copyWith({
    String? code,
    double? standardByTargetValue,
    double? targetByStandardRate,
    Currency? targetCurrency,
  }) {
    return CurrencyByCurrency(
      code: code ?? this.code,
      standardByTargetValue: standardByTargetValue ?? this.standardByTargetValue,
      targetByStandardRate: targetByStandardRate ?? this.targetByStandardRate,
      targetCurrency: targetCurrency ?? this.targetCurrency,
    );
  }

  final String code;
  final double standardByTargetValue;
  final double targetByStandardRate;
  final Currency targetCurrency;
}
