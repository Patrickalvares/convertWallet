import 'package:flutter_modular/flutter_modular.dart';

import '../../core/module/core_modules.dart';
import 'splash_controller.dart';
import 'splash_screen.dart';

class SplashModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (_) => SplashScreen(
        controller: Modular.get<SplashController>(),
      ),
    );
    super.routes(r);
  }
}
