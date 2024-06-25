import 'package:flutter_modular/flutter_modular.dart';

import '../../features/conversor/conversor_module.dart';
import '../../features/quotes/quotes_module.dart';
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
    r.module(AppRoutes.quotes.path, module: MainScreenModule());
    r.module(AppRoutes.conversor.path, module: ConversorModule());
    
    super.routes(r);
  }
}
