import 'package:flutter/material.dart';
import 'package:owling/core/workspace/workspace.dart';

Future<Connection?> addNode(String name, String address) async {
  var conn = Connection(UniqueKey().toString(), name, address);
  await wsAddConnection(conn);
  return conn;
}

Future<Connection?> editNode(String id, String name, String address) async {
  var conn = Connection(id, name, address);
  await wsEditConnection(conn);
  return conn;
}
