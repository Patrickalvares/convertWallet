import 'package:flutter_modular/flutter_modular.dart';

import '../../core/module/core_modules.dart';
import 'wallet_controller.dart';
import 'wallet_screen.dart';

class WalletModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  void binds(Injector i) {
    i.add<WalletController>(WalletController.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (_) => WalletScreen(
        controller: Modular.get<WalletController>(),
      ),
    );
    super.routes(r);
  }
}
