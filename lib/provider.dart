
import 'package:flutter/cupertino.dart';

class QRC with ChangeNotifier{
  String _qr = "";
  String get qr => _qr;


  Future<void> setCode(String code) async {
    _qr = code;
    await Future.delayed(const Duration(milliseconds: 200));
    notifyListeners();
  }

}