import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../core/domain/entities/currencys.dart';
import '../controller/main_screen_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({required this.controller, super.key});

  final MainScreenController controller;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isTargetByStandardRate = false;
  final buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.getCurrencyValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Coincierge',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.currency_exchange_sharp),
            color: Colors.black,
            iconSize: 30,
            onPressed: () {
              setState(() {
                isTargetByStandardRate = !isTargetByStandardRate;
              });
              widget.controller.update();
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: buscaController,
                  cursorColor: Theme.of(context).primaryColor,
                  autofillHints: ['Buscar por moeda'],
                  onChanged: widget.controller.filtrarCurrencieByCurrencys,
                  onSaved: (value) {
                    if (value != null) {
                      widget.controller.filtrarCurrencieByCurrencys(value);
                      FocusScope.of(context).unfocus();
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
                    hintText: 'Buscar por moeda',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                child: DropdownButtonFormField<Currency>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                  hint: const Text('Selecione uma moeda'),
                  value: widget.controller.selectedCurrency,
                  onChanged: (Currency? newValue) {
                    setState(() {
                      widget.controller.selectedCurrency = newValue!;
                    });
                    widget.controller.getCurrencyValues();
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
              ),
              Expanded(
                child: Visibility(
                  replacement: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Shimmer(
                        color: Colors.grey,
                        child: Card(
                          color: Colors.grey[200],
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: const ListTile(
                            leading: Text(
                              '',
                              style: TextStyle(fontSize: 24),
                            ),
                            title: Text(
                              '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              '',
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  visible: !(widget.controller.currencieByCurrencys.isEmpty || !widget.controller.getCurrencyValuesLoading),
                  child: RefreshIndicator(
                    strokeWidth: 3,
                    color: Colors.black,
                    onRefresh: () => widget.controller.getCurrencyValues(),
                    child: ListView.builder(
                      itemCount: widget.controller.currencieByCurrencysFiltred.length,
                      itemBuilder: (context, index) {
                        final currencieByCurrency = widget.controller.currencieByCurrencysFiltred[index];
                        return Card(
                          color: Colors.grey[200],
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Visibility(
                            visible: isTargetByStandardRate,
                            replacement: ListTile(
                              leading: Text(
                                currencieByCurrency.targetCurrency.flagEmoji,
                                style: const TextStyle(fontSize: 24),
                              ),
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
                                    widget.controller.selectedCurrency.sifra + currencieByCurrency.targetByStandardRate.toStringAsFixed(2).replaceAll('.', ','),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            child: ListTile(
                              leading: Text(
                                currencieByCurrency.targetCurrency.flagEmoji,
                                style: const TextStyle(fontSize: 24),
                              ),
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
                                    currencieByCurrency.targetCurrency.sifra + currencieByCurrency.standardByTargetValue.toStringAsFixed(2).replaceAll('.', ','),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
