import 'package:bitcoin_ticker/crypto_card.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = "USD";
  String rate;

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (String value) {
        setState(() {
          selectedCurrency = value;
          getExchangedata();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        getExchangedata();
      },
      children: pickerItems,
    );
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getExchangedata() async {
    isWaiting = true;
    var exchangeData = await ExchangeData().getExchangeData(selectedCurrency);
    isWaiting = false;
    setState(() {
      coinValues = exchangeData;
    });
  }

  @override
  void initState() {
    super.initState();
    getExchangedata();
  }

  Column makeCryptoCards() {
    List<CryptoCard> cryptoCards = [];
    for (var cryptoCoin in cryptoList) {
      cryptoCards.add(CryptoCard(
        cryptoCurrency: cryptoCoin,
        selectedCurrency: selectedCurrency,
        value: isWaiting ? "?" : coinValues[cryptoCoin],
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoCard(
            cryptoCurrency: "ETH",
            value: isWaiting ? "?" : coinValues["ETH"],
            selectedCurrency: selectedCurrency,
          ),
          CryptoCard(
            cryptoCurrency: "BTC",
            value: isWaiting ? "?" : coinValues["BTC"],
            selectedCurrency: selectedCurrency,
          ),
          CryptoCard(
            cryptoCurrency: "LTC",
            value: isWaiting ? "?" : coinValues["LTC"],
            selectedCurrency: selectedCurrency,
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
