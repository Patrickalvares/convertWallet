import '../../../../core/entities/currency_by_currency.dart';
import '../../../../core/repository/main_screen_repository.dart';
import '../../../../utils/helpers/base_controller.dart';
import '../../../../utils/helpers/database_helper.dart';

class ConversorController extends BaseController {
  ConversorController({
    required this.dbHelper,
    required this.repository,
  });
  final CurrencyRepository repository;
  List<CurrencyByCurrency> currencieByCurrencys = [];
  final DatabaseHelper dbHelper;

  Future<void> initialized() async {
    currencieByCurrencys = await dbHelper.getCurrencyByCurrencies();

    update();
  }
}
