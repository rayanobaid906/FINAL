import 'package:flutter/material.dart';

class QrScannerPage extends StatefulWidget {
  final int orderId;

  const QrScannerPage({super.key, required this.orderId});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("this is for scanner")),
        body: Center(child: Text("this is for scanner")),
      ),
    );
  }
}
  