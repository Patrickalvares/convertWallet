enum Currency {
  BRL(name: 'Real Brasileiro', code: 'BRL', sifra: 'R\$', flagEmoji: '🇧🇷'),
  USD(name: 'Dólar Americano', code: 'USD', sifra: '\$', flagEmoji: '🇺🇸'),
  EUR(name: 'Euro', code: 'EUR', sifra: '€', flagEmoji: '🇪🇺'),
  JPY(name: 'Iene Japonês', code: 'JPY', sifra: '¥', flagEmoji: '🇯🇵'),
  GBP(name: 'Libra Esterlina', code: 'GBP', sifra: '£', flagEmoji: '🇬🇧'),
  CHF(name: 'Franco Suíço', code: 'CHF', sifra: '₣', flagEmoji: '🇨🇭'),
  CNY(name: 'Yuan Chinês', code: 'CNY', sifra: '元', flagEmoji: '🇨🇳'),
  NZD(name: 'Dólar Neozelandês', code: 'NZD', sifra: '\$', flagEmoji: '🇳🇿'),
  MXN(name: 'Peso Mexicano', code: 'MXN', sifra: '\$', flagEmoji: '🇲🇽'),
  RUB(name: 'Rublo Russo', code: 'RUB', sifra: '₽', flagEmoji: '🇷🇺'),
  INR(name: 'Rúpia Indiana', code: 'INR', sifra: '₹', flagEmoji: '🇮🇳');

  const Currency({
    required this.name,
    required this.code,
    required this.sifra,
    required this.flagEmoji,
  });
  final String name;
  final String code;
  final String sifra;
  final String flagEmoji;

  static Currency? fromCode(String code) {
    for (final currency in Currency.values) {
      if (currency.code == code) {
        return currency;
      }
    }
    return null;
  }
}
