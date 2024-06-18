import 'package:flutter_modular/flutter_modular.dart';

import '../../core/module/core_modules.dart';
import 'ui/screen/conversor_screen.dart';

class ConversorModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  void binds(Injector i) {
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (_) => const ConversorScreen(),
    );
    super.routes(r);
  }
}
