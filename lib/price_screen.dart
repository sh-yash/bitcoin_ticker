import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency='USD';
  String coinValue;
  Map<String,String> coinValues={};
  bool flag=false;

  Future<void> getData() async {
   flag=true;
   try{
     var data= await CoinData().getCoinData(selectedCurrency);
     flag=false;
     setState(() {
       coinValues=data;
     });
   }
   catch (e)
    {
      print(e);
    }

  }

  Widget getPicker()
  {
    if(Platform.isIOS)
      {
        return iOSPicker();
      }
    else if(Platform.isAndroid)
      {
        return androidDropdown();
      }
    return androidDropdown();
  }

  DropdownButton<String> androidDropdown(){
    List<DropdownMenuItem<String>> dropdownItems=[];
    for(String currency in currenciesList)
    {
      var newItem= DropdownMenuItem(
        child:  Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
              value: selectedCurrency,
              items: dropdownItems,
              onChanged: (value){
                setState(() {
                  selectedCurrency=value;
                   getData();
                  print('the coin values : $coinValues');
                });
              },
            );
  }

  CupertinoPicker iOSPicker(){
    List<Widget> pickerItems=[];
    for(String currency in currenciesList)
    {
      var newItem= Text(currency);
      pickerItems.add(newItem);
    }
    return CupertinoPicker(itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
      setState(() {
        selectedCurrency=currenciesList[selectedIndex];
        getData();
      });
        },
        children: pickerItems);
  }


   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: crypto,
          selectedCurrency: selectedCurrency,
          value: flag ? '?' : coinValues[crypto],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
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

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    this.value,
    this.selectedCurrency,
    this.cryptoCurrency,
  });

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}