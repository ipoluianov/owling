import 'package:owling/core/base/app.dart';
import 'package:owling/core/common/cetus.dart';
import 'package:sui/builder/transaction.dart';

Future<RewardSet> cetusFetchPositionRewards(
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
