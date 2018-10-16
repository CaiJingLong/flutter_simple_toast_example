import 'package:flutter/material.dart';
import 'package:simple_toast/app.dart';
import 'package:simple_toast/simple_toast.dart';

void main() => runApp(buildApp());

Widget buildApp() {
  var app = MyApp();

  return SimpleToast(
    child: app,
  );
}
