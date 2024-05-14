import '../../../../core/helpers/exception/aplication_exception.dart';
import '../../domain/entities/currency_by_currency.dart';
import '../datasource/main_screen_datasource.dart';

class MainScreenRepository {
  MainScreenRepository({required this.remoteDataSource});
  final MainScreenDatasource remoteDataSource;

  Future<List<CurrencyByCurrency>> getMainScreenData({
    required String params,
  }) async {
    try {
      final response = await remoteDataSource.obterCurrencyByCurrency(
        endpoint: params,
      );

      if (response is Map<String, dynamic>) {
        final List<CurrencyByCurrency> currencies = [];
        response.forEach((key, value) {
          currencies.add(CurrencyByCurrency.fromJson(value));
        });
        return currencies;
      } else {
        throw ApplicationException('Erro ao obter dados');
      }
    } on ApplicationException catch (e) {
      throw e;
    }
  }
}
