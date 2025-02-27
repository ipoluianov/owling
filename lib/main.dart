import 'dart:io';

import 'package:flutter/material.dart';
import 'package:owling/core/route_generator.dart';
import 'package:owling/forms/nodes/main_form/main_form.dart';

void main() {
  FontWeight fontWeight = FontWeight.w400;

  if (Platform.isMacOS) {
    fontWeight = FontWeight.w300;
  }

  print("================ START ==============");

  runApp(
    MaterialApp(
      title: 'OWLing',
      debugShowCheckedModeBanner: false,
      home: const MainForm(),
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        fontFamily: "Roboto",
        textTheme: TextTheme(
          bodySmall: TextStyle(fontWeight: fontWeight),
          bodyLarge: TextStyle(fontWeight: fontWeight),
          bodyMedium: TextStyle(fontWeight: fontWeight),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    ),
  );

  return;
}
