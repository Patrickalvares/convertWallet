class CurrencyByCurrency {
  CurrencyByCurrency({
    required this.code,
    required this.codeIn,
    required this.name,
    required this.highValue,
    required this.lowValue,
    required this.varBid,
    required this.pctChange,
    required this.bid,
    required this.ask,
    required this.timestamp,
    required this.createDate,
  });

  factory CurrencyByCurrency.fromJson(Map<String, dynamic> json) => CurrencyByCurrency(
        code: json['code'],
        codeIn: json['codein'],
        name: json['name'],
        highValue: json['high'],
        lowValue: json['low'],
        varBid: json['varBid'],
        pctChange: json['pctChange'],
        bid: json['bid'],
        ask: json['ask'],
        timestamp: json['timestamp'],
        createDate: json['create_date'],
      );

  final String code;
  final String codeIn;
  final String name;
  final String highValue;
  final String lowValue;
  final String varBid;
  final String pctChange;
  final String bid;
  final String ask;
  final String timestamp;
  final String createDate;
}
