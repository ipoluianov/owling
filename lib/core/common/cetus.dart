import 'package:owling/core/base/app.dart';

class CetusPoolPosition {
  String id = '';
  String poolId = '';
  String coinTypeA = '';
  String coinTypeB = '';
  RewardSet rewards = RewardSet();
  String index = '';
  String liquidity = '';
  int tickLowerIndex = 0;
  int tickUpperIndex = 0;

  String feeA = '';
  String feeB = '';
}

class Reward {
  String coinType = '';
  int amount = 0;
}

class PosFeeAmount {
  String coinA = '';
  String coinB = '';
  String feeOwedA = '';
  String feeOwedB = '';
}

class RewardSet {
  Reward reward1 = Reward();
  Reward reward2 = Reward();
}

class CetusOfAddress {
  String address = '';
  List<CetusPoolPosition> positions = [];
}

class AccountBalance {
  String coinType = '';
  BigInt amount = BigInt.zero;

  Future<String> amountString() async {
    var coinInfo = await App().getCoinInfo(coinType);
    if (coinInfo.precision == 0) {
      return amount.toString();
    }
    return (amount / BigInt.from(10).pow(coinInfo.precision)).toString();
  }
}

class CoinInfo {
  String coinType = '';
  String name = '';
  String symbol = '';
  int precision = 0;
  String icon = '';
  String error = '';
}

const String coinTypeSUI =
    "0x0000000000000000000000000000000000000000000000000000000000000002::sui::SUI";

class ObjectInfo {
  String id = '';
  String type = '';
  String owner = '';
  String coinType = '';
  CoinInfo coinInfo = CoinInfo();
}
