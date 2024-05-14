import 'package:flutter_modular/flutter_modular.dart';

import '../../core/module/core_modules.dart';
import 'ui/controller/main_screen_controller.dart';
import 'ui/screens/main_screen.dart';

class MainScreenModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  void binds(Injector i) {
    i.add<MainScreenController>(MainScreenController.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (_) => MainScreen(
        controller: Modular.get<MainScreenController>(),
      ),
    );
    super.routes(r);
  }
}
