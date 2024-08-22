import '../../utils/helpers/aplication_exception.dart';
import '../datasource/remote/currency_datasource.dart';
import '../entities/currency_by_currency.dart';

class CurrencyRepository {
  CurrencyRepository({required this.remoteDataSource});
  final CurrencyDatasource remoteDataSource;

  Future<List<CurrencyByCurrency>> obterCurrencyByCurrency({
    required String params,
  }) async {
    try {
      final response = await remoteDataSource.obterCurrencyByCurrency(
        endpoint: params,
      );

      final List<CurrencyByCurrency> currencies = [];
      if (response.containsKey('data')) {
        final data = response['data'] as Map<String, dynamic>;
        data.forEach((key, value) {
          if (key == 'USD' || key == 'EUR' || key == 'BRL') {
            currencies.insertAll(0, [CurrencyByCurrency.fromJson(key, value)]);
          } else {
            currencies.add(CurrencyByCurrency.fromJson(key, value));
          }
        });
      }
      return currencies;
    } on ApplicationException catch (e) {
      throw e;
    }
  }
}
