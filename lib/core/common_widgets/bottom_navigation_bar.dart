import 'dart:io';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../../utils/extensions/build_context.dart';
import '../routes/app_routes.dart';

class StyledBottomNavigationBar extends StatefulWidget {
  const StyledBottomNavigationBar({
    required this.notchBottomBarController,
    Key? key,
  }) : super(key: key);
  final NotchBottomBarController notchBottomBarController;

  @override
  State<StyledBottomNavigationBar> createState() => _StyledBottomNavigationBarState();
}

class _StyledBottomNavigationBarState extends State<StyledBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: Platform.isIOS ? 7 : 0,
      right: 0,
      child: AnimatedNotchBottomBar(
        notchBottomBarController: widget.notchBottomBarController,
        textOverflow: TextOverflow.visible,
        maxLine: 1,
        shadowElevation: 5,
        kBottomRadius: 50,
        color: Colors.blueGrey.shade400,
        itemLabelStyle: const TextStyle(fontSize: 15),
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: const Icon(
              Icons.price_change,
              color: Colors.white,
            ),
            activeItem: Icon(
              Icons.price_change,
              color: Colors.blueGrey[400],
            ),
            itemLabelWidget: const Text(
              'Conversor',
              style: TextStyle(fontSize: 11, color: Colors.white),
            ),
          ),
          BottomBarItem(
            inActiveItem: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            activeItem: Icon(
              Icons.home,
              color: Colors.blueGrey[400],
            ),
            itemLabelWidget: const Text(
              'Cotações',
              style: TextStyle(fontSize: 11, color: Colors.white),
            ),
          ),
          BottomBarItem(
            inActiveItem: const Icon(
              Icons.wallet,
              color: Colors.white,
            ),
            activeItem: Icon(
              Icons.wallet,
              color: Colors.blueGrey[400],
            ),
            itemLabelWidget: const Text(
              'Carteira',
              style: TextStyle(fontSize: 11, color: Colors.white),
            ),
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              context.pushreplacement(AppRoutes.conversor.path);
              break;
            case 1:
              context.pushreplacement(AppRoutes.quotes.path);
              break;
            case 2:
              context.pushreplacement(AppRoutes.wallet.path);
              break;
          }
        },
        kIconSize: 24,
      ),
    );
  }
}
