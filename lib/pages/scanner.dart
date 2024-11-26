import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  String _scanBarcode = 'empty';
  String _bookName = 'empty';
  String _authorName = 'empty';
  String _bookCover = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Erro ao recuperar versão';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });

    //buscar livro na api por isbn
    if (_scanBarcode != '-1') {
      getBook(_scanBarcode);
    }
  }

  Future<void> getBook(String isbn) async {
    try {
      var dio = Dio();
      var response = await dio.get(
        'https://search.worldcat.org/api/search?q=$isbn',
        options: Options(
          method: 'GET',
          
        ),
      );
      if (response.statusCode == 200) {
        var data = response.data;
        var firstKey = data.keys.first;

        setState(() {
          _bookCover = 'https://search.worldcat.org/api/search?q=$isbn';
          _bookName =  data['briefRecords'][0]['title'] ??
              'Livro não encontrado';
          _authorName = data['briefRecords'][firstKey]['details']['authors'][0]
                  ['name'] ??
              'Livro não encontrado';
        });
      }
    } catch (e) {
      setState(() {
        _bookName = 'Erro ao buscar livro: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Escanear código de barras')),
        body: Builder(
          builder: (BuildContext context) {
            return Container(
              alignment: Alignment.center,
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[400],
                      padding: EdgeInsets.all(14.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                    onPressed: () => scanBarcodeNormal(),
                    child: Text(
                      'Escanear código de barras',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 50),
                  _scanBarcode != 'empty'
                      ? Text('Código: $_scanBarcode\n',
                          style: TextStyle(fontSize: 16))
                      : SizedBox(height: 0),
                  _bookName != 'empty'
                      ? Column(
                          children: [
                            Text(
                              'Livro: $_bookName - $_authorName',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            _bookCover != 'empty'
                                ? Image.network(_bookCover, height: 200)
                                : Text('Imagem da capa não disponível'),
                          ],
                        )
                      : SizedBox(height: 0)
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
