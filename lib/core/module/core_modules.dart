import 'package:flutter_modular/flutter_modular.dart';

import '../datasource/local/database_helper.dart';
import '../../utils/rest/http.dart';
import '../../utils/rest/http_interface.dart';
import '../datasource/remote/currency_datasource.dart';
import '../repository/currency_repository.dart';
import '../service/currencies_service.dart';

class CoreModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.add<IHttp>(Http.new);
    i.add<DatabaseHelper>(DatabaseHelper.new);
    i.add<CurrencyDatasource>(CurrencyDatasource.new);
    i.add<CurrencyRepository>(CurrencyRepository.new);
    i.add<CurrencyService>(CurrencyService.new);

    super.exportedBinds(i);
  }
}
