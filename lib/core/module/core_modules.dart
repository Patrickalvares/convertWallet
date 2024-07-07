import 'package:flutter_modular/flutter_modular.dart';

import '../../features/splash/splash_controller.dart';
import '../../utils/helpers/database_helper.dart';
import '../data/rest/http.dart';
import '../data/rest/http_interface.dart';

class CoreModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.add<SplashController>(SplashController.new);
    i.add<IHttp>(Http.new);
    i.add<DatabaseHelper>(DatabaseHelper.new);

    super.exportedBinds(i);
  }
}
