import 'package:sui/sui.dart';

import '../common/cetus.dart';
import 'app.dart';

class CetusApi {
  String cetusPosType =
      "0x1eabed72c53feb3805120a081dc15963c204dc8d091542592abaf7a35689b2fb::position::Position";

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

        var rewards = await requestRewards(
          addr,
          poolId,
          positionId,
          coinTypeA,
          coinTypeB,
        );
        poolPosition.rewards = rewards;

        /*print("POOL ID: $poolId");
              print("POSITION ID: $positionId");
              print("FOUND POSITION: ${content.fields}");
              print("COIN TYPE A: ${coinTypeA}");
              print("COIN TYPE B: ${coinTypeB}");
              */
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
    result.reward1.coinType = t1;
    result.reward2.coinType = t2;

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
    print(
      "-------------------------------------------------------------------------",
    );
    print("<<<<<<<<<<<<<<<<<<<<<<<<<<<");
    print(res);
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print(
      "-------------------------------------------------------------------------",
    );

    res.events.forEach((element) {
      if (element.type.contains("FetchPositionRewardsEvent")) {
        //print("FETCH REWARDS: ${element.parsedJson}");
        var parsedJson = element.parsedJson;
        var data = parsedJson!["data"];
        if (data != null) {
          /*var r1 = data[0];
          var r2 = data[1];
          print("REWARD 1: ${r1}");
          print("REWARD 2: ${r2}");
          result.reward1.amount = r1;
          result.reward2.amount = r2;*/
        }
      }
      print("EVENT: ${element}");
    });

    return result;
  }
}
