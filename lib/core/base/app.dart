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

  Future<double> getPriceInSUI(String coinType) async {
    return 0;
  }

  //Future<double> getPriceInUSD(String coinType) async {}

  Future<CoinInfo> getCoinInfo(String coinType) async {
    if (!coinType.startsWith("0x")) {
      coinType = "0x$coinType";
    }

    if (coinInfoMap.containsKey(coinType)) {
      return coinInfoMap[coinType]!;
    }

    var coinInfo = CoinInfo();

    if (coinType == "") {
      coinInfo.name = "[empty]";
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

  Future<List<ObjectInfo>> loadOwnedObjects(String addr) async {
    List<ObjectInfo> ownedObjects = [];
    String? nextCursor;
    bool firstIteration = true;
    SuiObjectDataOptions options = SuiObjectDataOptions();
    options.showType = true;
    options.showOwner = true;
    options.showDisplay = true;
    options.showContent = false;
    while (firstIteration || nextCursor != null) {
      firstIteration = false;
      var getOwnedObjectsResult = await App().client.getOwnedObjects(
        addr,
        cursor: nextCursor,
        limit: 50,
        options: options,
      );
      if (getOwnedObjectsResult.hasNextPage) {
        nextCursor = getOwnedObjectsResult.nextCursor;
      } else {
        nextCursor = null;
      }
      for (SuiObjectResponse obj in getOwnedObjectsResult.data) {
        ObjectInfo info = ObjectInfo();
        if (obj.data == null) {
          continue;
        }
        info.id = obj.data!.objectId;
        info.type = obj.data!.type ?? "";

        if (obj.data!.owner != null) {
          if (obj.data!.owner!.addressOwner != null) {
            info.owner = obj.data!.owner!.addressOwner!;
          }
          if (obj.data!.owner!.objectOwner != null) {
            info.owner = obj.data!.owner!.objectOwner!;
          }
        }

        ownedObjects.add(info);
      }
    }

    return ownedObjects;
  }
}
