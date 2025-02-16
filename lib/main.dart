import 'package:flutter/material.dart';
import 'package:owling/cetus.dart';
import 'package:sui/sui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Owling',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'OWLing'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _loading = false;
  double _balance = 0.0;
  String _error = "";

  String addr =
      "0x4bb32c583f8c7f81df987115d6140737a8ea0900c900c0f110d7d36485fee2a9";
  String cetusPosType =
      "0x1eabed72c53feb3805120a081dc15963c204dc8d091542592abaf7a35689b2fb::position::Position";

  late SuiClient client;
  CetusOfAddress? cetusOfAddress;

  @override
  void initState() {
    super.initState();
    client = SuiClient("https://fullnode.mainnet.sui.io");
  }

  /**
   * 
    const { clmm_pool, integrate, simulationAccount } = this.sdk.sdkOptions;
    const tx = new import_transactions6.Transaction();
    for (const paramItem of params) {
      const typeArguments = [paramItem.coinTypeA, paramItem.coinTypeB];
      const args = [
        tx.object(getPackagerConfigs(clmm_pool).global_config_id),
        tx.object(paramItem.poolAddress),
        tx.pure.address(paramItem.positionId),
        tx.object(CLOCK_ADDRESS)
      ];
      tx.moveCall({
        target: `${integrate.published_at}::${ClmmFetcherModule}::fetch_position_rewards`,
        arguments: args,
        typeArguments
      });
    }
    if (!checkInvalidSuiAddress(simulationAccount.address)) {
      throw new ClmmpoolsError(
        `this config simulationAccount: ${simulationAccount.address} is not set right`,
        "InvalidSimulateAccount" /* InvalidSimulateAccount */
      );
    }
    const simulateRes = await this.sdk.fullClient.devInspectTransactionBlock({
      transactionBlock: tx,
      sender: simulationAccount.address
    });

    var SDKConfig = {
  clmmConfig: {
    pools_id: "0xf699e7f2276f5c9a75944b37a0c5b5d9ddfd2471bf6242483b03ab2887d198d0",
    global_config_id: "0xdaa46292632c3c4d8f31f23ea0f9b36a28ff3677e9684980e4438403a67a3d8f",
    global_vault_id: "0xce7bceef26d3ad1f6d9b6f13a953f053e6ed3ca77907516481ce99ae8e588f2b",
    admin_cap_id: "0x89c1a321291d15ddae5a086c9abc533dff697fde3d89e0ca836c41af73e36a75"
  },
  cetusConfig: {
    coin_list_id: "0x8cbc11d9e10140db3d230f50b4d30e9b721201c0083615441707ffec1ef77b23",
    launchpad_pools_id: "0x1098fac992eab3a0ab7acf15bb654fc1cf29b5a6142c4ef1058e6c408dd15115",
    clmm_pools_id: "0x15b6a27dd9ae03eb455aba03b39e29aad74abd3757b8e18c0755651b2ae5b71e",
    admin_cap_id: "0x39d78781750e193ce35c45ff32c6c0c3f2941fa3ddaf8595c90c555589ddb113",
    global_config_id: "0x0408fa4e4a4c03cc0de8f23d0c2bbfe8913d178713c9a271ed4080973fe42d8f",
    coin_list_handle: "0x49136005e90e28c4695419ed4194cc240603f1ea8eb84e62275eaff088a71063",
    launchpad_pools_handle: "0x5e194a8efcf653830daf85a85b52e3ae8f65dc39481d54b2382acda25068375c",
    clmm_pools_handle: "0x37f60eb2d9d227949b95da8fea810db3c32d1e1fa8ed87434fc51664f87d83cb"
  }
};
var clmmMainnet = {
  fullRpcUrl: (0, import_client2.getFullnodeUrl)("mainnet"),
  simulationAccount: {
    address: "0x0000000000000000000000000000000000000000000000000000000000000000"
  },
  cetus_config: {
    package_id: "0x95b8d278b876cae22206131fb9724f701c9444515813042f54f0a426c9a3bc2f",
    published_at: "0x95b8d278b876cae22206131fb9724f701c9444515813042f54f0a426c9a3bc2f",
    config: SDKConfig.cetusConfig
  },
  clmm_pool: {
    package_id: "0x1eabed72c53feb3805120a081dc15963c204dc8d091542592abaf7a35689b2fb",
    published_at: "0xdc67d6de3f00051c505da10d8f6fbab3b3ec21ec65f0dc22a2f36c13fc102110",
    config: SDKConfig.clmmConfig
  },
  integrate: {
    package_id: "0x996c4d9480708fb8b92aa7acf819fb0497b5ec8e65ba06601cae2fb6db3312c3",
    published_at: "0x3a5aa90ffa33d09100d7b6941ea1c0ffe6ab66e77062ddd26320c1b073aabb10"
  },
  deepbook: {
    package_id: "0x000000000000000000000000000000000000000000000000000000000000dee9",
    published_at: "0x000000000000000000000000000000000000000000000000000000000000dee9"
  },
  deepbook_endpoint_v2: {
    package_id: "0xac95e8a5e873cfa2544916c16fe1461b6a45542d9e65504c1794ae390b3345a7",
    published_at: "0xac95e8a5e873cfa2544916c16fe1461b6a45542d9e65504c1794ae390b3345a7"
  },
  aggregatorUrl: "https://api-sui.cetus.zone/router",
  swapCountUrl: "https://api-sui.cetus.zone/v2/sui/swap/count",
  statsPoolsUrl: "https://api-sui.cetus.zone/v2/sui/stats_pools"
};


   */

  Future<RewardSet> requestRewards(
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
    var res = await client.devInspectTransactionBlock(addr, tx);
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

  void loadCetusInfo() async {
    SuiObjectDataOptions options = SuiObjectDataOptions(
      showContent: true,
      showOwner: true,
    );

    var ownedObjects = await client.getOwnedObjects(addr, options: options);

    var cetus = CetusOfAddress();
    cetus!.address = addr;

    print("==================================");

    for (var element in ownedObjects.data) {
      if (element.data == null) {
        return;
      }
      if (element.data!.content == null) {
        return;
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

    setState(() {
      cetusOfAddress = cetus;
    });
  }

  void _incrementCounter() {
    loadCetusInfo();
    //return;
    setState(() {
      _loading = true;
    });

    client
        .getBalance(
          "0x4bb32c583f8c7f81df987115d6140737a8ea0900c900c0f110d7d36485fee2a9",
        )
        .then((value) {
          setState(() {
            _balance = value.totalBalance / BigInt.from(10).pow(9);
            _loading = false;
            _error = "";
          });
        })
        .catchError((error) {
          setState(() {
            _loading = false;
            _error = error.toString();
          });
        });
  }

  Widget buildCetusInfo() {
    if (cetusOfAddress == null) {
      return const SizedBox();
    }

    return Column(
      children: [
        Text("Address: ${cetusOfAddress!.address}"),
        for (var position in cetusOfAddress!.positions)
          Column(
            children: [
              Text("Pool ID: ${position.poolId}"),
              Text("Position ID: ${position.id}"),
              Text("Coin Type A: ${position.coinTypeA}"),
              Text("Coin Type B: ${position.coinTypeB}"),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Your balance is:'),
            Text(
              '$_balance SUI',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (_loading)
              const SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(),
              )
            else
              const SizedBox(width: 64, height: 64),
            if (_error.isNotEmpty) Text('Error: $_error') else const SizedBox(),
            buildCetusInfo(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Update',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
