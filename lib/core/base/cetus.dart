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
      var poolObj = await fetchPoolObject(poolPosition.poolId);
      poolPosition.poolObject = poolObj;

      var fees = await fetchPosFeeAmount(
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

      var rewards = await requestRewards(
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
        var rewards = await requestRewards(
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

        poolPosition.rewards = rewards;
      }
    }

    return positions;
  }

  Future<PoolObject> fetchPoolObject(String poolAddr) async {
    var result = PoolObject();
    var options = SuiObjectDataOptions(showContent: true, showOwner: true);
    var poolObject = await App().client.getObject(poolAddr, options: options);
    var content = poolObject.data!.content;
    var fields = content!.fields;

    result.coinA = fields["coin_a"];
    result.coinB = fields["coin_b"];
    result.currentSqrtPrice = fields["current_sqrt_price"];
    result.currentTickIndex = fields["current_tick_index"]["fields"]["bits"];
    result.feeGrowthGlobalA = fields["fee_growth_global_a"];
    result.feeGrowthGlobalB = fields["fee_growth_global_b"];
    result.feeProtocolCoinA = fields["fee_protocol_coin_a"];
    result.feeProtocolCoinB = fields["fee_protocol_coin_b"];
    result.feeRate = fields["fee_rate"];
    result.index = fields["index"];
    result.isPause = fields["is_pause"];
    result.liquidity = fields["liquidity"];

    var rewarderManager = fields["rewarder_manager"]["fields"];
    result.rewarderManagerLastUpdatedTime =
        rewarderManager["last_updated_time"];
    result.rewarderManagerPointGrowthGlobal =
        rewarderManager["points_growth_global"];
    result.rewarderManagerPointReleased = rewarderManager["points_released"];

    var rewarders = rewarderManager["rewarders"];
    for (var rewarder in rewarders) {
      var rewarderObj = PoolObjectRewarder();
      var rewarderFields = rewarder["fields"];
      rewarderObj.emissionsPerSecond = rewarderFields["emissions_per_second"];
      rewarderObj.growthGlobal = rewarderFields["growth_global"];
      rewarderObj.coinName = rewarderFields["reward_coin"]["fields"]["name"];
      result.rewarders.add(rewarderObj);
    }

    //print("Field 1: " +);

    print(poolObject);
    return result;
  }

  Future<PosFeeAmount> fetchPosFeeAmount(
    String addr,
    String posId,
    String poolAddr,
    String tA,
    String tB,
  ) async {
    var tx = Transaction();
    var result = PosFeeAmount();
    result.coinA = tA;
    result.coinB = tB;

    String target =
        "0x3a5aa90ffa33d09100d7b6941ea1c0ffe6ab66e77062ddd26320c1b073aabb10::fetcher_script::fetch_position_fees";

    var typeArguments = [tA, tB];

    var args = [
      tx.object(
        "0xdaa46292632c3c4d8f31f23ea0f9b36a28ff3677e9684980e4438403a67a3d8f",
      ),
      tx.object(poolAddr),
      tx.pure.address(posId),
    ];
    tx.moveCall(target, arguments: args, typeArguments: typeArguments);
    var res = await App().client.devInspectTransactionBlock(addr, tx);

    res.events.forEach((element) {
      if (element.type.contains("FetchPositionFeesEvent")) {
        var parsedJson = element.parsedJson;
        result.feeOwedA = parsedJson!["fee_owned_a"];
        result.feeOwedB = parsedJson["fee_owned_b"];
      }
    });

    return result;
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

        var rewards = await requestRewards(
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

  Future<RewardSet> requestRewards(
    String addr,
    String poolAddr,
    String posId,
    String t1,
    String t2,
  ) async {
    var tx = Transaction();
    var result = RewardSet();
    //result.reward1.coinType = t1;
    //result.reward2.coinType = t2;

    // 0: 0x3a5aa90ffa33d09100d7b6941ea1c0ffe6ab66e77062ddd26320c1b073aabb10::fetcher_script::fetch_position_rewards
    // 1: 0xdaa46292632c3c4d8f31f23ea0f9b36a28ff3677e9684980e4438403a67a3d8f - global config
    // 2: - pool address
    // 3: - position id
    // 4: - clock address

    String target =
        "0x3a5aa90ffa33d09100d7b6941ea1c0ffe6ab66e77062ddd26320c1b073aabb10::fetcher_script::fetch_position_rewards";

    // const typeArguments = [paramItem.coinTypeA, paramItem.coinTypeB];

    var typeArguments = [t1, t2];

    var clockAddr = "0x06";
    var args = [
      tx.object(
        "0xdaa46292632c3c4d8f31f23ea0f9b36a28ff3677e9684980e4438403a67a3d8f",
      ),
      tx.object(poolAddr),
      tx.pure.address(posId),
      tx.object(clockAddr),
    ];
    tx.moveCall(target, arguments: args, typeArguments: typeArguments);
    var res = await App().client.devInspectTransactionBlock(addr, tx);

    res.events.forEach((element) {
      if (element.type.contains("FetchPositionRewardsEvent")) {
        var parsedJson = element.parsedJson;
        var data = parsedJson!["data"];
        if (data != null) {
          var r1 = data[0];
          var r2 = data[1];
          result.reward1.amount = r1;
          result.reward2.amount = r2;
        }
      }
      print("EVENT: ${element}");
    });

    return result;
  }
}
