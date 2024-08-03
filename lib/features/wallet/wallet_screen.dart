import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../../core/common_widgets/app_bar.dart';
import '../../core/common_widgets/bottom_navigation_bar.dart';
import '../../core/entities/currencys.dart';
import '../../core/entities/walleted_currency.dart';
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
  void initState() {
    super.initState();
    widget.controller.selectedTargetCurrency = Currency.BRL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: SimpleAppBarWidget(),
      ),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          return Padding(
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
                  value: widget.controller.selectedTargetCurrency,
                  style: const TextStyle(color: Colors.white),
                  iconDisabledColor: Colors.white,
                  iconEnabledColor: Colors.white,
                  dropdownColor: Colors.blueGrey[400],
                  onChanged: (Currency? newValue) {
                    widget.controller.selectedTargetCurrency = newValue;
                    widget.controller.update();
                  },
                  items: Currency.values.map<DropdownMenuItem<Currency>>((Currency currency) {
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
                    final filteredValue = value.replaceAll(RegExp(r'[^\d,]'), '');
                    if (filteredValue.isNotEmpty) {
                      final amount = double.tryParse(filteredValue.replaceAll(',', '.'));
                      if (amount != null) {
                        widget.controller.walletValueController.value = TextEditingValue(
                          text: filteredValue,
                          selection: TextSelection.collapsed(offset: filteredValue.length),
                        );
                      } else {
                        widget.controller.walletValueController.clear();
                      }
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (widget.controller.selectedTargetCurrency != null && widget.controller.walletValueController.text.isNotEmpty) {
                      final value = double.tryParse(widget.controller.walletValueController.text.replaceAll(',', '.'));
                      if (value != null) {
                        await widget.controller.addCurrencyToWallet(
                          widget.controller.selectedTargetCurrency!,
                          value,
                          onAdded: widget.controller.update,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Valor inválido')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Selecione uma moeda e insira um valor válido')),
                      );
                    }
                  },
                  child: const Text('Adicionar à Carteira'),
                ),
                const SizedBox(height: 16),
                Text(
                  'Carteira:',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blueGrey.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: FutureBuilder<List<WalletedCurrency>>(
                    future: widget.controller.getGroupedWalletedCurrencies(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Erro: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('Nenhuma moeda na carteira');
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final WalletedCurrency walletedCurrency = snapshot.data![index];
                            return ListTile(
                              title: Text(walletedCurrency.currency.name),
                              subtitle: Text(walletedCurrency.amount.toString()),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: StyledBottomNavigationBar(
        notchBottomBarController: notchBottomBarController,
      ),
    );
  }
}
