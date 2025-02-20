import 'package:owling/core/design.dart';
import 'package:owling/core/workspace/workspace.dart';
import 'package:owling/forms/home/home_config.dart';

enum NavIndex { home, cetus, more }

class Repository {
  static final Repository _singleton = Repository._internal();

  factory Repository() {
    return _singleton;
  }

  String lastPath = "/";
  Connection lastSelectedConnection = Connection.makeDefault();
  NavIndex navIndex = NavIndex.home;

  bool peerLoaded = false;

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
