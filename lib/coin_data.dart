import 'dart:convert';

import 'package:http/http.dart' as http;
const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
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

class CoinData {
  Future getCoinData(String selectedCurrency) async{

    Map<String,String> crptoPrice={};
    for(String crypto in cryptoList)
      {
        var url="https://api.nomics.com/v1/currencies/ticker?key=demo-26240835858194712a4f8cc0dc635c7a&ids=$crypto&interval=1d,30d&convert=$selectedCurrency&per-page=100&page=1";
        var response = await http.get(url);
        if (response.statusCode == 200) {

          var jsonResponse = jsonDecode(response.body);
          var itemPrice = jsonResponse[0]['price'];
             crptoPrice[crypto]=itemPrice.toString();

        } else {
          print('Request failed with status: ${response.statusCode}.');
        }

      }
    print(crptoPrice);
    return crptoPrice;
  }
}