import 'dart:ui';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../core/common_widgets/app_bar.dart';
import '../../core/common_widgets/bottom_navigation_bar.dart';
import '../../core/entities/currencys.dart';
import '../../core/entities/walleted_currency.dart';
import '../../core/global.dart';
import '../../utils/extensions/build_context.dart';
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
    widget.controller.selectedTargetCurrency = Global.instance.selectedStandartCurrency;
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
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      'Moeda:',
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
                        widget.controller.changeCurrency(newValue!);
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
                      'Valor a ser adicionado ou removido:',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.green)),
                          onPressed: () async {
                            if (widget.controller.selectedTargetCurrency != null && widget.controller.walletValueController.text.isNotEmpty) {
                              final value = double.tryParse(widget.controller.walletValueController.text.replaceAll(',', '.'));
                              if (value != null) {
                                await widget.controller.changeCurrencyToWallet(
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
                          child: const Row(
                            children: [
                              Icon(Icons.add, color: Colors.white),
                              SizedBox(width: 5),
                              Text('Adicionar', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.red)),
                          onPressed: () async {
                            if (widget.controller.selectedTargetCurrency != null && widget.controller.walletValueController.text.isNotEmpty) {
                              final value = double.tryParse(widget.controller.walletValueController.text.replaceAll(',', '.'));
                              if (value != null) {
                                await widget.controller.changeCurrencyToWallet(
                                  widget.controller.selectedTargetCurrency!,
                                  value * -1,
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
                          child: const Row(
                            children: [
                              Icon(Icons.remove, color: Colors.white),
                              SizedBox(width: 5),
                              Text('Remover', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(1000), color: Colors.blueGrey[400]),
                          height: 50,
                          width: 50,
                          child: IconButton(
                            icon: const Icon(Icons.delete_forever),
                            color: Colors.white,
                            iconSize: 25,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.blueGrey.shade50,
                                    title: Text(
                                      'Limpar carteira',
                                      style: TextStyle(color: Colors.blueGrey.shade700),
                                    ),
                                    content: Text(
                                      'Deseja realmente limpar a carteira?',
                                      style: TextStyle(
                                        color: Colors.blueGrey.shade700,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          context.pop();
                                        },
                                        child: Text('Cancelar', style: TextStyle(color: Colors.blueGrey.shade700, fontSize: 20)),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          widget.controller.deleteAllWalletedCurrencies();
                                          context.pop();
                                        },
                                        child: const Text('Limpar', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Carteira:',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blueGrey.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<List<WalletedCurrency>>(
                        future: widget.controller.getGroupedWalletedCurrencies(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Erro: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('Nenhuma moeda na carteira'));
                          } else {
                            return Column(
                              children: [
                                FutureBuilder<double>(
                                  future: widget.controller.calculateTotalInSelectedCurrency(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(child: Text('Erro: ${snapshot.error}'));
                                    } else {
                                      final totalConverted = snapshot.data ?? 0.0;
                                      return Card(
                                        color: Colors.blueGrey.shade100,
                                        margin: const EdgeInsets.symmetric(vertical: 5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Shimmer(
                                            enabled: widget.controller.getCurrencyValuesLoading,
                                            color: Colors.blueGrey.shade700,
                                            child: ListTile(
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                                              leading: Text(
                                                widget.controller.getCurrencyValuesLoading ? '' : 'Total:',
                                                style: const TextStyle(fontSize: 15),
                                              ),
                                              trailing: Text(
                                                widget.controller.getCurrencyValuesLoading ? '' : '${widget.controller.selectedTargetCurrency?.sifra ?? ''} ${totalConverted.toStringAsFixed(2).replaceAll('.', ',')}',
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      final WalletedCurrency walletedCurrency = snapshot.data![index];
                                      return Card(
                                        color: Colors.blueGrey.shade100,
                                        margin: const EdgeInsets.symmetric(vertical: 5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Shimmer(
                                            enabled: widget.controller.getCurrencyValuesLoading,
                                            color: Colors.blueGrey.shade700,
                                            child: ListTile(
                                              contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                              leading: Text(
                                                widget.controller.getCurrencyValuesLoading ? '' : walletedCurrency.currency.flagEmoji,
                                                style: const TextStyle(fontSize: 30),
                                              ),
                                              title: Text(
                                                widget.controller.getCurrencyValuesLoading ? '' : walletedCurrency.currency.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              trailing: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    widget.controller.getCurrencyValuesLoading ? '' : '${walletedCurrency.currency.sifra} ${walletedCurrency.amount.toStringAsFixed(2).replaceAll('.', ',')}',
                                                    style: const TextStyle(fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 70),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 2,
                      sigmaY: 2,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0),
                            Colors.black.withOpacity(0.05),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: const SizedBox(
                        height: 60,
                      ),
                    ),
                  ),
                ),
              ),
              StyledBottomNavigationBar(notchBottomBarController: notchBottomBarController),
            ],
          );
        },
      ),
    );
  }
}
