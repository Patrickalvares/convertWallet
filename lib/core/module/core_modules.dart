import 'package:coincierge/features/splash/ui/controller/splash_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CoreModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.add<SplashController>(SplashController.new);

    super.exportedBinds(i);
  }
}
