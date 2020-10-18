import 'package:bitcoin_ticker/network_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiKey = DotEnv().env['coin_apiKey'];
// final myApi = "6AF4DAF1-E649-4D72-9E3F-64C7DFECF991";
final api = "https://rest.coinapi.io/v1/exchangerate/BTC/USD";

class ExchangeModel {
  Future<dynamic> getExchangeData() async {
    var url = "$api/?apiKey=$apiKey";
    NetworkHelper networkHelper = NetworkHelper(url);
    var exchangeData = await networkHelper.getData();
    return exchangeData;
  }
}
