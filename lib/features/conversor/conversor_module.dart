import 'package:flutter_modular/flutter_modular.dart';

import '../../core/module/core_modules.dart';
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
