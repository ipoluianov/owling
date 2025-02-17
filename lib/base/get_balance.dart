
import 'package:sui/sui.dart';

import '../common/cetus.dart';

Future<AccountBalance> getSuiBalance(SuiClient client, String address, String coinType) async {
  AccountBalance balance = AccountBalance();
  var getBalanceResult = await client.getBalance(address, coinType: coinType);
  balance.coinType = getBalanceResult.coinType;
  balance.amount = getBalanceResult.totalBalance;
  return balance;
}
