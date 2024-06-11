import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../core/data/rest/http_interface.dart';
import '../../../../core/helpers/exception/aplication_exception.dart';

class MainScreenDatasource {
  MainScreenDatasource({required this.http});
  final IHttp http;

  Future<dynamic> obterCurrencyByCurrency({
    required String endpoint,
  }) async {
    
    final String apiKey = dotenv.env['API_KEY'] ?? 'default_api_key';
    try {
      final response = await http.get(
        endpoint: endpoint,
        baseUrl: 'https://api.freecurrencyapi.com/v1/latest?apikey=$apiKey',
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
