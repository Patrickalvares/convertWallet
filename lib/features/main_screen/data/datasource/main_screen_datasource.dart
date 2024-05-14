import '../../../../core/data/rest/http_interface.dart';
import '../../../../core/helpers/exception/aplication_exception.dart';

class MainScreenDatasource {
  MainScreenDatasource({required this.http});
  final IHttp http;

  Future<dynamic> obterCurrencyByCurrency({
    required String endpoint,
  }) async {
    try {
      final response = await http.get(
        endpoint: endpoint,
        baseUrl: 'https://economia.awesomeapi.com.br/json/last/',
      );
      if (response.statusCode == 200) {
        return response.data;
      }
      throw ApplicationException(response.data['error'] ?? 'erroGenerico');
    } on HttpFailure catch (e, s) {
      throw ApplicationException(e.message, stackTrace: s);
    }
  }
}
