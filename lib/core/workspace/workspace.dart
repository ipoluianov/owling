import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../design.dart';

String jsonString(Map<String, dynamic> json, String key, String defaultValue) {
  if (json.containsKey(key)) {
    return json[key];
  } else {
    return defaultValue;
  }
}

class Connection {
  String id;
  String name;
  String address;

  Connection(this.id, this.name, this.address);

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'address': address};

  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
      jsonString(json, "id", "---"),
      jsonString(json, "name", "---"),
      jsonString(json, "address", "---"),
    );
  }

  factory Connection.makeDefault() {
    return Connection("", "", "");
  }
}

class Workspace {
  List<Connection> connections;
  Workspace(this.connections);
  Map<String, dynamic> toJson() => {'connections': connections};
  factory Workspace.fromJson(Map<String, dynamic> json) {
    return Workspace(
      List<Connection>.from(
        json['connections'].map((model) => Connection.fromJson(model)),
      ),
    );
  }
}

Future<Workspace> readWorkspace() async {
  final prefs = await SharedPreferences.getInstance();
  var wsContent = prefs.getString("ws") ?? "{}";
  late Workspace ws;

  try {
    ws = Workspace.fromJson(jsonDecode(wsContent));
    return ws;
  } catch (ex) {
    ws = Workspace([]);
  }

  return ws;
}

Future<void> saveWorkspace(Workspace ws) async {
  final contents = jsonEncode(ws.toJson());
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("ws", contents);
}

Future<void> wsSetConnection(List<Connection> connections) async {
  var ws = await readWorkspace();
  ws.connections = connections;
  saveWorkspace(ws);
}

Future<void> wsAddConnection(Connection connection) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool("node_client_added_connection", true);
  var ws = await readWorkspace();
  ws.connections.add(connection);
  saveWorkspace(ws);
}

Future<void> wsEditConnection(Connection connection) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool("node_client_added_connection", true);
  var ws = await readWorkspace();
  for (var conn in ws.connections) {
    if (conn.id == connection.id) {
      conn.name = connection.name;
      conn.address = connection.address;
    }
  }
  saveWorkspace(ws);
}

Future<void> saveAppearance() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("palette", DesignColors.palette());
}

Future<void> loadAppearance() async {
  final prefs = await SharedPreferences.getInstance();
  String? paletteName = prefs.getString("palette");
  if (paletteName != null) {
    DesignColors.setPalette(paletteName);
  }
}

Future<void> wsRemoveConnection(String id) async {
  var ws = await readWorkspace();
  ws.connections.removeWhere((element) => element.id == id);
  saveWorkspace(ws);
}

Future<List<Connection>> wsGetConnections() async {
  var ws = await readWorkspace();
  return ws.connections;
}
