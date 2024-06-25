import '../../../core/domain/entities/currencys.dart';
import '../../../core/entities/currency_by_currency.dart';
import '../../../core/repository/main_screen_repository.dart';
import '../../../utils/helpers/base_controller.dart';
import '../../../utils/helpers/database_helper.dart';

class ConversorController extends BaseController {
  ConversorController({
    required this.dbHelper,
    required this.repository,
  });

  final CurrencyRepository repository;
  List<CurrencyByCurrency> currencies = [];
  final DatabaseHelper dbHelper;

  Currency? selectedSourceCurrency;
  Currency? selectedTargetCurrency;
  double? convertedValue;

  Future<void> initialize() async {
    currencies = await dbHelper.getCurrencyByCurrencies();
    update();
  }

  void setSourceCurrency(Currency? currency) {
    selectedSourceCurrency = currency;
    update();
  }

  void setTargetCurrency(Currency? currency) {
    selectedTargetCurrency = currency;
    update();
  }

  Future<void> convert(double amount) async {
    if (selectedSourceCurrency == null || selectedTargetCurrency == null) {
      return;
    }
 
    

    convertedValue = 2;
    update();
  }
}
