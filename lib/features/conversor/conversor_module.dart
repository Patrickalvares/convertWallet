import 'package:flutter_modular/flutter_modular.dart';

import '../../core/datasource/currency_datasource.dart';
import '../../core/module/core_modules.dart';
import '../../core/repository/main_screen_repository.dart';
import 'conversor_controller.dart';
import 'conversor_screen.dart';

class ConversorModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  void binds(Injector i) {
    i.add<ConversorController>(ConversorController.new);
    i.add<CurrencyDatasource>(CurrencyDatasource.new);
    i.add<CurrencyRepository>(CurrencyRepository.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (_) => ConversorScreen(
        controller: Modular.get<ConversorController>(),
      ),
    );
    super.routes(r);
  }
}
