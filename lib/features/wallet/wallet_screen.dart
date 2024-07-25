import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../../core/common_widgets/app_bar.dart';
import '../../core/common_widgets/bottom_navigation_bar.dart';
import '../../core/data/singleton/global.dart';
import '../../core/entities/currencys.dart';
import 'wallet_controller.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({required this.controller, super.key});
  final WalletController controller;

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  NotchBottomBarController notchBottomBarController = NotchBottomBarController(index: 2);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: SimpleAppBarWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              'Moeda a ser adicionada na carteira:',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            DropdownButtonFormField<Currency>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.blueGrey[400],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
              hint: const Text(
                'Selecione uma moeda',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              value: Global.instance.selectedStandartCurrency,
              style: const TextStyle(color: Colors.white),
              iconDisabledColor: Colors.white,
              iconEnabledColor: Colors.white,
              dropdownColor: Colors.blueGrey[400],
              onChanged: widget.controller.setSourceCurrency,
              items: Currency.values.where((currency) => currency != widget.controller.selectedTargetCurrency).map<DropdownMenuItem<Currency>>((Currency currency) {
                return DropdownMenuItem<Currency>(
                  value: currency,
                  child: Text(
                    '${currency.flagEmoji} ${currency.name} (${currency.code})',
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Valor a ser Convertido:',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              controller: widget.controller.walletValueController,
              onChanged: (value) {
                final filteredValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                if (filteredValue.isNotEmpty) {
                  if (filteredValue.length > 2) {
                    final intPart = filteredValue.substring(0, filteredValue.length - 2).replaceAll(RegExp(r'^0+'), '');
                    final decPart = filteredValue.substring(filteredValue.length - 2);
                    widget.controller.walletValueController.value = TextEditingValue(
                      text: ('$intPart,$decPart'),
                      selection: TextSelection.collapsed(offset: '$intPart,$decPart'.length),
                    );
                  } else if (filteredValue.length == 2) {
                    widget.controller.walletValueController.value = TextEditingValue(
                      text: '0,$filteredValue',
                      selection: TextSelection.collapsed(offset: '0,$filteredValue'.length),
                    );
                  } else {
                    widget.controller.walletValueController.value = TextEditingValue(
                      text: '0,0$filteredValue',
                      selection: TextSelection.collapsed(offset: '0,0$filteredValue'.length),
                    );
                  }
                  final amount = double.tryParse(widget.controller.walletValueController.text.replaceAll(',', '.'));
                  if (amount != null) {
                    widget.controller.walletValueController.text = '${Global.instance.selectedStandartCurrency.sifra} ${widget.controller.walletValueController.text.replaceAll('.', ',')}';
                  } else {}
                } else {
                  widget.controller.walletValueController.clear();
                }
              },
              decoration: InputDecoration(
                labelStyle: const TextStyle(color: Colors.white),
                hintStyle: const TextStyle(color: Colors.white),
                hintText: 'Digite o valor',
                filled: true,
                fillColor: Colors.blueGrey[400],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: StyledBottomNavigationBar(
        notchBottomBarController: notchBottomBarController,
      ),
    );
  }
}
