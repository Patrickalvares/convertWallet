import 'package:coincierge/features/splash/ui/controller/splash_controller.dart';
import 'package:coincierge/utils/extensions/build_context.dart';
import 'package:flutter/material.dart';

import '../../../../core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({required this.controller, super.key});

  final SplashController controller;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
        const Duration(seconds: 2),
        () => context.navigate(AppRoutes.mainScreen.path),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}
