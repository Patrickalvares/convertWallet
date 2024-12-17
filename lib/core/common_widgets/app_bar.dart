import 'package:flutter/material.dart';

import '../global.dart';

class SimpleAppBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([Global.instance]),
      builder: (context, _) {
        return AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 10),
              const Text(
                'ConvertWallet',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    Global.instance.lastUpdated != null ? '${Global.instance.lastUpdated!.day}/${Global.instance.lastUpdated!.month}/${Global.instance.lastUpdated!.year} as ${Global.instance.lastUpdated!.hour}:${Global.instance.lastUpdated!.minute}' : '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.blueGrey.shade700,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [],
        );
      },
    );
  }
}
