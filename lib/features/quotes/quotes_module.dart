import 'package:flutter_modular/flutter_modular.dart';

import '../../core/module/core_modules.dart';
import 'quotes_controller.dart';
import 'quotes_screen.dart';

class MainScreenModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  void binds(Injector i) {
    i.add<QuotesController>(QuotesController.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (_) => MainScreen(
        controller: Modular.get<QuotesController>(),
      ),
    );
    super.routes(r);
  }
}
