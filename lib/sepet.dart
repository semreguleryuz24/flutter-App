import 'package:flutter/material.dart';
import 'package:flutter_makbul1/database/dbcontroller.dart';
import 'package:flutter_makbul1/database/dblocal.dart';

class Sepet extends StatefulWidget {
  Sepet({Key? key}) : super(key: key);

  @override
  State<Sepet> createState() => _SepetState();
}

class _SepetState extends State<Sepet> {
  DbController dbController = DbController();
  List<DbCart> cartItemList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sepetim"),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            for (int i = 0; i < cartItemList.length; i++)
              Text("${cartItemList[i].prodName} : "),
          ]),
        ));
  }
}
