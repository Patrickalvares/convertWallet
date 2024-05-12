import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'core/module/app_module.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ModularApp(
      module: AppModule(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: Modular.routerConfig,
      ),
    );
  }
}
