import 'package:flutter_modular/flutter_modular.dart';

import '../../features/splash/ui/controller/splash_controller.dart';

class CoreModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.add<SplashController>(SplashController.new);

    super.exportedBinds(i);
  }
}
