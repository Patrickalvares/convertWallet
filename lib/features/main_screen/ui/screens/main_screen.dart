import 'package:flutter/material.dart';

import '../controller/main_screen_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({required this.controller, super.key});

  final MainScreenController controller;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isTargetByStandardRate = false;
  @override
  void initState() {
    super.initState();
    widget.controller.getCurrencyValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Valores de Câmbio',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            color: Colors.white,
            iconSize: 35,
            onPressed: () {
              widget.controller.getCurrencyValues();
            },
          ),
          IconButton(
            icon: const Icon(Icons.currency_exchange_sharp),
            color: Colors.white,
            iconSize: 35,
            onPressed: () {
              isTargetByStandardRate = !isTargetByStandardRate;
              widget.controller.update();
            },
          ),
        ],
        backgroundColor: Colors.teal,
      ),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          if (widget.controller.currencieByCurrencys.isEmpty || !widget.controller.getCurrencyValuesLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
              ),
            );
          }
          return ListView.builder(
            itemCount: widget.controller.currencieByCurrencys.length,
            itemBuilder: (context, index) {
              final currencieByCurrency = widget.controller.currencieByCurrencys[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Visibility(
                  visible: isTargetByStandardRate,
                  replacement: ListTile(
                    leading: const Icon(Icons.attach_money, color: Colors.teal),
                    title: Text(
                      '${currencieByCurrency.code}/${widget.controller.selectedCurrency.code}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '${currencieByCurrency.targetCurrency.name} / ${widget.controller.selectedCurrency.name}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.controller.selectedCurrency.sifra + currencieByCurrency.targetByStandardRate.toStringAsFixed(2),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.attach_money, color: Colors.teal),
                    title: Text(
                      '${widget.controller.selectedCurrency.code}/${currencieByCurrency.code}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '${widget.controller.selectedCurrency.name} / ${currencieByCurrency.targetCurrency.name}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currencieByCurrency.targetCurrency.sifra + currencieByCurrency.standardByTargetValue.toStringAsFixed(2),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
