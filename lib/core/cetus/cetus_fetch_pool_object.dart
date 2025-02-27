import 'package:owling/core/base/app.dart';
import 'package:owling/core/common/cetus.dart';
import 'package:sui/types/objects.dart';

Future<PoolObject> cetusFetchPoolObject(String poolAddr) async {
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
  result.rewarderManagerLastUpdatedTime = rewarderManager["last_updated_time"];
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
