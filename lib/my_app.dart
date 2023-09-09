import 'package:qrgenerator/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:qrgenerator/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QRC>(
      create: (_) => QRC(),
      child: const CupertinoApp(
        color: CupertinoColors.white,
        title: 'QR Generator',
        theme: CupertinoThemeData(primaryColor: CupertinoColors.activeOrange),
        home: HomePage(),
      ),
    );
  }
}
