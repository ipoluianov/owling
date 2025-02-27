import 'package:owling/core/base/app.dart';
import 'package:owling/core/common/cetus.dart';
import 'package:sui/builder/transaction.dart';

Future<PosFeeAmount> cetusFetchPosFeeAmount(
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
