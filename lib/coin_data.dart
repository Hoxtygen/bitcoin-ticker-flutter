import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'NGN',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

final apiKey = DotEnv().env['coin_apiKey'];
final api = "https://rest.coinapi.io/v1/exchangerate";

class ExchangeData {
  Future getExchangeData(currency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      String requestURL = "$api/$crypto/$currency?apiKey=$apiKey";
      http.Response response = await http.get(requestURL);
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        var exchangeRate = decodedData["rate"];
        cryptoPrices[crypto] = exchangeRate.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw Exception("Problem fetching the data");
      }
    }
    return cryptoPrices;
  }
}
