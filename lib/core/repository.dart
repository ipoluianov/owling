import 'package:owling/core/design.dart';
import 'package:owling/core/workspace/workspace.dart';
import 'package:owling/forms/home/home_config.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';

enum NavIndex { home, units, charts, maps, more }

class Repository {
  static final Repository _singleton = Repository._internal();

  factory Repository() {
    return _singleton;
  }

  String lastPath = "/";
  Connection lastSelectedConnection = Connection.makeDefault();
  NavIndex navIndex = NavIndex.units;

  late AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> mainKeyPair;
  bool peerLoaded = false;

  void initPeer(AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keyPair) {
    mainKeyPair = keyPair;
  }

  loadHomeConfig() async {
    return HomeConfig([]);
  }

  Repository._internal();
}

bool peerInited = false;

Future<void> loadPeer() async {
  if (peerInited) {
    return;
  }

  try {
    await loadAppearance();
    DesignColors.setPalette(DesignColors.palette());
    peerInited = true;
  } catch (ex) {}
}
