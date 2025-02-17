// singleton class
// App is a singleton class that holds the state of the app.
// It is used to store sui client object

import 'package:sui/sui.dart';

import '../common/cetus.dart';
import 'cetus.dart';

class App {
  static final App _app = App._internal();
  static const String mainNetUrl = "https://fullnode.mainnet.sui.io";

  factory App() {
    return _app;
  }

  App._internal();

  SuiClient client = SuiClient(mainNetUrl);

  CetusApi cetusApi = CetusApi();

  var coinInfoMap = <String, CoinInfo>{};

  Future<CoinInfo> getCoinInfo(String coinType) async {
    if (coinInfoMap.containsKey(coinType)) {
      return coinInfoMap[coinType]!;
    }

    var coinInfo = CoinInfo();

    if (coinType == "") {
      coinInfo.name = "---";
      coinInfo.error = "coinType is empty";
      return coinInfo;
    }

    try {
      var getCoinMetadataResult = await client.getCoinMetadata(coinType);
      
      coinInfo.coinType = getCoinMetadataResult.id;
      coinInfo.name = getCoinMetadataResult.name;
      coinInfo.symbol = getCoinMetadataResult.symbol;
      coinInfo.precision = getCoinMetadataResult.decimals;
      coinInfo.icon = getCoinMetadataResult.iconUrl;
      coinInfoMap[coinType] = coinInfo;
    } catch (e) {
      coinInfo.name = "---";
      coinInfo.error = e.toString();
      return coinInfo;
    }

    return coinInfo;
  }
}
