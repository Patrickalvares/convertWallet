enum Currency {
  BRL(name: 'Real Brasileiro', code: 'BRL'),
  USD(name: 'Dólar Americano', code: 'USD'),
  EUR(name: 'Euro', code: 'EUR'),
  JPY(name: 'Iene Japonês', code: 'JPY'),
  GBP(name: 'Libra Esterlina', code: 'GBP'),
  CHF(name: 'Franco Suíço', code: 'CHF'),
  CNY(name: 'Yuan Chinês', code: 'CNY'),
  ;

  const Currency({
    required this.name,
    required this.code,
  });
  final String name;
  final String code;

  static Currency? fromCode(String code) {
    for (final currency in Currency.values) {
      if (currency.code == code) {
        return currency;
      }
    }
    return null;
  }
}
