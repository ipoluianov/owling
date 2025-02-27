import 'dart:convert' as convert;
import 'dart:math';

import 'package:owling/core/cetus/catus_fetch_position_rewards.dart';
import 'package:owling/core/cetus/cetus_fetch_pool_object.dart';
import 'package:owling/core/cetus/cetus_fetch_pos_fee_amount.dart';
import 'package:sui/http/http.dart';
import 'package:sui/sui.dart';

import '../common/cetus.dart';
import 'app.dart';

class CetusApi {
  String cetusPosType =
      "0x1eabed72c53feb3805120a081dc15963c204dc8d091542592abaf7a35689b2fb::position::Position";

  Future<double> amountNormalize(String coinType, BigInt amount) async {
    var coinInfo = await App().getCoinInfo(coinType);
    if (coinInfo.precision == 0) {
      return amount.toDouble();
    }
    return (amount / BigInt.from(10).pow(coinInfo.precision)).toDouble();
  }

  Future<List<CetusPoolPosition>> loadCetusPositions(String addr) async {
    var ownedObjects = await App().loadOwnedObjects(addr);
    List<CetusPoolPosition> positions = [];
    for (var element in ownedObjects) {
      if (element.type != cetusPosType) {
        continue;
      }

      SuiObjectDataOptions options = SuiObjectDataOptions(
        showContent: true,
        showOwner: true,
      );
      var obj = await App().client.getObject(element.id, options: options);
      var content = obj.data!.content;

      var fields = content!.fields;
      var coinTypeA = fields["coin_type_a"]["fields"]["name"];
      var coinTypeB = fields["coin_type_b"]["fields"]["name"];
      var poolId = fields["pool"];
      var index = fields["index"];
      var liquidity = fields["liquidity"];
      var tickLowerIndex = fields["tick_lower_index"]["fields"]["bits"];
      var tickUpperIndex = fields["tick_upper_index"]["fields"]["bits"];

      //var positionId = fields["id"]["id"];

      CetusPoolPosition poolPosition = CetusPoolPosition();
      poolPosition.id = element.id;
      poolPosition.poolId = poolId;
      poolPosition.coinTypeA = coinTypeA;
      poolPosition.coinTypeB = coinTypeB;
      poolPosition.index = index;
      poolPosition.liquidity = liquidity;
      poolPosition.tickLowerIndex = tickLowerIndex;
      poolPosition.tickUpperIndex = tickUpperIndex;
      positions.add(poolPosition);

      var coinAInfo = await App().getCoinInfo(coinTypeA);
      var coinBInfo = await App().getCoinInfo(coinTypeB);

      poolPosition.coinInfoA = coinAInfo;
      poolPosition.coinInfoB = coinBInfo;

      //var poolObject = await App().client.getObject(poolPosition.poolId);
      var poolObj = await cetusFetchPoolObject(poolPosition.poolId);
      poolPosition.poolObject = poolObj;

      {
        // calc price
        // 2 ^ -64 as double
        var k = pow(2, -64);
        var kDec = coinAInfo.precision - coinBInfo.precision;
        var sqrtPriceAsNum = double.parse(poolObj.currentSqrtPrice);
        var pk = sqrtPriceAsNum * k;
        var price = pk * pk;
        price = price * pow(10, kDec);
        poolPosition.poolObject.price = price;
        //poolPosition.poolObject.price = await amountNormalize(coinTypeA, price);
      }

      var fees = await cetusFetchPosFeeAmount(
        addr,
        element.id,
        poolId,
        coinTypeA,
        coinTypeB,
      );

      poolPosition.feeA = fees.feeOwedA;
      poolPosition.feeB = fees.feeOwedB;

      var feeAsBigInt = BigInt.tryParse(fees.feeOwedA);
      var feeBAsBigInt = BigInt.tryParse(fees.feeOwedB);

      poolPosition.feeANormalized = await amountNormalize(
        coinTypeA,
        feeAsBigInt!,
      );
      poolPosition.feeBNormalized = await amountNormalize(
        coinTypeB,
        feeBAsBigInt!,
      );

      print("FEES A: ${fees.feeOwedA}");
      print("FEES B: ${fees.feeOwedB}");

      var rewards = await cetusFetchPositionRewards(
        addr,
        poolId,
        poolPosition.id,
        coinTypeA,
        coinTypeB,
      );
      poolPosition.rewards = rewards;

      if (poolPosition.poolObject.rewarders.length == 2) {
        var rewarder1 = poolPosition.poolObject.rewarders[0];
        var rewarder2 = poolPosition.poolObject.rewarders[1];
        var rewards = await cetusFetchPositionRewards(
          addr,
          poolId,
          poolPosition.id,
          coinTypeA,
          coinTypeB,
        );
        rewards.reward1.coinType = rewarder1.coinName;
        rewards.reward2.coinType = rewarder2.coinName;

        rewards.reward1.coinInfo = await App().getCoinInfo(rewarder1.coinName);
        rewards.reward2.coinInfo = await App().getCoinInfo(rewarder2.coinName);

        var reward1AsBigInt = BigInt.tryParse(rewards.reward1.amount);
        var reward2AsBigInt = BigInt.tryParse(rewards.reward2.amount);

        rewards.reward1.amountNormalized = await amountNormalize(
          rewards.reward1.coinType,
          reward1AsBigInt!,
        );

        rewards.reward2.amountNormalized = await amountNormalize(
          rewards.reward2.coinType,
          reward2AsBigInt!,
        );

        poolPosition.poolObject.coinANormalized = await amountNormalize(
          poolPosition.coinTypeA,
          BigInt.tryParse(poolPosition.poolObject.coinA)!,
        );

        poolPosition.poolObject.coinBNormalized = await amountNormalize(
          poolPosition.coinTypeB,
          BigInt.tryParse(poolPosition.poolObject.coinB)!,
        );

        poolPosition.rewards = rewards;
      }
    }

    return positions;
  }

  Future<CetusOfAddress> loadCetusInfoOfAccount(String addr) async {
    SuiObjectDataOptions options = SuiObjectDataOptions(
      showContent: true,
      showOwner: true,
    );

    var ownedObjects = await App().client.getOwnedObjects(
      addr,
      options: options,
    );

    var cetus = CetusOfAddress();
    cetus.address = addr;

    print("==================================");

    for (var element in ownedObjects.data) {
      if (element.data == null) {
        return cetus;
      }
      if (element.data!.content == null) {
        return cetus;
      }

      var content = element.data!.content;
      //print("TYPE:" + content!.type);

      if (content!.type == cetusPosType) {
        var fields = content.fields;
        var coinTypeA = fields["coin_type_a"]["fields"]["name"];
        var coinTypeB = fields["coin_type_b"]["fields"]["name"];
        var poolId = fields["pool"];
        var positionId = fields["id"]["id"];

        CetusPoolPosition poolPosition = CetusPoolPosition();
        poolPosition.id = positionId;
        poolPosition.poolId = poolId;
        poolPosition.coinTypeA = coinTypeA;
        poolPosition.coinTypeB = coinTypeB;
        cetus.positions.add(poolPosition);

        var rewards = await cetusFetchPositionRewards(
          addr,
          poolId,
          positionId,
          coinTypeA,
          coinTypeB,
        );
        poolPosition.rewards = rewards;
      }
    }

    return cetus;
  }

  Future<String> getPoolsByCoins(String coinA, String coinB) async {
    var statsUrl = "https://api-sui.cetus.zone/v2/sui/stats_pools";

    var coinTypesWitComaSeparator = "$coinA,$coinB";
    statsUrl +=
        "?order_by=-fees&limit=100&has_mining=true&has_farming=true&no_incentives=true&display_all_pools=true&coin_type=$coinTypesWitComaSeparator";

    var response = await http.get(statsUrl);
    if (response.statusCode == 200) {
      print(response.data);
      //var jsonResponse = convert.jsonDecode(response.data);
      //print("Response status: $jsonResponse");
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return "";
  }
}
