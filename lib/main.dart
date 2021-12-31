import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrgenerator/homepage.dart';
import 'package:qrgenerator/provider.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle("QR Generator");
    setWindowMinSize(Size(900, 600));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QRC>(
      create: (_) => QRC(),
      child: const CupertinoApp(
        color: Colors.white,
        title: 'QR Generator',
        theme: CupertinoThemeData(primaryColor: CupertinoColors.activeOrange),
        home: HomePage(),
      ),
    );
  }
}
