import '../../../core/data/global.dart';
import '../../../core/domain/entities/currencys.dart';
import '../../../core/repository/main_screen_repository.dart';
import '../../../utils/helpers/base_controller.dart';
import '../../../utils/helpers/database_helper.dart';

class ConversorController extends BaseController {
  ConversorController({
    required this.dbHelper,
    required this.repository,
  });

  final CurrencyRepository repository;

  final DatabaseHelper dbHelper;

  Currency? selectedTargetCurrency;
  double? convertedValue;

  Future<void> initialize() async {
    _loadSelectedCurrency();
    Global.instance.currencies = await dbHelper.getCurrencyByCurrencies();
    update();
  }

  void setSourceCurrency(Currency? currency) {
    Global.instance.selectedStandartCurrency = currency!;
    update();
  }

  void setTargetCurrency(Currency? currency) {
    selectedTargetCurrency = currency;
    update();
  }

  Future<void> convert(double amount) async {
    if (selectedTargetCurrency == null) {
      return;
    }

    convertedValue = 2;
    update();
  }

  Future<void> _loadSelectedCurrency() async {
    final currency = await dbHelper.getSelectedCurrency();
    if (currency != null) {
      Global.instance.selectedStandartCurrency = currency;
    }
  }
}
