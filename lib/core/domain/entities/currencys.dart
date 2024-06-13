enum Currency {
  BRL(name: 'Real Brasileiro', code: 'BRL', sifra: 'R\$'),
  USD(name: 'Dólar Americano', code: 'USD', sifra: '\$'),
  EUR(name: 'Euro', code: 'EUR', sifra: '€'),
  JPY(name: 'Iene Japonês', code: 'JPY', sifra: '¥'),
  GBP(name: 'Libra Esterlina', code: 'GBP', sifra: '£'),
  CHF(name: 'Franco Suíço', code: 'CHF', sifra: '₣'),
  CNY(name: 'Yuan Chinês', code: 'CNY', sifra: '元'),
  ;

  const Currency({
    required this.name,
    required this.code,
    required this.sifra,
  });
  final String name;
  final String code;
  final String sifra;

  static Currency? fromCode(String code) {
    for (final currency in Currency.values) {
      if (currency.code == code) {
        return currency;
      }
    }
    return null;
  }
}
