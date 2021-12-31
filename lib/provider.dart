
import 'package:flutter/cupertino.dart';

class QRC with ChangeNotifier{
  String _qr = "";
  String _label = "";
  String get qr => _qr;
  String get label => _label;


  Future<void> setCode(String code) async {
    _qr = code;
    if(_qr.length>10){
      _label = _qr.substring(0,15);
    }else{
      _label=_qr;
    }
    await Future.delayed(const Duration(milliseconds: 200));
    notifyListeners();
  }

}