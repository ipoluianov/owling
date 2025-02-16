class CetusPoolPosition {
  String id = '';
  String poolId = '';
  String coinTypeA = '';
  String coinTypeB = '';
  RewardSet rewards = RewardSet();
}

class Reward {
  String coinType = '';
  int amount = 0;
}

class RewardSet {
  Reward reward1 = Reward();
  Reward reward2 = Reward();
}

class CetusOfAddress {
  String address = '';
  List<CetusPoolPosition> positions = [];
}
