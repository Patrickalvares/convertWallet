import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../../../core/common_widgets/app_bar.dart';
import '../../../core/common_widgets/bottom_navigation_bar.dart';
import '../../../core/domain/entities/currencys.dart';
import '../controller/conversor_controller.dart';

class ConversorScreen extends StatefulWidget {
  const ConversorScreen({
    required this.controller,
    super.key,
  });
  final ConversorController controller;

  @override
  State<ConversorScreen> createState() => _ConversorScreenState();
}

class _ConversorScreenState extends State<ConversorScreen> {
  final TextEditingController amountController = TextEditingController();
  final NotchBottomBarController notchBottomBarController = NotchBottomBarController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: SimpleAppBarWidget(),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: AnimatedBuilder(
                animation: widget.controller,
                builder: (context, _) {
                  return Column(
                    children: [
                      DropdownButtonFormField<Currency>(
                        decoration: const InputDecoration(
                          labelText: 'Moeda de origem',
                          border: OutlineInputBorder(),
                        ),
                        value: widget.controller.selectedSourceCurrency,
                        onChanged: widget.controller.setSourceCurrency,
                        items: Currency.values.map<DropdownMenuItem<Currency>>((Currency currency) {
                          return DropdownMenuItem<Currency>(
                            value: currency,
                            child: Text('${currency.flagEmoji} ${currency.name} (${currency.code})'),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<Currency>(
                        decoration: const InputDecoration(
                          labelText: 'Moeda de destino',
                          border: OutlineInputBorder(),
                        ),
                        value: widget.controller.selectedTargetCurrency,
                        onChanged: widget.controller.setTargetCurrency,
                        items: Currency.values.map<DropdownMenuItem<Currency>>((Currency currency) {
                          return DropdownMenuItem<Currency>(
                            value: currency,
                            child: Text('${currency.flagEmoji} ${currency.name} (${currency.code})'),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Valor',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          final amount = double.tryParse(amountController.text);
                          if (amount != null) {
                            widget.controller.convert(amount);
                          }
                        },
                        child: const Text('Converter'),
                      ),
                      const SizedBox(height: 16),
                      if (widget.controller.convertedValue != null)
                        Text(
                          'Valor convertido: ${widget.controller.convertedValue.toString()}',
                          style: const TextStyle(fontSize: 20),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          StyledBottomNavigationBar(
            notchBottomBarController: notchBottomBarController,
          ),
        ],
      ),
    );
  }
}
