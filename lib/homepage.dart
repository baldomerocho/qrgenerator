import 'dart:math';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qrgenerator/provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController content = TextEditingController();
  double sizeqr = 450.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<QRC>().setCode("");
  }

  GlobalKey globalKey = GlobalKey();

  Future<Uint8List> _capturePng() async {
    final RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage();
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();
    return pngBytes;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: CustomScrollView(
      slivers: [
        SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
            mainAxisExtent: MediaQuery.of(context).size.height,
            mainAxisSpacing: 0.0,
            crossAxisSpacing: 0.0,
            childAspectRatio: 4.0,
          ),
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/code.png",
                        height: 50,
                      ),
                      VerticalDivider(),
                      const Text("QR Generator",
                          style: TextStyle(
                              color: Color(0xFF13334C),
                              fontSize: 50,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                            color: CupertinoColors.extraLightBackgroundGray,
                            child: CupertinoTextFormFieldRow(
                              controller: content,
                              prefix: const Icon(CupertinoIcons.textformat_alt),
                              onChanged: (value) {
                                context.read<QRC>().setCode(value.toString());
                              },
                            )),
                      ),
                      ButtonBar(
                        children: [
                          CupertinoButton(
                              child:
                                  const Icon(CupertinoIcons.doc_on_clipboard),
                              onPressed: () async {
                                ClipboardData? secretoCopiado =
                                    await Clipboard.getData(
                                        Clipboard.kTextPlain);
                                context
                                    .read<QRC>()
                                    .setCode(secretoCopiado!.text.toString());
                                content.text = secretoCopiado.text!;
                              }),
                          CupertinoButton(
                              child: const Icon(CupertinoIcons.delete),
                              onPressed: () async {
                                context.read<QRC>().setCode("");
                                content.text = "";
                              }),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RepaintBoundary(
                  key: globalKey,
                  child: Container(
                    width: sizeqr,
                    height: sizeqr,
                    padding: const EdgeInsets.all(10),
                    color: CupertinoColors.white,
                    child: SfBarcodeGenerator(
                        barColor: Color(0xFF13334C),
                        backgroundColor: CupertinoColors.white,
                        value: context.watch<QRC>().qr,
                        symbology: QRCode(
                            errorCorrectionLevel: ErrorCorrectionLevel.medium)),
                  ),
                ),
                CupertinoButton(
                    color: CupertinoColors.activeOrange,
                    child: const Text("Save QR"),
                    onPressed: () async {
                      Uint8List image = await _capturePng();
                      String name = getRandomString(15);
                      await FileSaver.instance
                          .saveFile(name, image, "png", mimeType: MimeType.PNG);
                      showCupertinoDialog(
                          context: context,
                          builder: (builder) {
                            return Container(
                                color: CupertinoColors.white,
                                child: const Center(
                                    child: Text(
                                  "QR save on Downloads",
                                  style: TextStyle(fontSize: 50),
                                )));
                          });
                      await Future.delayed(const Duration(milliseconds: 1200));
                      Navigator.pop(context);
                      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Imagen guardada en Descargas")));
                    })
              ],
            ),
          ]),
        )
      ],
    ));
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
