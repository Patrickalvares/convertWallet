import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'core/module/app_module.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModularApp(
        module: AppModule(),
        child: MaterialApp.router(
          routerConfig: Modular.routerConfig,
        ));
  }
}
