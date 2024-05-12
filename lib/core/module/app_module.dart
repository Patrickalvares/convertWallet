import 'package:flutter_modular/flutter_modular.dart';

import '../../features/main_screen/main_screen_module.dart';
import '../../features/splash/splash_module.dart';
import '../routes/app_routes.dart';
import 'core_modules.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];
  @override
  void routes(RouteManager r) {
    r.module(AppRoutes.splash.path, module: SplashModule());
    r.module(AppRoutes.mainScreen.path, module: MainScreenModule());

    super.routes(r);
  }
}
